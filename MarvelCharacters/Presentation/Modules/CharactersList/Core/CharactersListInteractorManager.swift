import Foundation

class CharactersListInteractorManager: CharactersListInteractorManagerContract {
    private let characterRepository: CharactersRepositoryContract
    
    init(characterRepository: CharactersRepositoryContract) {
        self.characterRepository = characterRepository
    }
    
    func characters(offset: Int, completion: @escaping (Result<CharactersModel, NetworkError>) -> Void) {
        characterRepository.characters(offset: offset, completion: completion)
    }
}
