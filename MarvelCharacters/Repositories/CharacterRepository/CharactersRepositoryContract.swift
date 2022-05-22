import UIKit

protocol CharactersRepositoryContract {
    func characters(offset: Int, completion: @escaping (Result<CharactersModel, Error>) -> Void)
    func characterDetailWith(characterId: UInt, completion: @escaping (Result<CharacterDetailModel, Error>) -> Void)
    func storeAsFavoriteCharacterWith(characterId: UInt)
    func removeAsFavoriteCharacterWith(characterId: UInt)
    func characterIsFavorite(characterId: UInt) -> Bool
}

final class CharactersRepository: CharactersRepositoryContract {
    let pageSize = 20
    let favoritesCharactersSetKey = "favoritesCharactersSetKey"
    let requestService: HTTPRequestService
    let localStorageManager: LocalStorageManager
    
    init(requestService: HTTPRequestService, localStorageManager: LocalStorageManager) {
        self.requestService = requestService
        self.localStorageManager = localStorageManager
    }
    
    func characters(offset: Int, completion: @escaping (Result<CharactersModel, Error>) -> Void) {
        var parameters = ServerHostURL.authenticationParameters()
        parameters["limit"] = pageSize
        parameters["offset"] = offset
        
        requestService.request(url: ServerHostURL.charactersListURL(),
                                   httpMethod: .get,
                                   parameters: parameters,
                                   headers: nil,
                                   success: { (responseJSON, data) in
            // Deserialize the data
            if let characterResponseEntity = try? JSONDecoder().decode(CharactersListResponseEntity.self, from: data) {
                guard let results = characterResponseEntity.data?.results else {
                    completion(.failure(HTTPRequestService.genericError))
                    return
                }
                
                let characters = CharactersModel(charactersEntity: results, total: characterResponseEntity.data?.total)
                completion(.success(characters))
            } else {
                // Data retrieved can't be processed
                completion(.failure(HTTPRequestService.genericError))
            }
        }, error: { (errorResponse) in
            // Return error in request
            completion(.failure(errorResponse))
        })
    }
    
    func characterDetailWith(characterId: UInt, completion: @escaping (Result<CharacterDetailModel, Error>) -> Void) {
        let parameters = ServerHostURL.authenticationParameters()
        
        requestService.request(url: ServerHostURL.characterDetailURL(id: characterId),
                               httpMethod: .get,
                               parameters: parameters,
                               headers: nil,
                               success: { (responseJSON, data) in
            // Deserialize the data
            if let characterDetailResponseEntity = try? JSONDecoder().decode(CharacterDetailResponseEntity.self, from: data) {
                guard let characterDetailEntity = characterDetailResponseEntity.data?.results?.first,
                      let characterDetail = CharacterDetailModel(characterDetailEntity: characterDetailEntity) else {
                    completion(.failure(HTTPRequestService.genericError))
                    return
                }
                
                completion(.success(characterDetail))
            } else {
                // Data retrieved can't be processed
                completion(.failure(HTTPRequestService.genericError))
            }
        }, error: { (errorResponse) in
            // Return error in request
            completion(.failure(errorResponse))
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
