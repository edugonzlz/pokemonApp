public struct PokemonList: Decodable, PaginablePokemon {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [PokemonResource]
}

public struct PokemonResource: Decodable, NamedApiResource {
    public let name: String
    public let url: String
}
