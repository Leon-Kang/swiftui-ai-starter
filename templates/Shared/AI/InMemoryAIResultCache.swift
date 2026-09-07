import Foundation

public actor InMemoryAIResultCache: AIResultCache {
    private var storage: [String: Data] = [:]

    public init() {}

    public func value(forKey key: String, policy: AICachePolicy) throws -> Data? {
        switch policy {
        case .disabled:
            nil
        case .ephemeral:
            storage[key]
        case .persisted:
            throw AIExecutionError.unsupportedCachePolicy
        }
    }

    public func insert(_ data: Data, forKey key: String, policy: AICachePolicy) throws {
        switch policy {
        case .disabled:
            return
        case .ephemeral:
            storage[key] = data
        case .persisted:
            throw AIExecutionError.unsupportedCachePolicy
        }
    }
}
