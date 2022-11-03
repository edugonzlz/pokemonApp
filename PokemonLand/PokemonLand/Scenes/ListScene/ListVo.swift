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
        let favoriteButtonTapped: () -> Void

        init(name: String, imageURL: URL? = nil, isFavorite: Bool, favoriteButtonTapped: @escaping () -> Void) {
            self.name = name
            self.imageURL = imageURL
            self.isFavorite = isFavorite
            self.favoriteButtonTapped = favoriteButtonTapped
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
