import Foundation

public struct DefaultAIClient: AIClient {
    public init() {}

    public func perform(request: AIRequest, context: AIRequestContext) async throws -> AIClientResponse {
        throw AIExecutionError.providerNotConfigured
    }
}
