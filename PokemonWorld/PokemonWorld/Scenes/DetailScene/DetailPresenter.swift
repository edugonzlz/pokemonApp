import Foundation
import PokemonServices

//MARK - Vo
extension DetailPresenter {
    struct PokemonDetailVo {
        struct TableCellVo {
            let name: String
            let value: String
        }
        struct TableDataVo {
            var items: [TableCellVo]
        }

        let name: String
        let imageURL: URL?
        let tableData: TableDataVo
    }
}

protocol DetailPresenterType {
    func getData()
}

class DetailPresenter {

    // MARK: - Public
    var interactor: DetailInteractorType?

    // MARK: - Private
    private var wireframe: DetailWireframeType
    private weak var viewController: DetailViewControllerType?

    // MARK: - Init
    init(wireframe: DetailWireframeType,
         viewController: DetailViewControllerType) {
        self.wireframe = wireframe
        self.viewController = viewController
    }
}

// MARK: - DetailPresenterType
extension DetailPresenter: DetailPresenterType {
    func getData() {
        viewController?.showLoading()
        interactor?.getData()
    }
}

// MARK: - DetailInteractorOutput
extension DetailPresenter: DetailInteractorOutput {
    func present(pokemon: Pokemon) {
        let vo = PokemonDetailVo(name: pokemon.name,
                                 imageURL: pokemon.image,
                                 tableData: PokemonDetailVo.TableDataVo(items: []))
        viewController?.present(vo: vo)
        viewController?.hideLoading()
    }

    func presentError(title: String, message: String) {
        viewController?.hideLoading()
        viewController?.showAlert(title: title, message: message)
    }
}
