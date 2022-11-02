import Foundation

public enum CodableSalvableError: Error {
    case unableToEncode
    case unableToDecode
    case noValue
}

public protocol CodableSalvableProtocol {
    associatedtype Key: Hashable

    func insert<T: Encodable>(_ value: T, forKey key: Key) throws
    func value<T: Decodable>(forKey key: Key) throws -> T
    func removeValue(forKey key: Key)
    func removeAll()
}

class CodableSalvable: CodableSalvableProtocol {
    typealias Key = String

    private let userDefaults = UserDefaults.standard
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder()) {
        self.decoder = decoder
        self.encoder = encoder
    }

    func insert<T>(_ value: T, forKey key: String) throws where T : Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(value)
            userDefaults.set(data, forKey: key)
        } catch {
            throw CodableSalvableError.unableToEncode
        }
    }

    func value<T: Decodable>(forKey key: String) throws -> T  {
        guard let data = userDefaults.data(forKey: key) else {
            throw CodableSalvableError.noValue
        }
        do {
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            throw CodableSalvableError.unableToDecode
        }
    }

    func removeValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }

    func removeAll() {
        guard let domain = Bundle.main.bundleIdentifier else {
            return
        }
        userDefaults.removePersistentDomain(forName: domain)
        userDefaults.synchronize()
    }
}
