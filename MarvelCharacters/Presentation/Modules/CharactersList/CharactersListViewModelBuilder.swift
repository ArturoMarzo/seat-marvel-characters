import UIKit

enum CharactersListViewModelMode {
    case loading
    case allDataLoaded
    case error
}

// Using struct instead of a class to store the characters list information prevents mutability
struct CharactersListViewModel {
    var characters: [CharacterViewModel]
    var charactersListViewModelMode: CharactersListViewModelMode
    
    init(characters: CharactersModel, charactersListViewModelMode: CharactersListViewModelMode) {
        let charactersViewModel = characters.characters.map {
            CharacterViewModel(character: $0)
        }
        
        self.characters = charactersViewModel
        self.charactersListViewModelMode = charactersListViewModelMode
    }
    
    init(charactersViewModel: [CharacterViewModel], charactersListViewModelMode: CharactersListViewModelMode) {
        self.characters = charactersViewModel
        self.charactersListViewModelMode = charactersListViewModelMode
    }
    
    func viewModelAppending(characters: CharactersModel,
                            charactersListViewModelMode: CharactersListViewModelMode) -> CharactersListViewModel {
        let newCharactersViewModel = characters.characters.map {
            CharacterViewModel(character: $0)
        }
        var charactersViewModel = self.characters
        charactersViewModel.append(contentsOf: newCharactersViewModel)
        
        let charactersListViewModel = CharactersListViewModel(charactersViewModel: charactersViewModel,
                                                              charactersListViewModelMode: charactersListViewModelMode)
        
        return charactersListViewModel
    }
}

struct CharacterViewModel {
    let id: UInt
    let name: String
    let description: String?
    let thumbnail: String?
    
    init(character: CharacterModel) {
        id = character.id
        name = character.name
        description = character.description
        thumbnail = character.thumbnail
    }
}

class CharactersListViewModelBuilder: CharactersListViewModelBuilderContract {
    func buildViewModel(characters: CharactersModel) -> CharactersListViewModel {
        var charactersListViewModelMode = CharactersListViewModelMode.allDataLoaded
        if let totalOfCharacters = characters.total, totalOfCharacters > characters.characters.count {
            charactersListViewModelMode = .loading
        }
        
        return CharactersListViewModel(characters: characters, charactersListViewModelMode: charactersListViewModelMode)
    }
    
    func buildViewModelWith(viewModel: CharactersListViewModel,
                            appendingCharacters characters: CharactersModel) -> CharactersListViewModel {
        var charactersListViewModelMode = CharactersListViewModelMode.allDataLoaded
        if let totalOfCharacters = characters.total,
            totalOfCharacters > (characters.characters.count + viewModel.characters.count) {
            charactersListViewModelMode = .loading
        }
        
        return viewModel.viewModelAppending(characters: characters, charactersListViewModelMode: charactersListViewModelMode)
    }
    
    func buildViewModel(characters: [CharacterViewModel],
                        charactersListViewModelMode: CharactersListViewModelMode) -> CharactersListViewModel {
        return CharactersListViewModel(charactersViewModel: characters, charactersListViewModelMode: charactersListViewModelMode)
    }
}
