import CryptoKit
import Foundation

public struct AISummarizationCapability: AICapability {
    private let client: any AIClient
    private let cache: any AIResultCache
    private let recorder: any AIEventRecorder
    private let builder = SummarizationPromptBuilder()
    private let fallback: AIFallbackPolicy<StructuredSummary>

    public init(
        client: any AIClient,
        cache: any AIResultCache,
        recorder: any AIEventRecorder = NoOpAIEventRecorder(),
        fallback: AIFallbackPolicy<StructuredSummary> = .rethrowError
    ) {
        self.client = client
        self.cache = cache
        self.recorder = recorder
        self.fallback = fallback
    }

    public func execute(
        input: SummarizationPromptInput,
        context: AIRequestContext
    ) async throws -> StructuredSummary {
        guard context.timeout > 0 else {
            throw AIExecutionError.invalidTimeout
        }

        if context.cancellationBehavior == .mandatory {
            try Task.checkCancellation()
        }

        let request = builder.buildRequest(from: input)
        let cacheKey = cacheKey(for: request)

        if let cached = try await cache.value(forKey: cacheKey, policy: context.cachePolicy),
           let decoded = try? JSONDecoder().decode(StructuredSummary.self, from: cached) {
            await recorder.record(.cacheHit, context: context)
            return decoded
        }

        await recorder.record(.started, context: context)

        do {
            let response = try await perform(request: request, context: context)
            guard let rawJSON = response.rawJSON else {
                throw AIExecutionError.missingStructuredResponse
            }

            let decoded = try JSONDecoder().decode(StructuredSummary.self, from: rawJSON)
            try await cache.insert(rawJSON, forKey: cacheKey, policy: context.cachePolicy)
            if context.cancellationBehavior == .mandatory {
                try Task.checkCancellation()
            }
            await recorder.record(.succeeded, context: context)
            return decoded
        } catch is CancellationError {
            await recorder.record(.failed, context: context)
            throw CancellationError()
        } catch {
            await recorder.record(.failed, context: context)
            switch fallback {
            case let .staticValue(value):
                return value
            case .rethrowError:
                throw error
            }
        }
    }

    private func perform(
        request: AIRequest,
        context: AIRequestContext
    ) async throws -> AIClientResponse {
        let maximumAttempts = context.allowsRetry ? 2 : 1

        for attempt in 1...maximumAttempts {
            do {
                return try await performOnce(request: request, context: context)
            } catch is CancellationError {
                throw CancellationError()
            } catch {
                guard attempt < maximumAttempts else {
                    throw error
                }
                await recorder.record(.retrying, context: context)
            }
        }

        preconditionFailure("AI retry loop must execute at least once.")
    }

    private func performOnce(
        request: AIRequest,
        context: AIRequestContext
    ) async throws -> AIClientResponse {
        try await withThrowingTaskGroup(of: AIClientResponse.self) { group in
            group.addTask {
                try await client.perform(request: request, context: context)
            }
            group.addTask {
                try await Task.sleep(for: .seconds(context.timeout))
                throw AIExecutionError.timedOut
            }

            defer { group.cancelAll() }
            guard let response = try await group.next() else {
                throw AIExecutionError.timedOut
            }
            return response
        }
    }

    private func cacheKey(for request: AIRequest) -> String {
        var value = "summarization:v1"
        for message in request.messages {
            value.append("|\(cacheValue(for: message.role)):\(message.content)")
        }
        value.append("|\(request.responseSchema ?? "")")
        let digest = SHA256.hash(data: Data(value.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    private func cacheValue(for role: AIMessageRole) -> String {
        switch role {
        case .system:
            "system"
        case .user:
            "user"
        }
    }
}
