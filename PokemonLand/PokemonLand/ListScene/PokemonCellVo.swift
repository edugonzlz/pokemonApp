import Foundation

extension ListViewModel {
    struct PokemonCellVo {
        let name: String
        let imageURL: URL?
    }


    struct TableDataVo {
        var items: [PokemonCellVo]
    }
}

extension  ListViewModel.PokemonCellVo: Identifiable {
    var id: String {
        return name
    }
    static func == (lhs: ListViewModel.PokemonCellVo, rhs: ListViewModel.PokemonCellVo) -> Bool {
        return lhs.name == rhs.name
    }
}
