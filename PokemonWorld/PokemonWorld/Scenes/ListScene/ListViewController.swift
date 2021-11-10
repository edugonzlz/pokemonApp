import UIKit

protocol ListViewControllerType: AnyObject, Loadable, Alertable {
    var tableDataVo: ListPresenter.TableDataVo? { get set }
    func updateRows(indexesPath: [IndexPath])
}

class ListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Public
    var presenter: ListPresenterType!
    
    // MARK: - Private
    var tableDataVo: ListPresenter.TableDataVo?
    
    // MARK: - Init
    deinit {
        print("deinit ListViewController")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Pokemon World"
        configureCollectionView()
        presenter.getData()
    }
}

//MARK: - Private
private extension ListViewController {
    struct Constants {
        static let margin: CGFloat = 10
        static let cellHeight: CGFloat = 250
        static func cellWidth(viewWidth: CGFloat) -> CGFloat {
            return (viewWidth - margin * 3)/2
        }
    }

    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(UINib(nibName: PokemonCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        collectionView?.backgroundColor = UIColor.white
    }
}

//MARK: - ListViewControllerType
extension ListViewController: ListViewControllerType {
    func updateRows(indexesPath: [IndexPath]) {
        collectionView.reloadItems(at: indexesPath)
    }
}

// MARK: - UICollectionViewDataSource
extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: Constants.cellWidth(viewWidth: view.frame.width),
                      height: Constants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.margin * 2, left: Constants.margin,
                            bottom: Constants.margin, right: Constants.margin)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.margin
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.margin
    }
}

// MARK: - UICollectionViewDataSource
extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableDataVo?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tableDataVo = tableDataVo,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as? PokemonCollectionViewCell else {
                  fatalError("No data for collection view")
              }

        let item = tableDataVo.items[indexPath.row]
        cell.setup(with: ListPresenter.PokemonCellVo(name: item.name, imageURL: item.imageURL))
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.navigateTo(detail: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let tableDataVo = tableDataVo else {
            return
        }

        if indexPath.row == tableDataVo.items.count - 1 {
            presenter.getData()
        }
    }
}
