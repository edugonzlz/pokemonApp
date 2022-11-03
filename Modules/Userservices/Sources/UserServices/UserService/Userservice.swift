import Foundation
import CommonCore

public protocol UserServiceProtocol {
    func isFavorite(pokemonId: Int) -> Bool
    func toggleFavorite(pokemonId: Int) -> Bool
}

public class UserService: UserServiceProtocol {
    private enum Keys: String {
        case favorites
    }

    private let database: UserDataBaseProtocol

    public init(database: UserDataBaseProtocol = UserDataBase()) {
        self.database = database
    }

    public func isFavorite(pokemonId: Int) -> Bool {
        return favorites().contains(pokemonId)
    }

    public func toggleFavorite(pokemonId: Int) -> Bool {
        if favorites().contains(pokemonId) {
            removeFavorite(pokemonId: pokemonId)
            return false
        } else {
            saveFavorite(pokemonId: pokemonId)
            return true
        }
    }
}

// MARK: - Favorites
private extension UserService {
    func favorites() -> Set<Int> {
        if let data = database.getData(key: Keys.favorites.rawValue),
           let favorites: Array<Int> = data.dataToArray() {
            return Set(favorites)
        } else {
            let emptySet: Set<Int> = Set([])
            updateFavorites(data: emptySet.convertToData())
            return emptySet
        }
    }

    func saveFavorite(pokemonId: Int) {
        var favorites = favorites()
        favorites.insert(pokemonId)
        updateFavorites(data: favorites.convertToData())
        print("Favorites: \(favorites)")
    }

    func removeFavorite(pokemonId: Int) {
        var favorites = favorites()
        favorites.remove(pokemonId)
        updateFavorites(data: favorites.convertToData())
        print("Favorites: \(favorites)")
    }

    func updateFavorites(data: Data?) {
        guard let data = data else {
            return
        }
        database.save(data: data, key: Keys.favorites.rawValue)
    }
}
