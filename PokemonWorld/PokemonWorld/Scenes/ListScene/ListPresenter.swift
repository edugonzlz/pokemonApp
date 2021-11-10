import Foundation
import PokemonServices

//MARK - Vo
extension ListPresenter {
    struct PokemonCellVo {
        let name: String
        let imageURL: URL?
    }

    struct TableDataVo {
        var items: [PokemonCellVo]
    }
}

protocol ListPresenterType {
    func getData()
    func navigateTo(detail indexPath: IndexPath)
}

class ListPresenter {

    // MARK: - Public
    var interactor: ListInteractorType?
    
    // MARK: - Private
    private var wireframe: ListWireframeType
    private weak var viewController: ListViewControllerType?
    private var tableDataVo: TableDataVo? {
        didSet {
            viewController?.tableDataVo = tableDataVo
        }
    }
    private lazy var pokemons = Set<Pokemon>()
    
    // MARK: - Init
    init(wireframe: ListWireframeType,
         viewController: ListViewControllerType) {
        self.wireframe = wireframe
        self.viewController = viewController
    }
}

// MARK: - ListPresenterType
extension ListPresenter: ListPresenterType {
    func getData() {
        viewController?.showLoading()
        interactor?.getData()
    }
    
    func navigateTo(detail indexPath: IndexPath) {
        guard let cellVo = tableDataVo?.items[indexPath.row],
              let pokemon = pokemons
                .first(where: { $0.name.lowercased() == cellVo.name.lowercased()}) else {
                    return
                }
        
        wireframe.navigateTo(detail: pokemon)
    }
}

// MARK: - ListInteractorOutput
extension ListPresenter: ListInteractorOutput {
    func updateList(names: [String]) {
        var newItems = [PokemonCellVo]()
        let indexes = names.enumerated().map { index, name -> IndexPath in
            newItems.append(getItemVo(name: name, imageURL: nil))
            return IndexPath(row: index, section: 0)
        }
        
        updateTable(newItems: newItems, indexes: indexes)
    }

    func updateList(pokemons: [Pokemon]) {
        var newItems = [PokemonCellVo]()
        let indexes = pokemons.enumerated().map { index, item -> IndexPath in
            self.pokemons.insert(item)
            newItems.append(getItemVo(name: item.name, imageURL: item.image))
            return IndexPath(row: index, section: 0)
        }

        updateTable(newItems: newItems, indexes: indexes)
    }

    func updateItem(pokemon: Pokemon) {
        pokemons.insert(pokemon)
        guard let index = tableDataVo?.items
                .firstIndex(where: { $0.name.lowercased() == pokemon.name.lowercased() }) else {
                    return
                }
        tableDataVo?.items[index] = getItemVo(name: pokemon.name, imageURL: pokemon.image)
        viewController?.updateRows(indexesPath: [IndexPath(row: index, section: 0)])
    }

    func presentError(title: String, message: String) {
        viewController?.hideLoading()
        viewController?.showAlert(title: title, message: message)
    }
}

//MARK: - Private
private extension ListPresenter {
    func getItemVo(name: String, imageURL: URL?) -> PokemonCellVo {
        return PokemonCellVo(name: name.capitalized, imageURL: imageURL)
    }

    func updateTable(newItems: [PokemonCellVo], indexes: [IndexPath]) {
        if tableDataVo == nil {
            tableDataVo = TableDataVo(items: newItems)
        } else if var tableDataVo = tableDataVo {
            tableDataVo.items.append(contentsOf: newItems)
            self.tableDataVo = tableDataVo
        }

        viewController?.updateRows(indexesPath: indexes)
        viewController?.hideLoading()
    }
}
