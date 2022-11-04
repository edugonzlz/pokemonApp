import SwiftUI

extension PokemonCell {
    class Vo: ObservableObject {
        let id: Int
        let name: String
        let imageURL: URL?
        @Published var isFavorite: Bool
        var favoriteButtonTapped: () -> Void

        init(id: Int, name: String, imageURL: URL? = nil, isFavorite: Bool, favoriteButtonTapped: @escaping () -> Void) {
            self.id = id
            self.name = name
            self.imageURL = imageURL
            self.isFavorite = isFavorite
            self.favoriteButtonTapped = favoriteButtonTapped
        }
    }
}

extension PokemonCell.Vo: Identifiable {
    static func == (lhs: PokemonCell.Vo, rhs: PokemonCell.Vo) -> Bool {
        return lhs.name == rhs.name
    }
}

extension PokemonCell.Vo: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
