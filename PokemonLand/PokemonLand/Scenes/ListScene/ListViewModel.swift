import Combine
import Foundation
import PokemonServices
import Userservices
import SwiftUI

protocol ListViewModelProtocol: ObservableObject {
    var vo: ListViewModel.ListVo { get }
    var isLoading: Bool { get }
    var searchText: String { get set }
    var pokemons: [Int: Pokemon] { get }

    func getData()
    func loadMoreRows(pokemonName: String)
}

class ListViewModel: ListViewModelProtocol {

    // MARK: - Public
    @Published var vo: ListVo = ListVo(items: [], totalItems: 0)
    @Published var isLoading = false
    @Published var searchText = ""
    var pokemons = [Int: Pokemon]()

    // MARK: - Dependencies
    private let service: PokemonServiceProtocol
    private let userService: UserServiceProtocol
    private let userManager: UserManagerProtocol

    // MARK: - Cancellables
    private var cancellables = Set<AnyCancellable>()
    private var favoriteCancellables = Set<AnyCancellable>()
    private var searchCancellables = Set<AnyCancellable>()

    // MARK: - Local variables
    private var resources = [PokemonResource]()
    private var searching = false

    // MARK: - Init
    init(service: PokemonServiceProtocol = PokemonService<PokemonCache>(),
         userService: UserServiceProtocol = UserService(),
         userManager: UserManagerProtocol = UserManager()) {
        self.service = service
        self.userService = userService
        self.userManager = userManager

        listenFavorites()
        listenSearch()
    }
}

// MARK: - ListViewModelProtocol
extension ListViewModel {
    func getData() {
        guard resources.isEmpty, !isLoading else { return }
        getPokemons()
    }

    func loadMoreRows(pokemonName: String) {
        guard !searching, !isLoading else {
            return
        }
        guard let index = vo.items.firstIndex(where: { pokemonName.lowercased() == $0.name.lowercased() }),
              (index + 1) == vo.items.count else {
            return
        }
        getNextDetailsPage(resources: resources)
    }
}

// MARK: - Private
private extension ListViewModel {
    struct Constants {
        static let apiTotalItems: Int = 1118
        static let apiPageItems: Int = apiTotalItems
        static let listPageItems: Int = 20
    }

    func getPokemons() {
        isLoading = true
        let pagination = PaginationParameters(offset: vo.items.count,
                                              limit: Constants.apiPageItems)
        service.getPokemons(pagination: pagination)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { data in
                self.resources = data.results
                self.vo.totalItems = data.results.count
                self.getNextDetailsPage(resources: data.results)
            })
            .store(in: &self.cancellables)
    }

    func getNextDetailsPage(resources: [PokemonResource]) {
        guard !resources.isEmpty else {
            return
        }
        var publishers = [AnyPublisher<Pokemon, Error>]()
        for index in pokemons.count..<(pokemons.count + Constants.listPageItems) {
            publishers.append(service.getPokemon(name: resources[index].name))
        }

        getDetails(publishers: publishers)
    }

    func getDetails(publishers: [AnyPublisher<Pokemon, Error>]) {
        isLoading = true

        publishers
            .publisher
            .flatMap { $0 }
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
            } receiveValue: { data in
                let orderedData = data.sorted(by: { $0.id < $1.id })
                orderedData.forEach { item in
                    self.pokemons[item.id] = item
                    self.vo.items.append(self.composeCellVo(with: item))
                }
            }
            .store(in: &self.cancellables)

    }

    func composeCellVo(with pokemon: Pokemon) -> PokemonCell.Vo {
        PokemonCell.Vo(id: pokemon.id,
                       name: pokemon.name.capitalized,
                       imageURL: pokemon.image,
                       isFavorite: self.userService.isFavorite(pokemonId: pokemon.id),
                       favoriteButtonTapped: { [weak self] in
            self?.userManager.toggleFavorite(pokemon: pokemon)
        })
    }

    func listenFavorites() {
        userService.favoritesPublisher()
            .receive(on: DispatchQueue.main)
            .sink { favorites in
                self.vo.items.forEach { item in
                    item.isFavorite = favorites.map{ $0.id }.contains(item.id)
                }
            }
            .store(in: &self.favoriteCancellables)
    }

    func listenSearch() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { text -> String? in
                self.searching = false
                self.resetLocalData()
                switch text.count {
                case 0:
                    self.getNextDetailsPage(resources: self.resources)
                    return nil
                case 1...2:
                    return nil
                default:
                    return text
                }
            }
            .compactMap{ $0 }
            .sink { _ in
            } receiveValue: { [weak self] text in
                self?.searching = true
                self?.search(text: text)
            }
            .store(in: &searchCancellables)
    }

    func search(text: String) {
        let publishers = resources
            .filter({ $0.name.lowercased().contains(self.searchText.lowercased())})
            .map{ service.getPokemon(name: $0.name) }

        getDetails(publishers: publishers)
    }

    func resetLocalData() {
        pokemons.removeAll()
        vo.items.removeAll()
        cancellables.removeAll()
    }
}
