import Foundation

public struct AIMessage: Sendable {
    public let role: AIMessageRole
    public let content: String

    public init(role: AIMessageRole, content: String) {
        self.role = role
        self.content = content
    }
}
