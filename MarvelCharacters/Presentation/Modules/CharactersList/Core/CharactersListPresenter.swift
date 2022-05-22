import Foundation

// MARK: - Main Class
class CharactersListPresenter: CharactersListPresenterContract {
    private let interactorManager: CharactersListInteractorManagerContract
    private let router: CharactersListRouterContract
    private let viewModelBuilder: CharactersListViewModelBuilderContract
    private weak var view: CharactersListViewContract?
    
    private var viewModel: CharactersListViewModel?

    init(interactorManager: CharactersListInteractorManagerContract,
         router: CharactersListRouterContract,
         view: CharactersListViewContract,
         viewModelBuilder: CharactersListViewModelBuilderContract) {
        self.interactorManager = interactorManager
        self.router = router
        self.view = view
        self.viewModelBuilder = viewModelBuilder
    }

    // MARK: - CharactersListPresenter
    func viewDidLoad() {
        view?.showHUD()
        retrieveCharacters(offset: 0)
    }
    
    // Called when the last cell with a spinner is shown to load more characters
    func loadingCellShown() {
        guard let viewModel = self.viewModel else { // Just in case viewModel is not set
            self.view?.displayErrorWith(message: NSLocalizedString("error_generic_error", comment: ""))
            return
        }
        
        retrieveCharacters(offset: viewModel.characters.count)
    }
    
    // User presses a button in the error view to retry the retrieving of data from the server
    func retryButtonPressed() {
        view?.hideErrorMessage()
        view?.showHUD()
        retrieveCharacters(offset: 0)
    }
    
    // User selected a character from the list
    func selectedCharacterWith(characterId: UInt) {
        router.navigateToCharacterDetailWith(characterId: characterId)
    }
}

// MARK: - Private
private extension CharactersListPresenter {
    func retrieveCharacters(offset: Int) {
        interactorManager.characters(offset: offset) { [weak self] result in
            switch result {
            case let .success(characters):
                self?.manageSuccesfulResponse(characters: characters)
            case let .failure(error):
                self?.manageFailureResponse(error: error)
            }
        }
    }
    
    func manageSuccesfulResponse(characters: CharactersModel) {
        let viewModel: CharactersListViewModel
        if let currentViewModel = self.viewModel { // Append new data to the list
            // Use a class to build the data that is going to be shown in the view
            viewModel = viewModelBuilder.buildViewModelWith(viewModel: currentViewModel, appendingCharacters: characters)
        } else { // First data to list
            // Use a class to build the data that is going to be shown in the view
            viewModel = viewModelBuilder.buildViewModel(characters: characters)
        }
        
        self.viewModel = viewModel
        view?.hideHUD()
        view?.displayCharacters(withViewModel: viewModel)
    }
    
    func manageFailureResponse(error: NetworkError) {
        if let viewModel = viewModel {
            // There is data previously retrieved. If request failed show retry option in cell
            let newViewModel = viewModelBuilder.buildViewModel(characters: viewModel.characters,
                                                                    charactersListViewModelMode: .error)
            view?.displayCharacters(withViewModel: newViewModel)
        } else {
            switch error {
            case NetworkError.parsing:
                view?.displayErrorWith(message: NSLocalizedString("parsing_error", comment: ""))
            case NetworkError.genericError:
                view?.displayErrorWith(message: NSLocalizedString("error_generic_error", comment: ""))
            }
        }
    }
}

extension CharactersListPresenter: LoadingTableViewCellDelegate {
    func retryButtonPressed(loadingTableViewCell: LoadingTableViewCell) {
        guard let viewModel = viewModel else {
            return
        }
        
        // Use a class to build the data that is going to be shown in the view
        let newViewModel = self.viewModelBuilder.buildViewModel(characters: viewModel.characters,
                                                                charactersListViewModelMode: .loading)
        self.view?.displayCharacters(withViewModel: newViewModel)
        
        retrieveCharacters(offset: newViewModel.characters.count)
    }
}
