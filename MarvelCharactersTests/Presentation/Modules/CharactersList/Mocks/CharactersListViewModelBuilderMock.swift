@testable import MarvelCharacters

// Dummy class that implements CharactersListViewModelBuilder protocol to test that CharactersListPresenter call correctly the
// methods of CharactersListViewModelBuilder
class CharactersListViewModelBuilderMock: CharactersListViewModelBuilderContract {
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
