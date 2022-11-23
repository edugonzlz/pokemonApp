import Foundation
import PokemonServices
import SwiftUI

final class Router: ObservableObject {
    @Published var path: [Route] = .init()

    func popToRoot() {
        path = .init()
    }
}

enum Route: Hashable {
    case detail(Pokemon)
}

extension Route {
    func execute() -> AnyView {
        switch self {
        case .detail(let pokemon):
            return DetailView(viewModel: DetailViewModel(data: pokemon)).anyView
        }
    }
}
