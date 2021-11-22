import UIKit
import PokemonServices

protocol ListWireframeType {
    mutating func setup() -> UIViewController
    func navigateTo(detail: Pokemon)
}

class ListWireframe: ListWireframeType {

    weak var viewController: UIViewController?

    func setup() -> UIViewController {
        let viewController = ListViewController()
        let presenter = ListPresenter(wireframe: self, viewController: viewController)
        let interactor = ListInteractor(pokemonService: PokemonService<PokemonCache>())

        viewController.presenter = presenter
        presenter.interactor = interactor
        interactor.output = presenter
        self.viewController = viewController
        
        return viewController
    }
    
    func navigateTo(detail: Pokemon) {
        let viewController = DetailWireframe().setup(pokemon: detail)
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
