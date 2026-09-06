import XCTest

final class AISummarizationCapabilityTests: XCTestCase {
    func testExecuteReturnsDecodedStructuredSummary() async throws {
        let response = AIClientResponse(
            rawText: "{\"bullets\":[\"First\"]}",
            rawJSON: Data("{\"bullets\":[\"First\"]}".utf8)
        )
        let client = FakeAIClient(result: .success(response))
        let cache = InMemoryAIResultCache()
        let capability = AISummarizationCapability(client: client, cache: cache)

        let summary = try await capability.execute(
            input: SummarizationPromptInput(text: "Body"),
            context: AIRequestContext(
                feature: "ExampleFeature",
                telemetry: AITelemetry(scope: "tests"),
                cachePolicy: .persisted
            )
        )

        XCTAssertEqual(summary.bullets, ["First"])
    }

    func testExecuteReturnsFallbackWhenProviderFails() async throws {
        let client = FakeAIClient(result: .failure(FakeAIClientError.forcedFailure))
        let cache = InMemoryAIResultCache()
        let fallback = StructuredSummary(bullets: ["Fallback"])
        let capability = AISummarizationCapability(
            client: client,
            cache: cache,
            fallback: .staticValue(fallback)
        )

        let summary = try await capability.execute(
            input: SummarizationPromptInput(text: "Body"),
            context: AIRequestContext(
                feature: "ExampleFeature",
                telemetry: AITelemetry(scope: "tests"),
                cachePolicy: .disabled
            )
        )

        XCTAssertEqual(summary.bullets, ["Fallback"])
    }

    func testExecuteReturnsCachedValueWithoutCallingClientTwice() async throws {
        let response = AIClientResponse(
            rawText: "{\"bullets\":[\"Cached\"]}",
            rawJSON: Data("{\"bullets\":[\"Cached\"]}".utf8)
        )
        let client = FakeAIClient(result: .success(response))
        let cache = InMemoryAIResultCache()
        let capability = AISummarizationCapability(client: client, cache: cache)
        let context = AIRequestContext(
            feature: "ExampleFeature",
            telemetry: AITelemetry(scope: "tests"),
            cachePolicy: .persisted
        )

        _ = try await capability.execute(
            input: SummarizationPromptInput(text: "Body"),
            context: context
        )
        _ = try await capability.execute(
            input: SummarizationPromptInput(text: "Body"),
            context: context
        )

        XCTAssertEqual(client.callCount, 1)
    }
}
