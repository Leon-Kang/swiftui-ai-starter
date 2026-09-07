import Foundation

public protocol AIClient: Sendable {
    func perform(request: AIRequest, context: AIRequestContext) async throws -> AIClientResponse
}
