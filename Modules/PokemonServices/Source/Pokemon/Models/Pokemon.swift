extension Pokemon: Hashable {
    public static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id
    }
}

public struct Pokemon: Decodable {
    public let id: Int
    public let name: String
    public let order: Int?
    public let weight: Int?
    public let height: Int?
    public let sprites: PokemonSprites?
//    let baseExperience: Int?
//    let isDefault: Bool?
//    let abilities: [PokemonAbility]
//    let forms: [PokemonForm]
//    let gameIndices: [VersionGameIndex]
//    let heldItems: [PokemonHeldItem]
//    let locationAreaEncounters: String?
//    let moves: [PokemonMove]
//    let pastTypes: [PokemonTypePast]
//    let species: PokemonSpecies
//    let stats: [PokemonStat]
//    let types: [PokemonType]

    public var image: URL? {
        guard let image = sprites?.frontDefault else {
            return nil
        }
        return URL(string: image)
    }
}

public extension Pokemon {
    struct PokemonSprites: Decodable {
        let frontDefault: String?
        let frontShiny: String?
        let frontFemale: String?
        let frontShinyFemale: String?
        let backDefault: String?
        let backShiny: String?
        let backFemale: String?
        let backShinyFemale: String?
    }

}
extension Pokemon.PokemonSprites: Hashable {
}
