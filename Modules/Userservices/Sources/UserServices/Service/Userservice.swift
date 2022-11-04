import Foundation
import CommonCore
import Combine

public protocol UserServiceProtocol {
    func isFavorite(pokemonId: Int) -> Bool
    @discardableResult func toggleFavorite(pokemonId: Int) -> Bool
    func favoriteIds() -> Set<Int>
    func favoritesPublisher() -> AnyPublisher<Set<Int>, Never>
}

public class UserService: UserServiceProtocol {

    private let database: UserDataBaseProtocol

    public init(database: UserDataBaseProtocol = UserDataBase.shared) {
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

    public func favoriteIds() -> Set<Int> {
        database.favorites()
    }

    public func favoritesPublisher() -> AnyPublisher<Set<Int>, Never> {
        database.favoritesPublisher()
    }
}
