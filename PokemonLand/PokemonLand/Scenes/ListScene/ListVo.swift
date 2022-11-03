import Foundation
import Combine
import SwiftUI

extension ListViewModel {
    struct ListVo {
        var items: [PokemonCellVo]
        var totalItems: Int
    }

    class PokemonCellVo: ObservableObject {
        let name: String
        let imageURL: URL?
        @Published var isFavorite: Bool
        var favoriteButtonTapped: (() -> Void)?

        init(name: String, imageURL: URL? = nil, isFavorite: Bool) {
            self.name = name
            self.imageURL = imageURL
            self.isFavorite = isFavorite
        }
    }
}

extension ListViewModel.PokemonCellVo: Identifiable {
    var id: String {
        return name
    }
    static func == (lhs: ListViewModel.PokemonCellVo, rhs: ListViewModel.PokemonCellVo) -> Bool {
        return lhs.name == rhs.name
    }
}

extension ListViewModel.PokemonCellVo: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
