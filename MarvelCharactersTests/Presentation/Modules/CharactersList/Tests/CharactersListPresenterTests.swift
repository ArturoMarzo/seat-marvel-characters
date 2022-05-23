import XCTest
@testable import MarvelCharacters

// Bundle of tests for CharactersListPresenter functionality
class CharactersListPresenterTests: XCTestCase {
    var presenter: CharactersListPresenterContract!
    var viewMock: CharactersListViewMock!
    var routerMock: CharactersListRouterMock!
    var viewModelBuilderMock: CharactersListViewModelBuilderMock!
    var interactorManagerMock: CharactersListInteractorManagerMock!
    
    override func setUp() {
        viewMock = CharactersListViewMock()
        routerMock = CharactersListRouterMock()
        viewModelBuilderMock = CharactersListViewModelBuilderMock()
        interactorManagerMock = CharactersListInteractorManagerMock()
        
        presenter = CharactersListPresenter(interactorManager: interactorManagerMock,
                                            router: routerMock,
                                            view: viewMock,
                                            viewModelBuilder: viewModelBuilderMock)
    }
    
    func test_givenAPresenter_WhenICallViewDidLoad_thenICallShowHUD() {
        presenter.viewDidLoad()
        XCTAssert(viewMock.showHUDCalled)
    }
    
    func test_givenAPresenter_WhenICallViewDidLoad_thenIRequestCharacters() {
        presenter.viewDidLoad()
        XCTAssert(interactorManagerMock.charactersRequested)
    }

    func test_givenAPresenter_WhenICallViewDidLoad_thenIRetrieveCharactersWithOffsetZero() {
        presenter.viewDidLoad()
        XCTAssert(interactorManagerMock.offset == 0)
    }

    func test_givenAPresenter_WhenICallViewDidLoadAndIRetrieveCharactersAndIGetAnError_thenICallDisplayError() {
        interactorManagerMock.returnError = true
        presenter.viewDidLoad()
        XCTAssert(viewMock.displayErrorWithMessage)
    }

    func test_givenAPresenter_WhenICallViewDidLoadAndIRetrieveCharactersAndIGetAGenericError_thenICallDisplayGenericErrorMessage() {
        interactorManagerMock.returnError = true
        interactorManagerMock.errorToReturn = .genericError
        presenter.viewDidLoad()
        XCTAssertEqual(viewMock.message, NSLocalizedString("error_generic_error", comment: ""))
    }

    func test_givenAPresenter_WhenICallViewDidLoadAndIRetrieveCharactersAndIGetAParsingError_thenICallDisplayParsingError() {
        interactorManagerMock.returnError = true
        interactorManagerMock.errorToReturn = .parsing
        presenter.viewDidLoad()
        XCTAssertEqual(viewMock.message, NSLocalizedString("parsing_error", comment: ""))
    }

    func test_givenAPresenter_WhenICallViewDidLoadAndIRetrieveCharacters_thenICallBuildViewModelCharactersCalled() {
        presenter.viewDidLoad()
        XCTAssert(viewModelBuilderMock.buildViewModelCharactersCalled)
    }

    func test_givenAPresenter_WhenICallViewDidLoadAndIRetrieveCharacters_thenICallHideHUD() {
        presenter.viewDidLoad()
        XCTAssert(viewMock.hideHUDCalled)
    }

    func test_givenAPresenter_WhenICallViewDidLoadAndIRetrieveCharacters_thenICallDisplayCharactersWithViewModelCalled() {
        presenter.viewDidLoad()
        XCTAssert(viewMock.displayCharactersWithViewModelCalled)
    }

    func test_givenAPresenter_WhenICallLoadingCellShownAndIDontCallViewDidLoad_thenICallDisplayGenericErrorMessage() {
        presenter.loadingCellShown()
        XCTAssertEqual(viewMock.message, NSLocalizedString("error_generic_error", comment: ""))
    }

    func test_givenAPresenter_WhenICallLoadingCellShownAndIDontCallViewDidLoad_thenIDontRequestCharacters() {
        presenter.loadingCellShown()
        XCTAssert(!interactorManagerMock.charactersRequested)
    }

    func test_givenAPresenter_WhenICallLoadingCellShownAfterCallViewDidLoad_thenIRequestCharacters() {
        presenter.viewDidLoad()
        presenter.loadingCellShown()
        XCTAssert(interactorManagerMock.charactersRequested)
    }

    func test_givenAPresenter_WhenICallLoadingCellShownAfterCallViewDidLoad_thenIRequestCharactersWithOffsetGreaterThanZero() {
        presenter.viewDidLoad()
        presenter.loadingCellShown()
        XCTAssert(interactorManagerMock.offset > 0)
    }

    func test_givenAPresenter_WhenICallLoadingCellShownAfterCallViewDidLoadAndRequestingCharactersIGetError_thenICallBuildViewModelWithErrorMode() {
        presenter.viewDidLoad()
        interactorManagerMock.returnError = true
        presenter.loadingCellShown()
        XCTAssert(viewModelBuilderMock.buildViewModelCharactersCharactersListViewModelModeCalled)
        XCTAssert(viewModelBuilderMock.charactersListViewModelMode == .error)
    }

    func test_givenAPresenter_WhenICallLoadingCellShownAfterCallViewDidLoadAndRequestingCharactersIGetError_thenICallDisplayCharactersWithViewModelCalled() {
        presenter.viewDidLoad()
        interactorManagerMock.returnError = true
        presenter.loadingCellShown()
        XCTAssert(viewMock.displayCharactersWithViewModelCalled)
    }

    func test_givenAPresenter_WhenICallLoadingCellShownAfterCallViewDidLoadAndIRetrieveCharacters_thenICallBuildViewModelWithViewModelAppendingCharactersCalled() {
        presenter.viewDidLoad()
        presenter.loadingCellShown()
        XCTAssert(viewModelBuilderMock.buildViewModelWithViewModelAppendingCharactersCalled)
    }

    func test_givenAPresenter_WhenICallRetryButtonPressed_thenICallHideErrorMessage() {
        presenter.retryButtonPressed()
        XCTAssert(viewMock.hideErrorMessageCalled)
    }

    func test_givenAPresenter_WhenICallRetryButtonPressed_thenICallShowHUD() {
        presenter.retryButtonPressed()
        XCTAssert(viewMock.showHUDCalled)
    }

    func test_givenAPresenter_WhenICallRetryButtonPressed_thenIRequestCharacters() {
        presenter.retryButtonPressed()
        XCTAssert(interactorManagerMock.charactersRequested)
    }

    func test_givenAPresenter_WhenICallRetryButtonPressed_thenIRetrieveCharactersWithOffsetZero() {
        presenter.retryButtonPressed()
        XCTAssert(interactorManagerMock.offset == 0)
    }

    func test_givenAPresenter_WhenICallRetryButtonPressedAndIRetrieveCharactersAndIGetAnError_thenICallDisplayError() {
        interactorManagerMock.returnError = true
        presenter.retryButtonPressed()
        XCTAssert(viewMock.displayErrorWithMessage)
    }

    func test_givenAPresenter_WhenICallRetryButtonPressedAndIRetrieveCharactersAndIGetAGenericError_thenICallDisplayGenericErrorMessage() {
        interactorManagerMock.returnError = true
        interactorManagerMock.errorToReturn = .genericError
        presenter.retryButtonPressed()
        XCTAssertEqual(viewMock.message, NSLocalizedString("error_generic_error", comment: ""))
    }

    func test_givenAPresenter_WhenICallRetryButtonPressedAndIRetrieveCharactersAndIGetASpecificError_thenICallDisplayParsingError() {
        interactorManagerMock.returnError = true
        interactorManagerMock.errorToReturn = .parsing
        presenter.retryButtonPressed()
        XCTAssertEqual(viewMock.message, NSLocalizedString("parsing_error", comment: ""))
    }

    func test_givenAPresenter_WhenICallRetryButtonPressedAndIRetrieveCharacters_thenICallBuildViewModelCharactersCalled() {
        presenter.retryButtonPressed()
        XCTAssert(viewModelBuilderMock.buildViewModelCharactersCalled)
    }

    func test_givenAPresenter_WhenICallRetryButtonPressedAndIRetrieveCharacters_thenICallHideHUD() {
        presenter.retryButtonPressed()
        XCTAssert(viewMock.hideHUDCalled)
    }

    func test_givenAPresenter_WhenICallRetryButtonPressedAndIRetrieveCharacters_thenICallDisplayCharactersWithViewModelCalled() {
        presenter.retryButtonPressed()
        XCTAssert(viewMock.displayCharactersWithViewModelCalled)
    }

    func test_givenAPresenter_WhenICallSelectdCharacterWithId_thenICallNavigateToCharacterDetailWithCharacterId() {
        presenter.selectedCharacterWith(characterId: 0)
        XCTAssert(routerMock.navigateToCharacterDetailWithCharacterId)
    }

    func test_givenAPresenter_WhenICallSelectdCharacterWithId_thenICallNavigateToCharacterDetailWithTheSameCharacterId() {
        let characterId = UInt(1)
        presenter.selectedCharacterWith(characterId: characterId)
        XCTAssert(routerMock.characterId == characterId)
    }

    func test_givenAPresenter_WhenICallCellDelegateRetryButtonPressedWithoutViewDidLoad_thenIDontCallRetrieveCharacters() {
        presenter.retryButtonPressed(loadingTableViewCell: LoadingTableViewCell())
        XCTAssert(interactorManagerMock.charactersRequested == false)
    }

    func test_givenAPresenter_WhenICallCellDelegateRetryButtonPressedAfterViewDidLoad_thenICallBuildViewModelWithLoadingMode() {
        presenter.viewDidLoad()
        presenter.retryButtonPressed(loadingTableViewCell: LoadingTableViewCell())
        XCTAssert(viewModelBuilderMock.buildViewModelCharactersCharactersListViewModelModeCalled)
        XCTAssert(viewModelBuilderMock.charactersListViewModelMode == .loading)
    }

    func test_givenAPresenter_WhenICallCellDelegateRetryButtonPressedAfterViewDidLoad_thenICallDisplayCharacters() {
        presenter.viewDidLoad()
        presenter.retryButtonPressed(loadingTableViewCell: LoadingTableViewCell())
        XCTAssert(viewMock.displayCharactersWithViewModelCalled)
    }

    func test_givenAPresenter_WhenICallCellDelegateRetryButtonPressedAfterViewDidLoad_thenICallRetrieveCharacters() {
        presenter.viewDidLoad()
        presenter.retryButtonPressed(loadingTableViewCell: LoadingTableViewCell())
        XCTAssert(interactorManagerMock.charactersRequested)
    }
}
