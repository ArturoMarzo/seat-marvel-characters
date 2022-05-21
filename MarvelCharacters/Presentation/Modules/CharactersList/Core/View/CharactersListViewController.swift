import UIKit
import PKHUD

class CharactersListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    static let indexForCharactersSection = 0
    static let indexForLoadingSection = 1
    
    var presenter: CharactersListPresenterContract?
    
    private var viewModel: CharactersListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - Private
    private func configureUI() {
        title = NSLocalizedString("character_list_title", comment: "")
        retryButton.setTitle(NSLocalizedString("retry_button", comment: ""), for: .normal)
        errorView.isHidden = true
        tableView.isHidden = true
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        registerNibs()
    }

    private func registerNibs() {
        tableView.register(UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: CharacterTableViewCell.cellIdentifier())
        tableView.register(UINib(nibName: String(describing: LoadingTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: LoadingTableViewCell.cellIdentifier())
    }
    
    // MARK: - IBActions
    @IBAction func retryButtonPressed(_ sender: Any) {
        presenter?.retryButtonPressed()
    }
}

// MARK: - CharactersListView
extension CharactersListViewController: CharactersListViewContract {
    func showHUD() {
        HUD.show(.progress)
    }
    
    func hideHUD() {
        HUD.hide()
    }
    
    func hideErrorMessage() {
        errorView.isHidden = false
    }
    
    func displayCharacters(withViewModel viewModel: CharactersListViewModel) {
        HUD.hide()
        tableView.isHidden = false
        errorView.isHidden = true
        self.viewModel = viewModel
        tableView.reloadData()
    }
    
    func displayErrorWith(message: String) {
        HUD.hide()
        tableView.isHidden = true
        errorView.isHidden = false
        messageLabel.text = message
    }
}

extension CharactersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case CharactersListViewController.indexForCharactersSection:
            return CharacterTableViewCell.cellHeight()
        case CharactersListViewController.indexForLoadingSection:
            return LoadingTableViewCell.cellHeight()
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case CharactersListViewController.indexForCharactersSection:
            guard let viewModel = viewModel, indexPath.row < viewModel.characters.count else {
                return
            }
            
            let character = viewModel.characters[indexPath.row]
            presenter?.selectedCharacterWith(characterId: character.id)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case CharactersListViewController.indexForLoadingSection:
            guard let cell = cell as? LoadingTableViewCell, cell.mode == .loading else {
                return
            }
            
            presenter?.loadingCellShown()
        default:
            return
        }
    }
}

extension CharactersListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = self.viewModel else { return 0 }
        
        switch viewModel.charactersListViewModelMode {
        case .loading, .error:
            return 2
        case .allDataLoaded:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        
        switch section {
        case CharactersListViewController.indexForCharactersSection:
            return viewModel.characters.count
        case CharactersListViewController.indexForLoadingSection:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel, indexPath.row < viewModel.characters.count else { return UITableViewCell() }
        
        switch indexPath.section {
        case CharactersListViewController.indexForCharactersSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.cellIdentifier(),
                                                           for: indexPath) as? CharacterTableViewCell else {
                return UITableViewCell()
            }
            
            cell.bind(character: viewModel.characters[indexPath.row])
            
            return cell
        case CharactersListViewController.indexForLoadingSection:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.cellIdentifier(),
                                                           for: indexPath) as? LoadingTableViewCell else {
                return UITableViewCell()
            }
            
            switch viewModel.charactersListViewModelMode {
            case .loading:
                cell.set(mode: .loading)
            case .error:
                cell.set(mode: .error)
                cell.delegate = presenter
            case .allDataLoaded:
                return UITableViewCell()
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}
