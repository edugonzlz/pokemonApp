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
    init(service: PokemonServiceProtocol = PokemonService(),
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
        getPokemons(favorites: userService.favoriteIds())
    }
}

// MARK: - Private
private extension FavoritesListViewModel {
    func getPokemons(favorites: Set<FavoritePokemon>) {
        let favorites = favorites.sorted(by: { $0.timestamp > $1.timestamp })
        let publishers = favorites.map{ service.getPokemon(id: $0.id) }

        publishers
            .publisher
            .flatMap { $0 }
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { completion in
            } receiveValue: { data in
                let orderedData = data.reorder(by: favorites.map { $0.id })
                self.vo.items = orderedData.map {
                    self.composeCellVo(with: $0, isFavorite: orderedData.contains($0))
                }
                self.pokemons = orderedData.reduce(into: [Int: Pokemon](), { dict, pokemon in
                    dict[pokemon.id] = pokemon
                })
            }
            .store(in: &self.cancellables)
    }

    func composeCellVo(with pokemon: Pokemon, isFavorite: Bool) -> PokemonCell.Vo {
        PokemonCell.Vo(id: pokemon.id,
                       name: pokemon.name.capitalized,
                       imageURL: pokemon.image,
                       isFavorite: isFavorite,
                       favoriteButtonTapped: {[weak self] in
            self?.userManager.toggleFavorite(pokemon: pokemon)
        })
    }

    func listenFavorites() {
        userService.favoritesPublisher()
            .receive(on: DispatchQueue.main)
            .sink { favorites in
                self.getPokemons(favorites: favorites)
            }
            .store(in: &self.cancellables)
    }
}
