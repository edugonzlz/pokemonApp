import Combine
import Foundation
import PokemonServices
import SwiftUI

protocol ListViewModelProtocol: ObservableObject {
    var data: [ListViewModel.PokemonCellVo] { get }
    func getData()
    func getPokemonDetail(name: String)
}

class ListViewModel: ListViewModelProtocol {
    
    private let service: PokemonServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: PokemonServiceProtocol = PokemonService<PokemonCache>()) {
        self.service = service
    }
    
    @Published var data: [PokemonCellVo] = []
    
    func getData() {
        let pagination = PaginationParameters(offset: data.count,
                                              limit: Constants.pageItems)
        service.getPokemons(pagination: pagination)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finish")
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] data in
                self?.present(data: data)
            })
            .store(in: &self.cancellables)
    }
    
    func getPokemonDetail(name: String) {
        service.getPokemon(name: name.lowercased())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error getting: \(name) - \(error)")
                }
            }, receiveValue: { [weak self] data in
                if let vo = self?.getItemVo(name: data.name, imageURL: data.image) {
                    self?.update(pokemonCellVo: vo)
                }
            })
            .store(in: &self.cancellables)
    }
}

// MARK: - Private
private extension ListViewModel {
    func present(data: PokemonList) {
        data.results.forEach { [weak self] item in
            self?.data.append(getItemVo(name: item.name, imageURL: nil))
        }
    }
    
    func getItemVo(name: String, imageURL: URL?) -> PokemonCellVo {
        return PokemonCellVo(name: name.capitalized, imageURL: imageURL)
    }
    
    func update(pokemonCellVo vo: PokemonCellVo) {
        if let index = data.firstIndex(where: { $0.name == vo.name}),
           data[index].imageURL == nil {
            data[index].imageURL = vo.imageURL
        }
    }
}

private extension ListViewModel {
    struct Constants {
        static let totalApiPokemons: Int = 1118
        static let pageItems: Int = totalApiPokemons
    }
}
