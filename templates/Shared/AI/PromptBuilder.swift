import Foundation

public protocol PromptBuilder: Sendable {
    associatedtype Input: Sendable

    func buildRequest(from input: Input) -> AIRequest
}
