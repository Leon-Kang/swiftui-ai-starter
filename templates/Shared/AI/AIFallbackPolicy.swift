import Foundation

enum AIFallbackPolicy<Output> {
    case staticValue(Output)
    case rethrowError
}
