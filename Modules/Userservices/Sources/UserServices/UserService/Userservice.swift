import Foundation
import CommonCore

public protocol UserServiceProtocol {
    func saveFavorite(pokemonName: String)
    func removeFavorite(pokemonName: String)
}

public class UserService: UserServiceProtocol {
    private enum Keys: String {
        case favorites
    }

    private let database: UserDataBaseProtocol

    init(database: UserDataBaseProtocol = UserDataBase()) {
        self.database = database
    }

    public func saveFavorite(pokemonName: String) {
        if let data = database.getData(key: Keys.favorites.rawValue),
           var favorites: Set<String> = data.dataToSet() {
            favorites.insert(pokemonName)
            updateFavorites(data: favorites.convertToData())

        } else if let data = Set([pokemonName]).convertToData() {
            updateFavorites(data: data)
        }
    }

    public func removeFavorite(pokemonName: String) {
        if let data = database.getData(key: Keys.favorites.rawValue),
           var favorites: Set<String> = data.dataToSet() {
            favorites.insert(pokemonName)
            updateFavorites(data: favorites.convertToData())
        }
    }
}

// MARK: - private
private extension UserService {
    private func updateFavorites(data: Data?) {
        guard let data = data else {
            return
        }
        database.save(data: data, key: Keys.favorites.rawValue)
    }
}
