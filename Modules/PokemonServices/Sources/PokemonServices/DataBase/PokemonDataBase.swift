import Foundation
import Combine

public protocol PokemonDataBaseProtocol {
    func save(pokemon: Pokemon)
    func remove(pokemonId: Int)
    func pokemon(forId: Int) -> Pokemon?
}

public class PokemonDataBase: PokemonDataBaseProtocol {

    public static let shared = PokemonDataBase()

    private init() {}
}

// MARK: - Favorites
public extension PokemonDataBase {
    func save(pokemon: Pokemon) {
        guard let data = try? JSONEncoder().encode(pokemon) else {
            return
        }
        save(data: data, key: "\(Keys.pokemon.rawValue)_\(pokemon.id)")
        print("Save: \(pokemon.id)")
    }

    func remove(pokemonId: Int) {
        remove(key: String(pokemonId))
        print("Remove: \(pokemonId)")
    }

    func pokemon(forId id: Int) -> Pokemon? {
        guard let data = getData(key: "\(Keys.pokemon.rawValue)_\(id)"),
              let pokemon = try? JSONDecoder().decode(Pokemon.self, from: data) else {
            return nil
        }
        return pokemon
    }

}

// MARK: - Private
private extension PokemonDataBase {
    private enum Keys: String {
        case pokemon
    }

    func save(data: Data, key: String) {
        UserDefaults.standard.set(data, forKey: key)
    }

    func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }

    func getData(key: String) -> Data? {
        UserDefaults.standard.data(forKey: key)
    }
}
