import XCTest
@testable import MarvelCharacters

// Dummy class that implements CharactersListView protocol to test that CharactersListPresenter call correctly the methods of
// CharactersListView
class CharactersListViewMock: CharactersListViewContract {
    var showHUDCalled = false
    var hideHUDCalled = false
    var hideErrorMessageCalled = false
    var displayCharactersWithViewModelCalled = false
    
    var displayErrorWithMessage = false
    var message = ""
    
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
        self.message = message
    }
}
