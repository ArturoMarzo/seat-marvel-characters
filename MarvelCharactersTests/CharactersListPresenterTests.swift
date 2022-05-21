import XCTest
@testable import MarvelCharacters

// Bundle of tests for CharactersListPresenter functionality
class CharactersListPresenterTests: XCTestCase {    
    var sut: CharactersListPresenter!
    
    func test_givenAPresenter_WhenICallViewDidLoad_thenICallShowHUD() {
        let dummyView = DummyCharactersListView()
        sut = CharactersListPresenter(interactorManager: DummyCharactersListInteractorManager(),
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.viewDidLoad()
        XCTAssert(dummyView.showHUDCalled)
    }
    
    func test_givenAPresenter_WhenICallViewDidLoad_thenIRequestCharacters() {
        let dummyInteractor = DummyCharactersListInteractorManager()
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.viewDidLoad()
        XCTAssert(dummyInteractor.charactersRequested)
    }
    
    func test_givenAPresenter_WhenICallViewDidLoad_thenIRetrieveCharactersWithOffsetZero() {
        let dummyInteractor = DummyCharactersListInteractorManager()
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.viewDidLoad()
        XCTAssert(dummyInteractor.offset == 0)
    }
    
    func test_givenAPresenter_WhenICallViewDidLoadAndIRetrieveCharactersAndIGetAnError_thenICallDisplayError() {
        let dummyView = DummyCharactersListView()
        let dummyInteractor = DummyCharactersListInteractorManager()
        dummyInteractor.returnError = true
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.viewDidLoad()
        XCTAssert(dummyView.displayErrorWithMessage)
    }
    
    func test_givenAPresenter_WhenICallViewDidLoadAndIRetrieveCharactersAndIGetAGenericError_thenICallDisplayGenericErrorMessage() {
        let dummyView = DummyCharactersListView()
        let dummyInteractor = DummyCharactersListInteractorManager()
        dummyInteractor.returnError = true
        dummyInteractor.returnErrorCode = HTTPRequestService.genericErrorCode
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.viewDidLoad()
        XCTAssert(!dummyView.localizedMessageDisplayed)
        XCTAssert(dummyView.genericMessageDisplayed)
    }
    
    func test_givenAPresenter_WhenICallViewDidLoadAndIRetrieveCharactersAndIGetASpecificError_thenICallDisplayLocalizedErrorMessage() {
        let dummyView = DummyCharactersListView()
        let dummyInteractor = DummyCharactersListInteractorManager()
        dummyInteractor.returnError = true
        dummyInteractor.returnErrorCode = 404
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.viewDidLoad()
        XCTAssert(dummyView.localizedMessageDisplayed)
        XCTAssert(!dummyView.genericMessageDisplayed)
    }
    
    func test_givenAPresenter_WhenICallViewDidLoadAndIRetrieveCharacters_thenICallBuildViewModelCharactersCalled() {
        let dummyViewModelBuilder = DummyCharactersListViewModelBuilder()
        sut = CharactersListPresenter(interactorManager: DummyCharactersListInteractorManager(),
                                      router: DummyCharactersListRouter(),
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: dummyViewModelBuilder)
        sut.viewDidLoad()
        XCTAssert(dummyViewModelBuilder.buildViewModelCharactersCalled)
    }
    
    func test_givenAPresenter_WhenICallViewDidLoadAndIRetrieveCharacters_thenICallHideHUD() {
        let dummyView = DummyCharactersListView()
        sut = CharactersListPresenter(interactorManager: DummyCharactersListInteractorManager(),
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.viewDidLoad()
        XCTAssert(dummyView.hideHUDCalled)
    }
    
    func test_givenAPresenter_WhenICallViewDidLoadAndIRetrieveCharacters_thenICallDisplayCharactersWithViewModelCalled() {
        let dummyView = DummyCharactersListView()
        sut = CharactersListPresenter(interactorManager: DummyCharactersListInteractorManager(),
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.viewDidLoad()
        XCTAssert(dummyView.displayCharactersWithViewModelCalled)
    }
    
    func test_givenAPresenter_WhenICallLoadingCellShownAndIDontCallViewDidLoad_thenICallDisplayGenericErrorMessage() {
        let dummyView = DummyCharactersListView()
        sut = CharactersListPresenter(interactorManager: DummyCharactersListInteractorManager(),
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.loadingCellShown()
        XCTAssert(!dummyView.localizedMessageDisplayed)
        XCTAssert(dummyView.genericMessageDisplayed)
    }
    
    func test_givenAPresenter_WhenICallLoadingCellShownAndIDontCallViewDidLoad_thenIDontRequestCharacters() {
        let dummyInteractor = DummyCharactersListInteractorManager()
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.loadingCellShown()
        XCTAssert(!dummyInteractor.charactersRequested)
    }
    
    func test_givenAPresenter_WhenICallLoadingCellShownAfterCallViewDidLoad_thenIRequestCharacters() {
        let dummyInteractor = DummyCharactersListInteractorManager()
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.viewDidLoad()
        sut.loadingCellShown()
        XCTAssert(dummyInteractor.charactersRequested)
    }
    
    func test_givenAPresenter_WhenICallLoadingCellShownAfterCallViewDidLoad_thenIRequestCharactersWithOffsetGreaterThanZero() {
        let dummyInteractor = DummyCharactersListInteractorManager()
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.viewDidLoad()
        sut.loadingCellShown()
        XCTAssert(dummyInteractor.offset > 0)
    }
    
    func test_givenAPresenter_WhenICallLoadingCellShownAfterCallViewDidLoadAndRequestingCharactersIGetError_thenICallBuildViewModelWithErrorMode() {
        let dummyInteractor = DummyCharactersListInteractorManager()
        let dummyViewModelBuilder = DummyCharactersListViewModelBuilder()
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: dummyViewModelBuilder)
        sut.viewDidLoad()
        dummyInteractor.returnError = true
        sut.loadingCellShown()
        XCTAssert(dummyViewModelBuilder.buildViewModelCharactersCharactersListViewModelModeCalled)
        XCTAssert(dummyViewModelBuilder.charactersListViewModelMode == .error)
    }
    
    func test_givenAPresenter_WhenICallLoadingCellShownAfterCallViewDidLoadAndRequestingCharactersIGetError_thenICallDisplayCharactersWithViewModelCalled() {
        let dummyView = DummyCharactersListView()
        let dummyInteractor = DummyCharactersListInteractorManager()
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.viewDidLoad()
        dummyInteractor.returnError = true
        sut.loadingCellShown()
        XCTAssert(dummyView.displayCharactersWithViewModelCalled)
    }
    
    func test_givenAPresenter_WhenICallLoadingCellShownAfterCallViewDidLoadAndIRetrieveCharacters_thenICallBuildViewModelWithViewModelAppendingCharactersCalled() {
        let dummyViewModelBuilder = DummyCharactersListViewModelBuilder()
        sut = CharactersListPresenter(interactorManager: DummyCharactersListInteractorManager(),
                                      router: DummyCharactersListRouter(),
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: dummyViewModelBuilder)
        sut.viewDidLoad()
        sut.loadingCellShown()
        XCTAssert(dummyViewModelBuilder.buildViewModelWithViewModelAppendingCharactersCalled)
    }
    
    func test_givenAPresenter_WhenICallRetryButtonPressed_thenICallHideErrorMessage() {
        let dummyView = DummyCharactersListView()
        sut = CharactersListPresenter(interactorManager: DummyCharactersListInteractorManager(),
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.retryButtonPressed()
        XCTAssert(dummyView.hideErrorMessageCalled)
    }
    
    func test_givenAPresenter_WhenICallRetryButtonPressed_thenICallShowHUD() {
        let dummyView = DummyCharactersListView()
        sut = CharactersListPresenter(interactorManager: DummyCharactersListInteractorManager(),
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.retryButtonPressed()
        XCTAssert(dummyView.showHUDCalled)
    }
    
    func test_givenAPresenter_WhenICallRetryButtonPressed_thenIRequestCharacters() {
        let dummyInteractor = DummyCharactersListInteractorManager()
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.retryButtonPressed()
        XCTAssert(dummyInteractor.charactersRequested)
    }
    
    func test_givenAPresenter_WhenICallRetryButtonPressed_thenIRetrieveCharactersWithOffsetZero() {
        let dummyInteractor = DummyCharactersListInteractorManager()
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.retryButtonPressed()
        XCTAssert(dummyInteractor.offset == 0)
    }
    
    func test_givenAPresenter_WhenICallRetryButtonPressedAndIRetrieveCharactersAndIGetAnError_thenICallDisplayError() {
        let dummyView = DummyCharactersListView()
        let dummyInteractor = DummyCharactersListInteractorManager()
        dummyInteractor.returnError = true
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.retryButtonPressed()
        XCTAssert(dummyView.displayErrorWithMessage)
    }
    
    func test_givenAPresenter_WhenICallRetryButtonPressedAndIRetrieveCharactersAndIGetAGenericError_thenICallDisplayGenericErrorMessage() {
        let dummyView = DummyCharactersListView()
        let dummyInteractor = DummyCharactersListInteractorManager()
        dummyInteractor.returnError = true
        dummyInteractor.returnErrorCode = HTTPRequestService.genericErrorCode
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.retryButtonPressed()
        XCTAssert(!dummyView.localizedMessageDisplayed)
        XCTAssert(dummyView.genericMessageDisplayed)
    }
    
    func test_givenAPresenter_WhenICallRetryButtonPressedAndIRetrieveCharactersAndIGetASpecificError_thenICallDisplayLocalizedErrorMessage() {
        let dummyView = DummyCharactersListView()
        let dummyInteractor = DummyCharactersListInteractorManager()
        dummyInteractor.returnError = true
        dummyInteractor.returnErrorCode = 404
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.retryButtonPressed()
        XCTAssert(dummyView.localizedMessageDisplayed)
        XCTAssert(!dummyView.genericMessageDisplayed)
    }
    
    func test_givenAPresenter_WhenICallRetryButtonPressedAndIRetrieveCharacters_thenICallBuildViewModelCharactersCalled() {
        let dummyViewModelBuilder = DummyCharactersListViewModelBuilder()
        sut = CharactersListPresenter(interactorManager: DummyCharactersListInteractorManager(),
                                      router: DummyCharactersListRouter(),
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: dummyViewModelBuilder)
        sut.retryButtonPressed()
        XCTAssert(dummyViewModelBuilder.buildViewModelCharactersCalled)
    }
    
    func test_givenAPresenter_WhenICallRetryButtonPressedAndIRetrieveCharacters_thenICallHideHUD() {
        let dummyView = DummyCharactersListView()
        sut = CharactersListPresenter(interactorManager: DummyCharactersListInteractorManager(),
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.retryButtonPressed()
        XCTAssert(dummyView.hideHUDCalled)
    }
    
    func test_givenAPresenter_WhenICallRetryButtonPressedAndIRetrieveCharacters_thenICallDisplayCharactersWithViewModelCalled() {
        let dummyView = DummyCharactersListView()
        sut = CharactersListPresenter(interactorManager: DummyCharactersListInteractorManager(),
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.retryButtonPressed()
        XCTAssert(dummyView.displayCharactersWithViewModelCalled)
    }
    
    func test_givenAPresenter_WhenICallSelectdCharacterWithId_thenICallNavigateToCharacterDetailWithCharacterId() {
        let dummyRouter = DummyCharactersListRouter()
        sut = CharactersListPresenter(interactorManager: DummyCharactersListInteractorManager(),
                                      router: dummyRouter,
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.selectedCharacterWith(characterId: 0)
        XCTAssert(dummyRouter.navigateToCharacterDetailWithCharacterId)
    }
    
    func test_givenAPresenter_WhenICallSelectdCharacterWithId_thenICallNavigateToCharacterDetailWithTheSameCharacterId() {
        let dummyRouter = DummyCharactersListRouter()
        sut = CharactersListPresenter(interactorManager: DummyCharactersListInteractorManager(),
                                      router: dummyRouter,
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        let characterId = UInt(1)
        sut.selectedCharacterWith(characterId: characterId)
        XCTAssert(dummyRouter.characterId == characterId)
    }
    
    func test_givenAPresenter_WhenICallCellDelegateRetryButtonPressedWithoutViewDidLoad_thenIDontCallRetrieveCharacters() {
        let dummyInteractor = DummyCharactersListInteractorManager()
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.retryButtonPressed(loadingTableViewCell: LoadingTableViewCell())
        XCTAssert(dummyInteractor.charactersRequested == false)
    }
    
    func test_givenAPresenter_WhenICallCellDelegateRetryButtonPressedAfterViewDidLoad_thenICallBuildViewModelWithLoadingMode() {
        let dummyViewModelBuilder = DummyCharactersListViewModelBuilder()
        sut = CharactersListPresenter(interactorManager: DummyCharactersListInteractorManager(),
                                      router: DummyCharactersListRouter(),
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: dummyViewModelBuilder)
        sut.viewDidLoad()
        sut.retryButtonPressed(loadingTableViewCell: LoadingTableViewCell())
        XCTAssert(dummyViewModelBuilder.buildViewModelCharactersCharactersListViewModelModeCalled)
        XCTAssert(dummyViewModelBuilder.charactersListViewModelMode == .loading)
    }
    
    func test_givenAPresenter_WhenICallCellDelegateRetryButtonPressedAfterViewDidLoad_thenICallDisplayCharacters() {
        let dummyView = DummyCharactersListView()
        sut = CharactersListPresenter(interactorManager: DummyCharactersListInteractorManager(),
                                      router: DummyCharactersListRouter(),
                                      view: dummyView,
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.viewDidLoad()
        sut.retryButtonPressed(loadingTableViewCell: LoadingTableViewCell())
        XCTAssert(dummyView.displayCharactersWithViewModelCalled)
    }
    
    func test_givenAPresenter_WhenICallCellDelegateRetryButtonPressedAfterViewDidLoad_thenICallRetrieveCharacters() {
        let dummyInteractor = DummyCharactersListInteractorManager()
        sut = CharactersListPresenter(interactorManager: dummyInteractor,
                                      router: DummyCharactersListRouter(),
                                      view: DummyCharactersListView(),
                                      viewModelBuilder: DummyCharactersListViewModelBuilder())
        sut.viewDidLoad()
        sut.retryButtonPressed(loadingTableViewCell: LoadingTableViewCell())
        XCTAssert(dummyInteractor.charactersRequested)
    }
}

// Dummy class that implements CharactersListView protocol to test that CharactersListPresenter call correctly the methods of
// CharactersListView
class DummyCharactersListView: CharactersListViewContract {
    var showHUDCalled = false
    var hideHUDCalled = false
    var hideErrorMessageCalled = false
    var displayCharactersWithViewModelCalled = false
    
    var displayErrorWithMessage = false
    var genericMessageDisplayed = false
    var localizedMessageDisplayed = false
    
    func showHUD() {
        showHUDCalled = true
    }
    
    func hideHUD() {
        hideHUDCalled = true
    }
    
    func hideErrorMessage() {
        hideErrorMessageCalled = true
    }
    
    func displayCharacters(withViewModel viewModel: CharactersListViewModel) {
        displayCharactersWithViewModelCalled = true
    }
    
    func displayErrorWith(message: String) {
        displayErrorWithMessage = true
        if message == NSLocalizedString("error_generic_error", comment: "") {
            genericMessageDisplayed = true
        } else {
            localizedMessageDisplayed = true
        }
    }
}

// Dummy class that implements CharactersListInteractorManager protocol to test that CharactersListPresenter call correctly the
// methods of CharactersListInteractorManager
class DummyCharactersListInteractorManager: CharactersListInteractorManagerContract {
    var charactersRequested = false
    
    var offset = -1
    var pageSize = 10
    var totalResults = 1000
    var returnError = false
    var returnErrorCode = -1
    
    func characters(offset: Int, completion: @escaping (Result<CharactersModel, Error>) -> Void) {
        self.charactersRequested = true
        self.offset = offset
        if returnError {
            if returnErrorCode != -1 {
                let error = NSError(domain: NSURLErrorDomain, code: returnErrorCode, userInfo:nil)
                completion(.failure(error))
            } else {
                completion(.failure(HTTPRequestService.genericError))
            }
        } else {
            let characters = CharacterProvider.characterWith(pageSize: pageSize, totalResults: totalResults)
            completion(.success(characters))
        }
    }
}

// Dummy class that implements CharactersListRouter protocol to test that CharactersListPresenter call correctly the methods of
// CharactersListRouter
class DummyCharactersListRouter: CharactersListRouterContract {
    var navigateToCharacterDetailWithCharacterId = false
    
    var characterId: UInt = 0
    
    func navigateToCharacterDetailWith(characterId: UInt) {
        navigateToCharacterDetailWithCharacterId = true
        self.characterId = characterId
    }
}

// Dummy class that implements CharactersListViewModelBuilder protocol to test that CharactersListPresenter call correctly the
// methods of CharactersListViewModelBuilder
class DummyCharactersListViewModelBuilder: CharactersListViewModelBuilderContract {
    var buildViewModelCharactersCalled = false
    var buildViewModelWithViewModelAppendingCharactersCalled = false
    var buildViewModelCharactersCharactersListViewModelModeCalled = false
    var charactersListViewModelMode: CharactersListViewModelMode?
    
    func buildViewModel(characters: CharactersModel) -> CharactersListViewModel {
        buildViewModelCharactersCalled = true
        return CharactersListViewModel(characters: characters, charactersListViewModelMode: .allDataLoaded)
    }
    
    func buildViewModelWith(viewModel: CharactersListViewModel, appendingCharacters characters: CharactersModel) -> CharactersListViewModel {
        buildViewModelWithViewModelAppendingCharactersCalled = true
        return viewModel.viewModelAppending(characters: characters, charactersListViewModelMode: .allDataLoaded)
    }
    
    func buildViewModel(characters: [CharacterViewModel], charactersListViewModelMode: CharactersListViewModelMode) -> CharactersListViewModel {
        buildViewModelCharactersCharactersListViewModelModeCalled = true
        self.charactersListViewModelMode = charactersListViewModelMode
        return CharactersListViewModel(charactersViewModel: characters, charactersListViewModelMode: charactersListViewModelMode)
    }
}
