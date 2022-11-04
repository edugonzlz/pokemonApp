import Combine
import Foundation
import PokemonServices
import Userservices
import SwiftUI

protocol ListViewModelProtocol: ObservableObject {
    var vo: ListViewModel.ListVo { get }
    var pokemons: [Int: Pokemon] { get }
    var isLoading: Bool { get }

    func getData()
    func loadMoreRows(pokemonName: String)
}

class ListViewModel: ListViewModelProtocol {

    @Published var vo: ListVo = ListVo(items: [], totalItems: 0)
    var pokemons = [Int: Pokemon]()
    @Published var isLoading = false

    private let service: PokemonServiceProtocol
    private let userService: UserServiceProtocol
    private let userManager: UserManagerProtocol

    private var cancellables = Set<AnyCancellable>()
    private var resources = [PokemonResource]()

    init(service: PokemonServiceProtocol = PokemonService<PokemonCache>(),
         userService: UserServiceProtocol = UserService(),
         userManager: UserManagerProtocol = UserManager()) {
        self.service = service
        self.userService = userService
        self.userManager = userManager

        listenFavorites()
    }

    func getData() {
        guard resources.isEmpty, !isLoading else { return }
        getPokemons()
    }

    func loadMoreRows(pokemonName: String) {
        guard let index = vo.items.firstIndex(where: { pokemonName.lowercased() == $0.name.lowercased() }),
              (index + 1) == vo.items.count, !isLoading else {
                  return
              }
        getNextDetailsPage()
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
                self.getNextDetailsPage()
            })
            .store(in: &self.cancellables)
    }

    func getNextDetailsPage() {
        isLoading = true
        var publishers = [AnyPublisher<Pokemon, Error>]()
        for index in pokemons.count..<(pokemons.count + Constants.listPageItems) {
            publishers.append(service.getPokemon(name: resources[index].name))
        }

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
                    self.vo.items.append(self.getItemVo(pokemon: item))
                }
            }
            .store(in: &self.cancellables)

    }

    func getItemVo(pokemon: Pokemon) -> PokemonCell.Vo {
        PokemonCell.Vo(id: pokemon.id,
                       name: pokemon.name.capitalized,
                       imageURL: pokemon.image,
                       isFavorite: self.userService.isFavorite(pokemonId: pokemon.id),
                       favoriteButtonTapped: {
            self.userManager.toggleFavorite(pokemon: pokemon)
        })
    }

    func listenFavorites() {
        userService.favoritesPublisher()
            .receive(on: DispatchQueue.main)
            .sink { favorites in
                self.vo.items.forEach { item in
                    item.isFavorite = favorites.contains(item.id)
                }
            }
            .store(in: &self.cancellables)
    }
}
