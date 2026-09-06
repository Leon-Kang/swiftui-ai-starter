import Foundation

protocol AIResultCache {
    func value(forKey key: String) -> Data?
    func insert(_ data: Data, forKey key: String)
}
