import Foundation

public struct AIClientResponse: Sendable {
    public let rawText: String
    public let rawJSON: Data?

    public init(rawText: String, rawJSON: Data?) {
        self.rawText = rawText
        self.rawJSON = rawJSON
    }
}
