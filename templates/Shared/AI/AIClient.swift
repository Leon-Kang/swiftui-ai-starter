import Foundation

protocol AIClient {
    func perform(
        prompt: String,
        schema: String?,
        context: AIRequestContext
    ) async throws -> AIClientResponse
}
