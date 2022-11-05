import Foundation
import Combine
import PokemonServices


protocol DetailViewModelProtocol: ObservableObject {
    var vo: DetailViewModel.Vo { get }
    func getData()
}

class DetailViewModel: DetailViewModelProtocol {

    // MARK: - Public
    @Published var vo: Vo = .init(imageUrl: nil, name: "")

    // MARK: - Dependencies
    private let data: Pokemon

    // MARK: - Init
    init(data: Pokemon) {
        self.data = data
    }
}

// MARK: - DetailViewModelProtocol
extension DetailViewModel {
    func getData() {
        self.composeVo(with: data)
    }
}

// MARK: - Private
private extension DetailViewModel {
    func composeVo(with data: Pokemon) {
        self.vo = Vo(imageUrl: data.image,
                     name: data.name.capitalized)

    }
}
