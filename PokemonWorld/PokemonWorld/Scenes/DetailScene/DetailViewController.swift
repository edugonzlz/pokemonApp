import UIKit
import Kingfisher

protocol DetailViewControllerType: AnyObject, Loadable, Alertable {
    func present(vo: DetailPresenter.PokemonDetailVo)
}

class DetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Public
    var presenter: DetailPresenterType!

    // MARK: - Private


    // MARK: - Init
    deinit {
        print("deinit DetailViewController")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .red
        presenter.getData()
    }
}

//MARK: - DetailViewControllerType
extension DetailViewController: DetailViewControllerType {
    func present(vo: DetailPresenter.PokemonDetailVo) {
        title = vo.name.capitalized
        imageView.kf.setImage(with: vo.imageURL)
    }

}
