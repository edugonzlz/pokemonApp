import Foundation
import Combine
import PokemonServices

struct DetailViewVo {
    let imageUrl: URL?
    let name: String
}

protocol DetailViewModelProtocol: ObservableObject {
    var vo: DetailViewVo { get }
}

class DetailViewModel: DetailViewModelProtocol {

    private var cancellables = Set<AnyCancellable>()

    @Published var vo: DetailViewVo

    init(data: Pokemon) {
        self.vo = DetailViewVo(imageUrl: data.image,
                               name: data.name.capitalized)
    }
}
