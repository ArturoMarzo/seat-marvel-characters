import UIKit

protocol CharactersRepositoryContract {
    func characters(offset: Int, completion: @escaping (Result<CharactersModel, Error>) -> Void)
    func characterDetailWith(id: UInt, completion: @escaping (Result<CharacterDetail, Error>) -> Void)
}

final class CharacterRepository: CharactersRepositoryContract {
    static let pageSize = 20
    
    func characters(offset: Int, completion: @escaping (Result<CharactersModel, Error>) -> Void) {
        var parameters = ServerHostURL.authenticationParameters()
        parameters["limit"] = CharacterRepository.pageSize
        parameters["offset"] = offset
        
        HTTPRequestService.request(url: ServerHostURL.charactersListURL(),
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
    
    func characterDetailWith(id: UInt, completion: @escaping (Result<CharacterDetail, Error>) -> Void) {
        let parameters = ServerHostURL.authenticationParameters()
        
        HTTPRequestService.request(url: ServerHostURL.characterDetailURL(id: id),
                                   httpMethod: .get,
                                   parameters: parameters,
                                   headers: nil,
                                   success: { (responseJSON, data) in
            // Deserialize the data
            if let characterDetailResponseEntity = try? JSONDecoder().decode(CharacterDetailResponseEntity.self, from: data) {
                guard let characterDetailEntity = characterDetailResponseEntity.data?.results?.first,
                      let characterDetail = CharacterDetail(characterDetailEntity: characterDetailEntity) else {
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
}
