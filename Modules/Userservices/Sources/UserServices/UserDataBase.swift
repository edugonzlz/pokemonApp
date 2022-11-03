import Foundation

public protocol UserDataBaseProtocol {
    func save(data: Data, key: String)
    func getData(key: String) -> Data?
}

public class UserDataBase: UserDataBaseProtocol {

    private let userDefaults = UserDefaults.standard

    public init() {}
    
    public func save(data: Data, key: String) {
        userDefaults.set(data, forKey: key)
    }

    public func getData(key: String) -> Data? {
        userDefaults.data(forKey: key)
    }
}
