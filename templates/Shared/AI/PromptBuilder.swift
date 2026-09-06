import Foundation

protocol PromptBuilder {
    associatedtype Input

    func buildPrompt(from input: Input) -> String
    func schema() -> String?
}
