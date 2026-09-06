import Foundation

struct DefaultAIClient: AIClient {
    func perform(
        prompt: String,
        schema: String?,
        context: AIRequestContext
    ) async throws -> AIClientResponse {
        throw NSError(
            domain: "AIClient",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Implement provider adapter in project-specific layer."]
        )
    }
}
