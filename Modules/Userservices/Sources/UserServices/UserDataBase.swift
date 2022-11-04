import Foundation
import Combine

public protocol UserDataBaseProtocol {
    func favorites() -> Set<Int>
    func favoritesPublisher() -> AnyPublisher<Set<Int>, Never>
    func isFavorite(pokemonId: Int) -> Bool
    func saveFavorite(pokemonId: Int)
    func removeFavorite(pokemonId: Int)
}

public class UserDataBase: UserDataBaseProtocol {

    private let favoritesSubject = PassthroughSubject<Set<Int>, Never>()

    public static let shared = UserDataBase()

    private init() {}
}

// MARK: - Favorites
public extension UserDataBase {
    func favorites() -> Set<Int> {
        if let data = getData(key: Keys.favorites.rawValue),
           let favorites: Array<Int> = data.dataToArray() {
            return Set(favorites)
        } else {
            let emptySet: Set<Int> = Set([])
            updateFavorites(data: emptySet.convertToData())
            return emptySet
        }
    }

    func favoritesPublisher() -> AnyPublisher<Set<Int>, Never> {
        favoritesSubject.eraseToAnyPublisher()
    }

    func isFavorite(pokemonId: Int) -> Bool {
        favorites().contains(pokemonId)
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

    func updateFavorites(data: Data?) {
        guard let data = data else {
            return
        }
        save(data: data, key: Keys.favorites.rawValue)
        if let favorites: Array<Int> = data.dataToArray() {
            favoritesSubject.send(Set(favorites))
        }
    }
}
