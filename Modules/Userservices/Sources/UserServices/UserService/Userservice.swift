import Foundation
import CommonCore

public protocol UserServiceProtocol {
    func isFavorite(pokemonId: Int) -> Bool
    func toggleFavorite(pokemonId: Int) -> Bool
}

public class UserService: UserServiceProtocol {

    private let database: UserDataBaseProtocol

    public init(database: UserDataBaseProtocol = UserDataBase()) {
        self.database = database
    }

    public func isFavorite(pokemonId: Int) -> Bool {
        database.isFavorite(pokemonId: pokemonId)
    }

    public func toggleFavorite(pokemonId: Int) -> Bool {
        if database.favorites().contains(pokemonId) {
            database.removeFavorite(pokemonId: pokemonId)
            return false
        } else {
            database.saveFavorite(pokemonId: pokemonId)
            return true
        }
    }
}
