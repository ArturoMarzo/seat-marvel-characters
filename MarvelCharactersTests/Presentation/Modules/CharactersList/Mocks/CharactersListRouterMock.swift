@testable import MarvelCharacters

// Dummy class that implements CharactersListRouter protocol to test that CharactersListPresenter call correctly the methods of
// CharactersListRouter
class CharactersListRouterMock: CharactersListRouterContract {
    var navigateToCharacterDetailWithCharacterId = false
    
    var characterId: UInt = 0
    
    func navigateToCharacterDetailWith(characterId: UInt) {
        navigateToCharacterDetailWithCharacterId = true
        self.characterId = characterId
    }
}
