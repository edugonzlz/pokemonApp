import Foundation
import CommonCore

//https://pokeapi.co/docs/v2#info
//https://github.com/kinkofer/PokemonAPI

extension PokemonService {
    enum APIVersion: String {
        case v2 = "/api/v2"
    }

    enum Endpoints: Endpoint {
        case getPokemons(pagination: PaginationParameters?)
        case getPokemonById(Int)
        case getPokemonByName(String)
//        case abilities
//        case characteristics
//        case eggGroups
//        case genders
//        case growthRates
//        case natures
//        case pokeathlonStats
//        case pokemons
//        case pokemonColors
//        case pokemonForms
//        case pokemonHabitats
//        case pokemonShapes
//        case pokemonSpecies
//        case stats
//        case types

        var host: String {
            return "pokeapi.co"
        }

        var path: String {
            let path: String

            switch self {
            case .getPokemons:
                path = "/pokemon"
            case .getPokemonById(let id):
                path = "/pokemon/\(id)"
            case .getPokemonByName(let name):
                path = "/pokemon/\(name)"
            }

            return "\(APIVersion.v2.rawValue)\(path)"
        }

        var method: RequestMethod {
            .get
        }

        var queryItems: [URLQueryItem] {
            switch self {
            case .getPokemons(let pagination):
                guard let pagination = pagination else { return [] }
                return [URLQueryItem(name: "limit", value: String(pagination.limit)),
                        URLQueryItem(name: "offset", value: String(pagination.offset))]

            default:
                return []
            }
        }

        var body: Encodable? {
            return nil
        }
    }
}
