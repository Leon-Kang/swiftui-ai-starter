import SwiftUIAIStarter

public struct StarterExampleSummarizer: Sendable {
    private let capability: AISummarizationCapability

    public init(client: any AIClient = StarterExampleAIClient()) {
        capability = AISummarizationCapability(
            client: client,
            cache: InMemoryAIResultCache()
        )
    }

    public func summarize(_ text: String) async throws -> StructuredSummary {
        try await capability.execute(
            input: SummarizationPromptInput(text: text),
            context: AIRequestContext(
                feature: "StarterExample",
                allowsRetry: false,
                telemetry: AITelemetry(scope: "example"),
                cachePolicy: .disabled
            )
        )
    }
}
