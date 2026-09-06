import Foundation

struct AISummarizationCapability: AICapability {
    let client: AIClient
    let cache: AIResultCache
    let builder = SummarizationPromptBuilder()
    let fallback: AIFallbackPolicy<StructuredSummary>

    init(
        client: AIClient,
        cache: AIResultCache,
        fallback: AIFallbackPolicy<StructuredSummary> = .staticValue(StructuredSummary(bullets: []))
    ) {
        self.client = client
        self.cache = cache
        self.fallback = fallback
    }

    func execute(input: SummarizationPromptInput, context: AIRequestContext) async throws -> StructuredSummary {
        let prompt = builder.buildPrompt(from: input)
        let cacheKey = "summary::\(prompt)"

        if let cached = cache.value(forKey: cacheKey),
           let decoded = try? JSONDecoder().decode(StructuredSummary.self, from: cached) {
            return decoded
        }

        do {
            let response = try await client.perform(prompt: prompt, schema: builder.schema(), context: context)
            guard let rawJSON = response.rawJSON else {
                throw NSError(
                    domain: "AISummarizationCapability",
                    code: 2,
                    userInfo: [NSLocalizedDescriptionKey: "Missing structured response payload."]
                )
            }
            let decoded = try JSONDecoder().decode(StructuredSummary.self, from: rawJSON)
            cache.insert(rawJSON, forKey: cacheKey)
            return decoded
        } catch {
            switch fallback {
            case let .staticValue(value):
                return value
            case .rethrowError:
                throw error
            }
        }
    }
}
