import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

    static let identifier: String = String(describing: ItemCollectionViewCell.self)
    
    struct ItemVo {
        let name: String
        let imageURL: URL?
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    func setup(with itemVo: ItemVo) {
        nameLabel.text = itemVo.name
    }
}
