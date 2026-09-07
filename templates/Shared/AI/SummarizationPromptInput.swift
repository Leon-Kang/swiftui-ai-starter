import Foundation

public struct SummarizationPromptInput: Sendable {
    public let text: String

    public init(text: String) {
        self.text = text
    }
}
