import Foundation
import Combine

extension ListViewModel {
    struct ListVo {
        var items: [PokemonCellVo]
        var totalItems: Int
    }

    struct PokemonCellVo {
        let name: String
        let imageURL: URL?
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
