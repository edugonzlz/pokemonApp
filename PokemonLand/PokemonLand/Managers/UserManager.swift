import Foundation
import Userservices
import PokemonServices

protocol UserManagerProtocol {
    @discardableResult func toggleFavorite(pokemon: Pokemon) -> Bool
}

class UserManager: UserManagerProtocol {

    private let userService: UserServiceProtocol
    private let pokemonService: PokemonServiceProtocol

    public init(service: UserServiceProtocol = UserService(),
                pokemonService: PokemonServiceProtocol = PokemonService()) {
        self.userService = service
        self.pokemonService = pokemonService
    }

    public func toggleFavorite(pokemon: Pokemon) -> Bool {
        let isFavorite = userService.toggleFavorite(.init(id: pokemon.id, timestamp: Date.now))
        switch isFavorite {
        case true:
            pokemonService.save(pokemon: pokemon)
        case false:
            pokemonService.remove(pokemonId: pokemon.id)
        }
        return isFavorite
    }
}
