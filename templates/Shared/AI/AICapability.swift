import Foundation

public protocol AICapability: Sendable {
    associatedtype Input: Sendable
    associatedtype Output: Sendable

    func execute(input: Input, context: AIRequestContext) async throws -> Output
}
