import Foundation

enum FakeAIClientError: Error, Sendable {
    case forcedFailure
    case cancelled
}
