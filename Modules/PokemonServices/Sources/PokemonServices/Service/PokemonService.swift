import Foundation
import CommonCore
import Combine

public protocol PokemonServiceProtocol {
    func getPokemons(pagination: PaginationParameters?, completion: @escaping (Result<PokemonList, Error>) -> Void)
    func getPokemon(id: Int, completion: @escaping (Result<Pokemon, Error>) -> Void)
    func getPokemon(name: String, completion: @escaping (Result<Pokemon, Error>) -> Void)

    func getPokemons(pagination: PaginationParameters?) -> AnyPublisher<PokemonList, Error>
    func getPokemon(id: Int) -> AnyPublisher<Pokemon, Error>
    func getPokemon(name: String) -> AnyPublisher<Pokemon, Error>
}

public class PokemonService<Cache: PokemonCacheProtocol>: PokemonServiceProtocol {

    private let apiClient: ApiClientProtocol
    private let pokemonCache: Cache

    public init(apiClient: ApiClientProtocol = ApiClient(),
                pokemonCache: Cache = PokemonCache() as! Cache) {
        self.apiClient = apiClient
        self.pokemonCache = pokemonCache
    }
}

//MARK - Result
public extension PokemonService {
    func getPokemons(pagination: PaginationParameters?, completion: @escaping (Result<PokemonList, Error>) -> Void) {
        do {
            let urlRequest = try Endpoints.getPokemons(pagination: pagination).makeRequest()
            apiClient.request(urlRequest: urlRequest,
                              completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    func getPokemon(id: Int, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        do {
            let urlRequest = try Endpoints.getPokemonById(id).makeRequest()
            apiClient.request(urlRequest: urlRequest,
                              completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    func getPokemon(name: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        if let pokemon = pokemonCache.value(forKey: name) {
            return completion(.success(pokemon))
        }

        do {
            let urlRequest = try Endpoints.getPokemonByName(name).makeRequest()
            apiClient.request(urlRequest: urlRequest) { (result: (Result<Pokemon, Error>)) in
                switch result {
                case .success(let data):
                    self.pokemonCache.insert(data, forKey: data.name)
                    completion(.success(data))
                case .failure:
                    completion(result)
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}

//MARK - Combine
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
        do {
            let urlRequest = try Endpoints.getPokemonById(id).makeRequest()
            return apiClient.request(urlRequest: urlRequest)
        } catch {
            return Fail<Pokemon, Error>(error: error).eraseToAnyPublisher()
        }
    }

    func getPokemon(name: String) -> AnyPublisher<Pokemon, Error> {
        if let pokemon = pokemonCache.value(forKey: name) {
            return Just(pokemon)
                .mapError { error -> Error in }
                .eraseToAnyPublisher()
        }

        do {
            let urlRequest = try Endpoints.getPokemonByName(name).makeRequest()
            return apiClient.request(urlRequest: urlRequest)
                .map { (item: Pokemon) in
                    self.pokemonCache.insert(item, forKey: item.name)
                    return item
                }.eraseToAnyPublisher()

        } catch {
            return Fail<Pokemon, Error>(error: error).eraseToAnyPublisher()
        }
    }

}
