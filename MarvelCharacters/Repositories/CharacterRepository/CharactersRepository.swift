import UIKit

protocol CharactersRepositoryContract {
    func getCharacters(offset: Int, completion: @escaping (Result<CharactersModel, NetworkError>) -> Void)
    func getCharacterDetailWith(characterId: UInt, completion: @escaping (Result<CharacterDetailModel, NetworkError>) -> Void)
    func storeAsFavoriteCharacterWith(characterId: UInt)
    func removeAsFavoriteCharacterWith(characterId: UInt)
    func characterIsFavorite(characterId: UInt) -> Bool
}

final class CharactersRepository: CharactersRepositoryContract {
    let pageSize = 20
    let favoritesCharactersSetKey = "favoritesCharactersSetKey"
    let requestManager: HTTPRequestManagerContract
    let localStorageManager: LocalStorageManagerContract
    
    init(requestManager: HTTPRequestManagerContract, localStorageManager: LocalStorageManagerContract) {
        self.requestManager = requestManager
        self.localStorageManager = localStorageManager
    }
    
    func getCharacters(offset: Int, completion: @escaping (Result<CharactersModel, NetworkError>) -> Void) {
        var parameters = ServerHostURL.authenticationParameters()
        parameters["limit"] = pageSize
        parameters["offset"] = offset
        
        requestManager.request(url: ServerHostURL.charactersListURL(),
                               httpMethod: .get,
                               parameters: parameters,
                               headers: nil,
                               success: { _, data in
            // Deserialize the data
            if let characterResponseEntity = try? JSONDecoder().decode(CharactersListResponseEntity.self, from: data) {
                guard let results = characterResponseEntity.data?.results else {
                    completion(.failure(NetworkError.parsing))
                    return
                }
                
                let characters = CharactersModel(charactersEntity: results, total: characterResponseEntity.data?.total)
                completion(.success(characters))
            } else {
                // Data retrieved can't be processed
                completion(.failure(NetworkError.parsing))
            }
        }, error: { errorResponse in
            // Return error in request
            completion(.failure(NetworkError.genericError))
        })
    }
    
    func getCharacterDetailWith(characterId: UInt, completion: @escaping (Result<CharacterDetailModel, NetworkError>) -> Void) {
        let parameters = ServerHostURL.authenticationParameters()
        
        requestManager.request(url: ServerHostURL.characterDetailURL(id: characterId),
                               httpMethod: .get,
                               parameters: parameters,
                               headers: nil,
                               success: { _, data in
            // Deserialize the data
            if let characterDetailResponseEntity = try? JSONDecoder().decode(CharacterDetailResponseEntity.self, from: data) {
                guard let characterDetailEntity = characterDetailResponseEntity.data?.results?.first,
                      let characterDetail = CharacterDetailModel(characterDetailEntity: characterDetailEntity) else {
                          completion(.failure(NetworkError.parsing))
                          return
                      }
                
                completion(.success(characterDetail))
            } else {
                // Data retrieved can't be processed
                completion(.failure(NetworkError.parsing))
            }
        }, error: { errorResponse in
            // Return error in request
            completion(.failure(NetworkError.genericError))
        })
    }
    
    func storeAsFavoriteCharacterWith(characterId: UInt) {
        localStorageManager.storeId(id: characterId, collectionKey: favoritesCharactersSetKey)
    }
    
    func removeAsFavoriteCharacterWith(characterId: UInt) {
        localStorageManager.removeId(id: characterId, collectionKey: favoritesCharactersSetKey)
    }
    
    func characterIsFavorite(characterId: UInt) -> Bool {
        localStorageManager.idContainedInCollection(id: characterId, collectionKey: favoritesCharactersSetKey)
    }
}
