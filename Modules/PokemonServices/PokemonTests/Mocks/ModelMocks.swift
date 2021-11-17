@testable import PokemonServices

extension Pokemon {
    static func valid() -> Pokemon {
        return Pokemon(id: 0, name: "test", order: nil, weight: nil, height: nil, sprites: nil)
    }
}

extension PokemonList {
    static func valid() -> PokemonList {
        return PokemonList(count: 20, next: nil, previous: nil, results: [])
    }
}
