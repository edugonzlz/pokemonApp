import Combine
import Foundation
import PokemonServices

protocol ListInteractorType: AnyObject {
    var output: ListInteractorOutput? { get set }
    func getData()
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
    private let pokemonService: PokemonService
    private var cancellables = Set<AnyCancellable>()

    private var pokemonNameList = [String]()
    private var loadingData = false

    init(pokemonService: PokemonService) {
        self.pokemonService = pokemonService
    }
}

extension ListInteractor: ListInteractorType {
    func getData() {
        guard !loadingData else { return }
        self.getPokemons()
    }
}

private extension ListInteractor {
    struct Constants {
        static let pageItems: Int = 20
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
                self.getDetails(from: data)
            })
            .store(in: &self.cancellables)
    }

    func getDetails(from pokemonList: PokemonList) {
        let publishers = pokemonList.results
            .map { self.pokemonService.getPokemon(name: $0.name) }

        Publishers.MergeMany(publishers)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Get Pokemon details finished")
                case .failure(_):
                    break
                }
            }, receiveValue: { data in
                self.output?.updateItem(pokemon: data)
            })
            .store(in: &self.cancellables)
    }
}
