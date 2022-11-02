import Foundation

public protocol SwiftCacheProtocol {
    associatedtype Key: Hashable
    associatedtype Value

    func insert(_ value: Value, forKey key: Key)
    func value(forKey key: Key) -> Value?
    func removeValue(forKey key: Key)
    func removeAll()
}
