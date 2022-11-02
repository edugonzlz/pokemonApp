import CommonCore

public protocol PokemonCacheProtocol: SwiftCacheProtocol
where Key == String, Value == Pokemon {
}

public struct PokemonCache: PokemonCacheProtocol {
    public typealias Key = String
    public typealias Value = Pokemon

    private static var sharedCache = [Key: Value]()

    public init() {}

    public func insert(_ value: Value, forKey key: Key) {
        Self.sharedCache.updateValue(value, forKey: key)
    }

    public func value(forKey key: Key) -> Value? {
        Self.sharedCache[key]
    }

    public func removeValue(forKey key: Key) {
        Self.sharedCache.removeValue(forKey: key)
    }

    public func removeAll() {
        Self.sharedCache.removeAll()
    }
}
