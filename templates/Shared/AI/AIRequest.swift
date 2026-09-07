import Foundation

public struct AIRequest: Sendable {
    public let messages: [AIMessage]
    public let responseSchema: String?

    public init(messages: [AIMessage], responseSchema: String?) {
        self.messages = messages
        self.responseSchema = responseSchema
    }
}
