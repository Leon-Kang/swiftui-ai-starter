import Foundation

public struct StructuredSummary: Codable, Equatable, Sendable {
    public let bullets: [String]

    public init(bullets: [String]) {
        self.bullets = bullets
    }
}
