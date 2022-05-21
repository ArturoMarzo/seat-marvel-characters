import UIKit

enum LoadingTableViewCellMode {
    case loading
    case error
}

protocol LoadingTableViewCellDelegate {
    func retryButtonPressed(loadingTableViewCell: LoadingTableViewCell)
}

class LoadingTableViewCell: UITableViewCell, UITableViewCellStaticProtocol {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var retryButton: UIButton!
    
    private (set) var mode = LoadingTableViewCellMode.loading
    var delegate: LoadingTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        spinner.startAnimating()
        retryButton.setTitle(NSLocalizedString("retry_button", comment: ""), for: .normal)
    }
    
    // MARK: - Public
    func set(mode: LoadingTableViewCellMode) {
        self.mode = mode
        
        switch mode {
        case .loading:
            spinner.isHidden = false
            spinner.startAnimating()
            retryButton.isHidden = true
        case .error:
            spinner.isHidden = true
            spinner.stopAnimating()
            retryButton.isHidden = false
        }
    }
    
    // MARK: - IBActions
    @IBAction func retryButtonPressed(_ sender: Any) {
        delegate?.retryButtonPressed(loadingTableViewCell: self)
    }
    
    // MARK: - UITableViewCellStaticProtocol
    static func cellHeight() -> CGFloat {
        return 50.0
    }
}
