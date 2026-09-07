import Foundation
import SwiftUIAIStarter

public struct StarterExampleAIClient: AIClient {
    public init() {}

    public func perform(request: AIRequest, context: AIRequestContext) async throws -> AIClientResponse {
        let userText = request.messages.first { $0.role == .user }?.content ?? ""
        let payload = try JSONEncoder().encode(
            StructuredSummary(bullets: ["Processed \(userText.count) characters"])
        )
        return AIClientResponse(
            rawText: String(decoding: payload, as: UTF8.self),
            rawJSON: payload
        )
    }
}
