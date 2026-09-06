import Foundation

struct SummarizationPromptBuilder: PromptBuilder {
    func buildPrompt(from input: SummarizationPromptInput) -> String {
        "Summarize the following content into concise bullet points:\n\n\(input.text)"
    }

    func schema() -> String? {
        "{\"type\":\"object\",\"properties\":{\"bullets\":{\"type\":\"array\",\"items\":{\"type\":\"string\"}}},\"required\":[\"bullets\"]}"
    }
}
