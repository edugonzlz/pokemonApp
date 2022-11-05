import Foundation
import CommonCore
import Combine

public protocol UserServiceProtocol {
    func isFavorite(pokemonId: Int) -> Bool
    @discardableResult func toggleFavorite(_ favorite: FavoritePokemon) -> Bool
    func favoriteIds() -> Set<FavoritePokemon>
    func favoritesPublisher() -> AnyPublisher<Set<FavoritePokemon>, Never>
}

public class UserService: UserServiceProtocol {

    private let database: UserDataBaseProtocol

    public init(database: UserDataBaseProtocol = UserDataBase.shared) {
        self.database = database
    }

    public func isFavorite(pokemonId: Int) -> Bool {
        database.isFavorite(pokemonId: pokemonId)
    }

    public func toggleFavorite(_ favorite: FavoritePokemon) -> Bool {
        if database.isFavorite(pokemonId: favorite.id) {
            database.removeFavorite(pokemonId: favorite.id)
            return false
        } else {
            database.saveFavorite(favorite)
            return true
        }
    }

    public func favoriteIds() -> Set<FavoritePokemon> {
        database.favorites()
    }

    public func favoritesPublisher() -> AnyPublisher<Set<FavoritePokemon>, Never> {
        database.favoritesPublisher()
    }
}
