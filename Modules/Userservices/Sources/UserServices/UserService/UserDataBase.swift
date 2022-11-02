import Foundation

protocol UserDataBaseProtocol {
    func save(data: Data, key: String)
    func getData(key: String) -> Data?
}

class UserDataBase: UserDataBaseProtocol {

    private let userDefaults = UserDefaults.standard

    func save(data: Data, key: String) {
        userDefaults.set(data, forKey: key)
    }

    func getData(key: String) -> Data? {
        userDefaults.data(forKey: key)
    }
}
