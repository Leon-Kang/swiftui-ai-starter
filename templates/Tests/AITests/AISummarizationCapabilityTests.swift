@testable import SwiftUIAIStarter
import XCTest

@MainActor
final class AISummarizationCapabilityTests: XCTestCase {
    func testExecuteReturnsDecodedStructuredSummary() async throws {
        let client = FakeAIClient(results: [.success(response(with: "First"))])
        let capability = AISummarizationCapability(
            client: client,
            cache: InMemoryAIResultCache()
        )

        let summary = try await capability.execute(
            input: SummarizationPromptInput(text: "Body"),
            context: context()
        )

        XCTAssertEqual(summary.bullets, ["First"])
    }

    func testDisabledCacheCallsClientForEveryRequest() async throws {
        let client = FakeAIClient(results: [.success(response(with: "Fresh"))])
        let capability = AISummarizationCapability(
            client: client,
            cache: InMemoryAIResultCache()
        )
        let disabledContext = context(cachePolicy: .disabled)

        _ = try await capability.execute(
            input: SummarizationPromptInput(text: "Body"),
            context: disabledContext
        )
        _ = try await capability.execute(
            input: SummarizationPromptInput(text: "Body"),
            context: disabledContext
        )

        let callCount = await client.callCount
        XCTAssertEqual(callCount, 2)
    }

    func testEphemeralCacheAvoidsDuplicateRequest() async throws {
        let client = FakeAIClient(results: [.success(response(with: "Cached"))])
        let recorder = FakeAIEventRecorder()
        let capability = AISummarizationCapability(
            client: client,
            cache: InMemoryAIResultCache(),
            recorder: recorder
        )
        let requestContext = context()

        _ = try await capability.execute(
            input: SummarizationPromptInput(text: "Body"),
            context: requestContext
        )
        _ = try await capability.execute(
            input: SummarizationPromptInput(text: "Body"),
            context: requestContext
        )

        let callCount = await client.callCount
        let events = await recorder.events
        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(events, [.started, .succeeded, .cacheHit])
    }

    func testRetryRunsOnlyWhenAllowed() async throws {
        let client = FakeAIClient(
            results: [
                .failure(.forcedFailure),
                .success(response(with: "Recovered"))
            ]
        )
        let recorder = FakeAIEventRecorder()
        let capability = AISummarizationCapability(
            client: client,
            cache: InMemoryAIResultCache(),
            recorder: recorder
        )

        let summary = try await capability.execute(
            input: SummarizationPromptInput(text: "Body"),
            context: context(allowsRetry: true)
        )

        XCTAssertEqual(summary.bullets, ["Recovered"])
        let callCount = await client.callCount
        let events = await recorder.events
        XCTAssertEqual(callCount, 2)
        XCTAssertEqual(events, [.started, .retrying, .succeeded])
    }

    func testCancellationAlwaysPropagatesPastFallback() async {
        let client = FakeAIClient(results: [.failure(.cancelled)])
        let capability = AISummarizationCapability(
            client: client,
            cache: InMemoryAIResultCache(),
            fallback: .staticValue(StructuredSummary(bullets: ["Fallback"]))
        )

        do {
            _ = try await capability.execute(
                input: SummarizationPromptInput(text: "Body"),
                context: context()
            )
            XCTFail("Expected cancellation to propagate")
        } catch is CancellationError {
        } catch {
            XCTFail("Expected CancellationError, received \(error)")
        }
    }

    func testTimeoutCanUseExplicitFallback() async throws {
        let client = FakeAIClient(
            results: [.success(response(with: "Late"))],
            delay: .seconds(1)
        )
        let fallback = StructuredSummary(bullets: ["Fallback"])
        let capability = AISummarizationCapability(
            client: client,
            cache: InMemoryAIResultCache(),
            fallback: .staticValue(fallback)
        )

        let summary = try await capability.execute(
            input: SummarizationPromptInput(text: "Body"),
            context: context(timeout: 0.01)
        )

        XCTAssertEqual(summary, fallback)
    }

    func testInMemoryCacheRejectsPersistedPolicy() async {
        let capability = AISummarizationCapability(
            client: FakeAIClient(results: [.success(response(with: "Value"))]),
            cache: InMemoryAIResultCache()
        )

        do {
            _ = try await capability.execute(
                input: SummarizationPromptInput(text: "Body"),
                context: context(cachePolicy: .persisted)
            )
            XCTFail("Expected an unsupported cache policy error")
        } catch let error as AIExecutionError {
            XCTAssertEqual(error, .unsupportedCachePolicy)
        } catch {
            XCTFail("Expected AIExecutionError, received \(error)")
        }
    }

    func testInvalidTimeoutThrowsInsteadOfCrashing() async {
        let capability = AISummarizationCapability(
            client: FakeAIClient(results: [.success(response(with: "Value"))]),
            cache: InMemoryAIResultCache()
        )

        do {
            _ = try await capability.execute(
                input: SummarizationPromptInput(text: "Body"),
                context: context(timeout: 0)
            )
            XCTFail("Expected an invalid timeout error")
        } catch let error as AIExecutionError {
            XCTAssertEqual(error, .invalidTimeout)
        } catch {
            XCTFail("Expected AIExecutionError, received \(error)")
        }
    }

    private func context(
        timeout: TimeInterval = 1,
        allowsRetry: Bool = false,
        cachePolicy: AICachePolicy = .ephemeral
    ) -> AIRequestContext {
        AIRequestContext(
            feature: "ExampleFeature",
            timeout: timeout,
            allowsRetry: allowsRetry,
            telemetry: AITelemetry(scope: "tests"),
            cachePolicy: cachePolicy
        )
    }

    private func response(with bullet: String) -> AIClientResponse {
        let rawText = "{\"bullets\":[\"\(bullet)\"]}"
        return AIClientResponse(rawText: rawText, rawJSON: Data(rawText.utf8))
    }
}
