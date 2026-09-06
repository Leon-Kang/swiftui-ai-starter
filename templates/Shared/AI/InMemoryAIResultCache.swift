import Foundation

final class InMemoryAIResultCache: AIResultCache {
    private var storage: [String: Data] = [:]

    func value(forKey key: String) -> Data? {
        storage[key]
    }

    func insert(_ data: Data, forKey key: String) {
        storage[key] = data
    }
}
