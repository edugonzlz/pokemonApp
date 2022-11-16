import Foundation
import CommonCore
import Combine

public protocol PokemonServiceProtocol {
    func save(pokemon: Pokemon)
    func remove(pokemonId: Int)

    func getPokemons(pagination: PaginationParameters?) -> AnyPublisher<PokemonList, Error>
    func getPokemon(id: Int) -> AnyPublisher<Pokemon, Error>
    func getPokemon(name: String) -> AnyPublisher<Pokemon, Error>
}

public class PokemonService: PokemonServiceProtocol {

    private let apiClient: ApiClientProtocol
    private let cache: any PokemonCacheProtocol
    private let dataBase: PokemonDataBaseProtocol

    public init(apiClient: ApiClientProtocol = ApiClient(),
                cache: any PokemonCacheProtocol = PokemonCache(),
                dataBase: PokemonDataBaseProtocol = PokemonDataBase.shared) {
        self.apiClient = apiClient
        self.cache = cache
        self.dataBase = dataBase
    }
}

public extension PokemonService {
    func save(pokemon: Pokemon) {
        dataBase.save(pokemon: pokemon)
    }

    func remove(pokemonId: Int) {
        dataBase.remove(pokemonId: pokemonId)
    }
}

public extension PokemonService {
    func getPokemons(pagination: PaginationParameters?) -> AnyPublisher<PokemonList, Error> {
        do {
            let urlRequest = try Endpoints.getPokemons(pagination: pagination).makeRequest()
            return apiClient.request(urlRequest: urlRequest)
        } catch {
            return Fail<PokemonList, Error>(error: error).eraseToAnyPublisher()
        }
    }

    func getPokemon(id: Int) -> AnyPublisher<Pokemon, Error> {
        if let pokemon = dataBase.pokemon(forId: id) {
            return Just(pokemon)
                .mapError { error -> Error in }
                .eraseToAnyPublisher()
        }

        do {
            let urlRequest = try Endpoints.getPokemonById(id).makeRequest()
            return apiClient.request(urlRequest: urlRequest)
        } catch {
            return Fail<Pokemon, Error>(error: error).eraseToAnyPublisher()
        }
    }

    func getPokemon(name: String) -> AnyPublisher<Pokemon, Error> {
        if let pokemon = cache.value(forKey: name) {
            return Just(pokemon)
                .mapError { error -> Error in }
                .eraseToAnyPublisher()
        }

        do {
            let urlRequest = try Endpoints.getPokemonByName(name).makeRequest()
            return apiClient.request(urlRequest: urlRequest)
                .map { (item: Pokemon) in
                    self.cache.insert(item, forKey: item.name)
                    return item
                }.eraseToAnyPublisher()

        } catch {
            return Fail<Pokemon, Error>(error: error).eraseToAnyPublisher()
        }
    }

}
