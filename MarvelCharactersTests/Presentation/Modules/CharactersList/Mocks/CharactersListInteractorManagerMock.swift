import XCTest
@testable import MarvelCharacters

// Dummy class that implements CharactersListInteractorManager protocol to test that CharactersListPresenter call correctly the
// methods of CharactersListInteractorManager
class CharactersListInteractorManagerMock: CharactersListInteractorManagerContract {
    var charactersRequested = false
    
    var offset = -1
    var pageSize = 10
    var totalResults = 1000
    var returnError = false
    var errorToReturn = NetworkError.genericError
    
    func characters(offset: Int, completion: @escaping (Result<CharactersModel, NetworkError>) -> Void) {
        self.charactersRequested = true
        self.offset = offset
        if returnError {
            completion(.failure(errorToReturn))
        } else {
            let characters = CharacterProvider.characterWith(pageSize: pageSize, totalResults: totalResults)
            completion(.success(characters))
        }
    }
}

// Class to easily create characters to run the tests
class CharacterProvider {
    static func characterWith(pageSize: Int, totalResults: Int) -> CharactersModel {
        let charactersEntity = (0 ... pageSize).map {
            CharacterEntity(id: UInt($0),
                            name: "name",
                            description: "description",
                            thumbnail: ImageEntity(path: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
                                                   extensionFile: "jpg"))
        }
        
        let characters = CharactersModel(charactersEntity: charactersEntity, total: totalResults)
        
        return characters
    }
}
