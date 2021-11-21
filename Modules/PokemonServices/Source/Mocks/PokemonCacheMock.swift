import Foundation

class PokemonCacheMock: PokemonCacheProtocol {

    var insertValueCalled = false
    var valueForKeyCalled = false
    var removeValueCalled = false
    var removeAllCalled = false

    var valueForKeyValue: Pokemon?

    func insert(_ value: Pokemon, forKey key: String) {
        insertValueCalled = true
    }

    func value(forKey key: String) -> Pokemon? {
        valueForKeyCalled = true
        return valueForKeyValue
    }

    func removeValue(forKey key: String) {
        removeValueCalled = true
    }

    func removeAll() {
        removeAllCalled = true
    }
}
