import UIKit
import PokemonServices

protocol DetailWireframeType {
    mutating func setup(pokemon: Pokemon) -> UIViewController
}

class DetailWireframe: DetailWireframeType {
    weak var viewController: UIViewController?

    func setup(pokemon: Pokemon) -> UIViewController {
        let viewController = DetailViewController()
        let presenter = DetailPresenter(wireframe: self, viewController: viewController)
        let interactor = DetailInteractor()

        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.output = presenter
        self.viewController = viewController

        interactor.data = pokemon

        return viewController
    }
}
