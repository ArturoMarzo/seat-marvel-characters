import UIKit
import PKHUD

class CharacterDetailViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var presenter: CharacterDetailPresenterContract?

    private var viewModel: CharacterDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        presenter?.viewDidLoad()
    }
    
    private func configureUI() {
        retryButton.setTitle(NSLocalizedString("retry_button", comment: ""), for: .normal)
        errorView.isHidden = true
        containerView.isHidden = true
    }
    
    // MARK: - IBActions
    @IBAction func retryButtonPressed(_ sender: Any) {
        presenter?.retryButtonPressed()
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        presenter?.favoriteButtonPressed()
    }
}

// MARK: - CharacterDetailView
extension CharacterDetailViewController: CharacterDetailViewContract {
    func showHUD() {
        HUD.show(.progress)
    }
    
    func hideHUD() {
        HUD.hide()
    }
    
    func hideErrorMessage() {
        errorView.isHidden = false
    }
    
    func displayCharacterDetailWith(viewModel: CharacterDetailViewModel) {
        HUD.hide()
        containerView.isHidden = false
        errorView.isHidden = true
        self.viewModel = viewModel
        self.title = viewModel.name
        if let thumbnail = viewModel.imageURL {
            characterImageView.kf.setImage(with: URL(string: thumbnail))
        }
        
        let boldFont = UIFont.boldSystemFont(ofSize: 17)
        let regularFont = UIFont.systemFont(ofSize: 16)
        let boldAttributes = [NSAttributedString.Key.font: boldFont]
        let regularAttributes = [NSAttributedString.Key.font: regularFont]
        
        let attributedDescription = NSMutableAttributedString(string: "\(viewModel.name)", attributes: boldAttributes)
        
        if let characterDescription = viewModel.description {
            attributedDescription.append(NSAttributedString(string: "\n\(characterDescription)", attributes: regularAttributes))
        }
        
        if let comics = viewModel.comics, !comics.isEmpty {
            let comicsList =
            NSMutableAttributedString(string: "\n\n\(NSLocalizedString("character_detail_comics_header", comment: ""))",
                                      attributes: boldAttributes)
            for comic in comics {
                comicsList.append(NSAttributedString(string: "\n- \(comic.name)", attributes: regularAttributes))
            }
            if comics.count < viewModel.availableComics {
                comicsList.append(NSAttributedString(string: "\n...", attributes: regularAttributes))
            }
            attributedDescription.append(comicsList)
        }
        
        if let series = viewModel.series, !series.isEmpty {
            let seriesList =
            NSMutableAttributedString(string: "\n\n\(NSLocalizedString("character_detail_series_header", comment: ""))",
                                      attributes: boldAttributes)
            for serie in series {
                seriesList.append(NSAttributedString(string: "\n- \(serie.name)", attributes: regularAttributes))
            }
            if series.count < viewModel.availableComics {
                seriesList.append(NSAttributedString(string: "\n...", attributes: regularAttributes))
            }
            attributedDescription.append(seriesList)
        }
        
        if let stories = viewModel.comics, !stories.isEmpty {
            let storiesList =
            NSMutableAttributedString(string: "\n\n\(NSLocalizedString("character_detail_stories_header", comment: ""))",
                                      attributes: boldAttributes)
            for story in stories {
                storiesList.append(NSAttributedString(string: "\n- \(story.name)", attributes: regularAttributes))
            }
            if stories.count < viewModel.availableComics {
                storiesList.append(NSAttributedString(string: "\n...", attributes: regularAttributes))
            }
            attributedDescription.append(storiesList)
        }
        
        descriptionTextView.attributedText = attributedDescription
    }
    
    func setFavorite(value: Bool) {
        let favoriteButtonImage = value ? UIImage(named: "fullHeart") : UIImage(named: "emptyHeart")
        favoriteButton.setImage(favoriteButtonImage, for: .normal)
    }
    
    func displayErrorWith(message: String) {
        HUD.hide()
        containerView.isHidden = true
        errorView.isHidden = false
        messageLabel.text = message
    }
}
