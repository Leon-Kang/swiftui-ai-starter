import Foundation

final class FakeAIClient: AIClient {
    private(set) var callCount = 0
    private let result: Result<AIClientResponse, Error>

    init(result: Result<AIClientResponse, Error>) {
        self.result = result
    }

    func perform(
        prompt: String,
        schema: String?,
        context: AIRequestContext
    ) async throws -> AIClientResponse {
        callCount += 1
        return try result.get()
    }
}
