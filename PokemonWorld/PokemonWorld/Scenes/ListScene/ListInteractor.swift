import Combine
import Foundation
import PokemonServices

protocol ListInteractorType: AnyObject {
    var output: ListInteractorOutput? { get set }
    var isPaginable: Bool { get }
    func getData()
    func getPokemonDetail(name: String)
}

protocol ListInteractorOutput: AnyObject {
    func presentError(title: String, message: String)
    func updateList(names: [String])
    func updateList(pokemons: [Pokemon])
    func updateItem(pokemon: Pokemon)
}

class ListInteractor {

    // MARK: - Public
    weak var output: ListInteractorOutput?
    
    // MARK: - private
    private let pokemonService: PokemonServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    private var pokemonNameList = [String]()
    private var loadingData = false

    var isPaginable: Bool = Constants.pageItems < Constants.totalApiPokemons

    init(pokemonService: PokemonServiceProtocol) {
        self.pokemonService = pokemonService
    }
}

extension ListInteractor: ListInteractorType {
    func getData() {
        guard !loadingData else { return }
        self.getPokemons()
    }

    func getPokemonDetail(name: String) {
        pokemonService.getPokemon(name: name.lowercased())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Get Pokemon details finished")
                case .failure(let error):
                    print("Error getting: \(name) - \(error)")
                }
            }, receiveValue: { data in
                self.output?.updateItem(pokemon: data)
            })
            .store(in: &self.cancellables)
    }
}

private extension ListInteractor {
    struct Constants {
        static let totalApiPokemons: Int = 1118
        static let pageItems: Int = totalApiPokemons
    }

    func getPokemons() {
        loadingData = true
        let pagination = PaginationParameters(offset: pokemonNameList.count,
                                              limit: Constants.pageItems)
        pokemonService.getPokemons(pagination: pagination)
            .sink(receiveCompletion: { completion in
                self.loadingData = false

                switch completion {
                case .finished:
                    print("Get Pokemons finished")
                case .failure:
                    self.output?.presentError(title: "What?", message: "Unable to load Pokemons")
                }
            }, receiveValue: { data in
                let newNames = data.results.map { $0.name }
                self.pokemonNameList.append(contentsOf: newNames)
                self.output?.updateList(names: newNames)
            })
            .store(in: &self.cancellables)
    }

    func getDetails(from pokemonList: PokemonList) {
        pokemonList.results
            .forEach { self.getPokemonDetail(name: $0.name)}
    }
}
