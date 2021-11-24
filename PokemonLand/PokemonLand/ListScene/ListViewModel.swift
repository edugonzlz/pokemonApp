import Combine
import Foundation
import PokemonServices
import SwiftUI

protocol ListViewModelProtocol: ObservableObject {
    var vo: [ListViewModel.PokemonCellVo] { get }
    var pokemons: [String: Pokemon] { get }
    var isLoading: Bool { get }

    func getData()
    func loadMoreRows(pokemonName: String)
}

class ListViewModel: ListViewModelProtocol {

    @Published var vo: [PokemonCellVo] = []
    var pokemons = [String: Pokemon]()
    @Published var isLoading = true

    private let service: PokemonServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var resources = [PokemonResource]()

    init(service: PokemonServiceProtocol = PokemonService<PokemonCache>()) {
        self.service = service
    }

    func getData() {
        let pagination = PaginationParameters(offset: vo.count,
                                              limit: Constants.pageItems)
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
                if self.pokemons.isEmpty {
                    self.getNextDetailsPage()
                }
            })
            .store(in: &self.cancellables)
    }

    func loadMoreRows(pokemonName: String) {
        guard let index = vo.firstIndex(where: { pokemonName.lowercased() == $0.name.lowercased() }),
              (index + 1) == vo.count, !isLoading else {
                  return
              }
        getNextDetailsPage()
    }
}

// MARK: - Private
private extension ListViewModel {
    struct Constants {
        static let totalApiPokemons: Int = 1118
        static let pageItems: Int = totalApiPokemons
        static let listPageItems: Int = 20
    }

    func getItemVo(pokemon: Pokemon) -> PokemonCellVo {
        return PokemonCellVo(name: pokemon.name.capitalized,
                             imageURL: pokemon.image)
    }

    func getNextDetailsPage() {
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
                let orderedData = data.sorted(by: { $0.order < $1.order })
                orderedData.forEach { item in
                    self.pokemons[item.name] = item
                    self.vo.append(self.getItemVo(pokemon: item))
                }
            }
            .store(in: &self.cancellables)

    }
}
