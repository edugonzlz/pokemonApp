import Foundation
import Combine

public protocol UserDataBaseProtocol {
    func favorites() -> Set<FavoritePokemon>
    func favoritesPublisher() -> AnyPublisher<Set<FavoritePokemon>, Never>
    func isFavorite(pokemonId: Int) -> Bool
    func saveFavorite(_ favorite: FavoritePokemon)
    func removeFavorite(pokemonId: Int)
}

public class UserDataBase: UserDataBaseProtocol {

    private let favoritesSubject = PassthroughSubject<Set<FavoritePokemon>, Never>()

    public static let shared = UserDataBase()

    private init() {}
}

// MARK: - Favorites
public extension UserDataBase {
    func favorites() -> Set<FavoritePokemon> {
        if let data = getData(key: Keys.favorites.rawValue),
           let favorites: Set<FavoritePokemon> = data.toSet() {
            return favorites
        } else {
            let emptySet = Set<FavoritePokemon>()
            update(favorites: emptySet)
            return emptySet
        }
    }

    func favoritesPublisher() -> AnyPublisher<Set<FavoritePokemon>, Never> {
        favoritesSubject.eraseToAnyPublisher()
    }

    func isFavorite(pokemonId: Int) -> Bool {
        favorites().map{ $0.id }.contains(pokemonId)
    }

    func saveFavorite(_ favorite: FavoritePokemon) {
        var favorites = favorites()
        favorites.insert(favorite)
        update(favorites: favorites)
    }

    func removeFavorite(pokemonId: Int) {
        var favorites = favorites()
        if let element = favorites.first(where: { $0.id == pokemonId }) {
            favorites.remove(element)
        }
        update(favorites: favorites)
    }
}

// MARK: - Private
private extension UserDataBase {
    private enum Keys: String {
        case favorites
    }

    func save(data: Data, key: String) {
        UserDefaults.standard.set(data, forKey: key)
    }

    func getData(key: String) -> Data? {
        UserDefaults.standard.data(forKey: key)
    }

    func update(favorites: Set<FavoritePokemon>) {
        print("Favorites: \(favorites)")
        guard let data = favorites.toData() else {
            return
        }
        save(data: data, key: Keys.favorites.rawValue)
        favoritesSubject.send(favorites)
    }
}
