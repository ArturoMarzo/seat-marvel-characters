import Foundation

class CharactersListInteractorManager: CharactersListInteractorManagerContract {
    private let characterRepository: CharactersRepositoryContract
    
    init(characterRepository: CharactersRepositoryContract) {
        self.characterRepository = characterRepository
    }
    
    func getCharacters(offset: Int, completion: @escaping (Result<CharactersModel, NetworkError>) -> Void) {
        characterRepository.getCharacters(offset: offset, completion: completion)
    }
}
