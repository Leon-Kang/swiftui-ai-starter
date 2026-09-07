import Foundation

public protocol AIResultCache: Sendable {
    func value(forKey key: String, policy: AICachePolicy) async throws -> Data?
    func insert(_ data: Data, forKey key: String, policy: AICachePolicy) async throws
}
