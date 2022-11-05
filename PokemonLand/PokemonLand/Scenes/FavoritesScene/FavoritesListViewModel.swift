import Combine
import Foundation
import PokemonServices
import Userservices
import SwiftUI

protocol FavoritesListViewModelProtocol: ObservableObject {
    var vo: FavoritesListViewModel.ListVo { get }
    var pokemons: [Int: Pokemon] { get }

    func getData()
}

class FavoritesListViewModel: FavoritesListViewModelProtocol {

    // MARK: - Public
    @Published var vo: ListVo = ListVo(items: [])
    var pokemons = [Int: Pokemon]()

    // MARK: - Dependencies
    private let service: PokemonServiceProtocol
    private let userService: UserServiceProtocol
    private let userManager: UserManagerProtocol

    // MARK: - Cancellables
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(service: PokemonServiceProtocol = PokemonService<PokemonCache>(),
         userService: UserServiceProtocol = UserService(),
         userManager: UserManagerProtocol = UserManager()) {
        self.service = service
        self.userService = userService
        self.userManager = userManager

        listenFavorites()
    }
}
// MARK: - FavoritesListViewModelProtocol
extension FavoritesListViewModel {
    func getData() {
        getPokemons()
    }
}

// MARK: - Private
private extension FavoritesListViewModel {
    func getPokemons() {
        let ids = userService.favoriteIds()

        var publishers = [AnyPublisher<Pokemon, Error>]()
        ids.forEach {
            publishers.append(service.getPokemon(id: $0))
        }

        publishers
            .publisher
            .flatMap { $0 }
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { completion in
            } receiveValue: { data in
                self.pokemons.removeAll()
                self.vo.items.removeAll()
                data.forEach { item in
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
                       favoriteButtonTapped: {[weak self] in
            self?.userManager.toggleFavorite(pokemon: pokemon)
        })
    }

    func listenFavorites() {
        userService.favoritesPublisher()
            .receive(on: DispatchQueue.main)
            .sink { favorites in
                self.getPokemons()
                self.vo.items.forEach { item in
                    item.isFavorite = favorites.contains(item.id)
                }
            }
            .store(in: &self.cancellables)
    }
}
