import Combine
import Foundation
import PokemonServices
import SwiftUI

class ListViewModel: ObservableObject {
    
    private let service: PokemonServiceProtocol?
    private var cancellables = Set<AnyCancellable>()

    init(service: PokemonServiceProtocol = PokemonService<PokemonCache>()) {
        self.service = service
    }

    @Published private (set) var data: [PokemonCellVo] = []

    func getData() {
        let pagination = PaginationParameters(offset: data.count,
                                              limit: Constants.pageItems)
        service?.getPokemons(pagination: pagination)
            .receive(on: DispatchQueue.global())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finish")
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { data in
                self.present(data: data)
            })
            .store(in: &self.cancellables)
    }
}

// MARK: - Private
private extension ListViewModel {
    func present(data: PokemonList) {
        data.results.forEach { item in
            self.data.append(getItemVo(name: item.name, imageURL: nil))
        }
    }

    func getItemVo(name: String, imageURL: URL?) -> PokemonCellVo {
        return PokemonCellVo(name: name.capitalized, imageURL: imageURL)
    }
}

private extension ListViewModel {
    struct Constants {
        static let totalApiPokemons: Int = 1118
        static let pageItems: Int = totalApiPokemons
    }
}
