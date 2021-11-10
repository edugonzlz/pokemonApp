import UIKit
import Kingfisher

class PokemonCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: PokemonCollectionViewCell.self)
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func setup(with vo: ListPresenter.PokemonCellVo) {
        setupView()
        nameLabel.text = vo.name
        imageView.kf.setImage(with: vo.imageURL)
    }
}

private extension PokemonCollectionViewCell {
    func setupView() {
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .red
    }
}
