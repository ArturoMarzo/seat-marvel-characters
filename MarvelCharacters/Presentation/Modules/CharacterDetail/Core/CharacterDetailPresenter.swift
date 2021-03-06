import Foundation

// MARK: - Main Class
class CharacterDetailPresenter: CharacterDetailPresenterContract {
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
    
    func favoriteButtonPressed() {
        if interactorManager.characterIsFavorite() {
            interactorManager.removeAsFavoriteCharacter()
            view?.setFavorite(value: false)
        } else {
            interactorManager.storeAsFavoriteCharacter()
            view?.setFavorite(value: true)
        }
    }
    
    // MARK: - Private
    func retrieveCharacterData() {
        interactorManager.characterDetailWith { [weak self] result in
            // If presenter has been freed before retrieving the data it is not necessary to continue interacting with the view
            guard let self = self else {
                return
            }
            
            switch result {
            case let .success(characterDetail):
                // Use a class to build the data that is going to be shown in the view
                let favorite = self.interactorManager.characterIsFavorite()
                let viewModel = self.viewModelBuilder.buildViewModel(characterDetail: characterDetail)
                self.viewModel = viewModel
                self.view?.hideHUD()
                self.view?.displayCharacterDetailWith(viewModel: viewModel)
                self.view?.setFavorite(value: favorite)
            case let .failure(error):
                switch error {
                case NetworkError.parsing:
                    self.view?.displayErrorWith(message: NSLocalizedString("parsing_error", comment: ""))
                case NetworkError.genericError:
                    self.view?.displayErrorWith(message: NSLocalizedString("error_generic_error", comment: ""))
                }
            }
        }
    }
}
