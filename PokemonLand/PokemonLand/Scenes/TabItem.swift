import Foundation

struct TabItem: Identifiable {
    enum Kind {
        case list, favorites
    }
    let id = UUID()
    let kind: Kind
}

extension TabItem.Kind {
    var name: String {
        switch self {
        case .list:
            return "Pokemons"
        case .favorites:
            return "Favorites"
        }
    }
    var image: String {
        switch self {
        case .list:
            return "smallcircle.circle.fill"
        case .favorites:
            return "star.fill"
        }
    }
}
