import Foundation

public enum AIEvent: Equatable, Sendable {
    case started
    case cacheHit
    case retrying
    case succeeded
    case failed
}
