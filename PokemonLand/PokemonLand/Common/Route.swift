import Foundation
import PokemonServices
import SwiftUI

protocol RouterProtocol: ObservableObject {
    var path: [Route] { get set }

    func popToRoot()
}

final class Router: RouterProtocol {
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
            return DetailView<DetailViewModel, Router>(viewModel: DetailViewModel(data: pokemon)).anyView
        }
    }
}
