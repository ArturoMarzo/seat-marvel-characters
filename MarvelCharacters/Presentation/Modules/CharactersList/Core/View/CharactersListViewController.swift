import UIKit
import PKHUD

class CharactersListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    enum CharactersListSections: Int, CaseIterable {
        case charactersSection
        case loadingSection
    }
    
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
        guard let section = CharactersListSections(rawValue: indexPath.section) else {
            return 0
        }
        
        switch section {
        case .charactersSection:
            return CharacterTableViewCell.cellHeight()
        case .loadingSection:
            return LoadingTableViewCell.cellHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = CharactersListSections(rawValue: indexPath.section) else {
            return
        }
        
        switch section {
        case .charactersSection:
            guard let viewModel = viewModel, indexPath.row < viewModel.characters.count else {
                return
            }
            
            let character = viewModel.characters[indexPath.row]
            presenter?.selectedCharacterWith(characterId: character.id)
        case .loadingSection:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = CharactersListSections(rawValue: indexPath.section) else {
            return
        }
        
        switch section {
        case .charactersSection:
            return
        case .loadingSection:
            guard let cell = cell as? LoadingTableViewCell, cell.mode == .loading else {
                return
            }
            
            presenter?.loadingCellShown()
        }
    }
}

extension CharactersListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = self.viewModel else {
            return 0
        }
        
        switch viewModel.charactersListViewModelMode {
        case .loading, .error:
            return CharactersListSections.allCases.count
        case .allDataLoaded:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        guard let section = CharactersListSections(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .charactersSection:
            return viewModel.characters.count
        case .loadingSection:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }
        guard let section = CharactersListSections(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .charactersSection:
            guard indexPath.row < viewModel.characters.count else {
                return UITableViewCell()
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.cellIdentifier(),
                                                           for: indexPath) as? CharacterTableViewCell else {
                return UITableViewCell()
            }
            
            cell.bind(character: viewModel.characters[indexPath.row])
            
            return cell
        case .loadingSection:
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
        }
    }
}
