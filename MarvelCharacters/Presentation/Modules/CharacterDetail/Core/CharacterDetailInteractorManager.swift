import Foundation

class CharacterDetailInteractorManager: CharacterDetailInteractorManagerContract {
    private let characterId: UInt
    private let characterRepository: CharactersRepositoryContract
    
    init(characterId: UInt, characterRepository: CharactersRepositoryContract) {
        self.characterId = characterId
        self.characterRepository = characterRepository
    }
    
    func characterDetailWith(completion: @escaping (Result<CharacterDetailModel, NetworkError>) -> Void) {
        characterRepository.characterDetailWith(characterId: characterId, completion: completion)
    }
    
    func storeAsFavoriteCharacter() {
        characterRepository.storeAsFavoriteCharacterWith(characterId: characterId)
    }
    
    func removeAsFavoriteCharacter() {
        characterRepository.removeAsFavoriteCharacterWith(characterId: characterId)
    }
    
    func characterIsFavorite() -> Bool {
        characterRepository.characterIsFavorite(characterId: characterId)
    }
}
