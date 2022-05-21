import Foundation

// MARK: - Main Class
class CharacterDetailtPresenter: CharacterDetailPresenterContract {
    private let interactorManager: CharacterDetailInteractorManagerContract
    private let router: CharacterDetailRouterContract
    private let viewModelBuilder: CharacterDetailViewModelBuilderContract
    private weak var view: CharacterDetailViewContract?
    
    private var viewModel: CharacterDetailViewModel?

    init(interactorManager: CharacterDetailInteractorManagerContract,
         router: CharacterDetailRouterContract,
         view: CharacterDetailViewContract,
         viewModelBuilder: CharacterDetailViewModelBuilderContract) {
        self.interactorManager = interactorManager
        self.router = router
        self.view = view
        self.viewModelBuilder = viewModelBuilder
    }

    // MARK: - CharacterDetailPresenter
    func viewDidLoad() {
        view?.showHUD()
        retrieveCharacterData()
    }
    
    // User selected a character from the list
    func retryButtonPressed() {
        view?.hideErrorMessage()
        view?.showHUD()
        retrieveCharacterData()
    }
    
    // MARK: - Private
    func retrieveCharacterData() {
        interactorManager.characterDetailWith { [weak self] result in
            // If presenter has ben freed before retrieving the data it is not necessary to continue interacting with the view
            guard let self = self else {
                return
            }
            
            switch result {
            case let .success(characterDetail):
                // Use a class to build the data that is going to be shown in the view
                let viewModel = self.viewModelBuilder.buildViewModel(characterDetail: characterDetail)
                self.viewModel = viewModel
                self.view?.hideHUD()
                self.view?.displayCharacterDetail(withViewModel: viewModel)
            case let .failure(error):
                if error.code != HTTPRequestService.genericErrorCode {
                    self.view?.displayErrorWith(message: error.localizedDescription)
                } else {
                    self.view?.displayErrorWith(message: NSLocalizedString("error_generic_error", comment: ""))
                }
            }
        }
    }
}
