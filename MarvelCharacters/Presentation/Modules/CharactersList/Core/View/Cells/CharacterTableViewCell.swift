import UIKit
import Kingfisher

class CharacterTableViewCell: UITableViewCell, UITableViewCellStaticProtocol {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var character: CharacterViewModel?
    
    // MARK: - Public
    func bind(character: CharacterViewModel) {
        self.character = character
        
        nameLabel.text = character.name
        descriptionLabel.text = character.description
        if let thumbnail = character.thumbnail {
            thumbnailImageView.kf.setImage(with: URL(string: thumbnail))
        }
    }

    // MARK: - UITableViewCellStaticProtocol
    static func cellHeight() -> CGFloat {
        return 150.0
    }
}
