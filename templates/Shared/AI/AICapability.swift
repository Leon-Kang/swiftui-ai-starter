import Foundation

protocol AICapability {
    associatedtype Input
    associatedtype Output

    func execute(input: Input, context: AIRequestContext) async throws -> Output
}
