import Foundation

class CharacterDetailInteractorManager: CharacterDetailInteractorManagerContract {
    private let characterId: UInt
    private let characterRepository: CharactersRepositoryContract
    
    init(characterId: UInt, characterRepository: CharactersRepositoryContract) {
        self.characterId = characterId
        self.characterRepository = characterRepository
    }
    
    func characterDetailWith(withCompletion completion: @escaping (Result<CharacterDetail, Error>) -> Void) {
        characterRepository.characterDetailWith(id: characterId, completion: completion)
    }
}
