import Foundation
import Combine

extension ListViewModel {
    class PokemonCellVo: ObservableObject {
        let name: String
        @Published var imageURL: URL?
        
        init(name: String, imageURL: URL?) {
            self.name = name
            self.imageURL = imageURL
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
