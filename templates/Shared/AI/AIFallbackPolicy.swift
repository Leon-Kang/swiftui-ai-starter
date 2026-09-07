import Foundation

public enum AIFallbackPolicy<Output: Sendable>: Sendable {
    case staticValue(Output)
    case rethrowError
}
