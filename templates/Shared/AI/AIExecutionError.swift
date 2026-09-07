import Foundation

public enum AIExecutionError: Error, Equatable, Sendable {
    case invalidTimeout
    case providerNotConfigured
    case missingStructuredResponse
    case timedOut
    case unsupportedCachePolicy
}
