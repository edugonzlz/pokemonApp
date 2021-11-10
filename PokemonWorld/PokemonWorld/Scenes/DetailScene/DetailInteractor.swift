import Foundation
import PokemonServices

protocol DetailInteractorType: AnyObject {
    var output: DetailInteractorOutput? { get set }
    var data: Pokemon? { get set}
    func getData()
}

protocol DetailInteractorOutput: AnyObject {
    func present(pokemon: Pokemon)
    func presentError(title: String, message: String)
}

class DetailInteractor {

    // MARK: - Public
    weak var output: DetailInteractorOutput?
    var data: Pokemon?

    // MARK: - private

    init() {
    }
}

extension DetailInteractor: DetailInteractorType {
    func getData() {
        guard let data = data else {
            return
        }
        output?.present(pokemon: data)
    }
}
