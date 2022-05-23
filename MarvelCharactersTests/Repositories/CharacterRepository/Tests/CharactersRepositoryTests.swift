import XCTest
@testable import MarvelCharacters

// Bundle of tests for CharactersRepositoryTests functionality
class CharactersRepositoryTests: XCTestCase {
    var repository: CharactersRepositoryContract!
    var requestManagerMock: HTTPRequestManagerMock!
    var localStorageManagerMock: LocalStorageManagerMock!
    let favoritesCharactersSetKey = "favoritesCharactersSetKey"
    
    override func setUp() {
        requestManagerMock = HTTPRequestManagerMock()
        localStorageManagerMock = LocalStorageManagerMock()
        
        repository = CharactersRepository(requestManager: requestManagerMock,
                                          localStorageManager: localStorageManagerMock)
    }
    
    func test_givenARepository_whenCallTGoGetCharacters_thenRequestAndReturnASuccessfulResponse() {
        guard let successResponse = getResponseFrom(jsonFileName: "getCharactersSuccessResponse") else {
            XCTFail("Unable to load response")
            return
        }
        
        let success = expectation(description: "Success")
        let urlString = ServerHostURL.charactersListURL()
        let offset = 0
        let limit = 20
        var parameters = [String: Any]()
        parameters["limit"] = limit
        parameters["offset"] = offset
        
        requestManagerMock.successResponse = successResponse
        
        repository.getCharacters(offset: offset) { result in
            XCTAssertTrue(self.requestManagerMock.requestURLCalled)
            XCTAssertEqual(self.requestManagerMock.urlString, urlString)
            XCTAssertEqual(self.requestManagerMock.httpMethod, .get)
            XCTAssertEqual(self.requestManagerMock.parameters!["limit"] as! Int, limit)
            XCTAssertEqual(self.requestManagerMock.parameters!["offset"] as! Int, offset)
            XCTAssertNil(self.requestManagerMock.headers)
            
            switch result {
            case let .success(charactersModel):
                XCTAssertNotNil(charactersModel)
            case .failure(_):
                XCTFail("Invalid response")
            }
            
            success.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_givenARepository_whenCallTGoGetCharacters_thenRequestAndReturnANonParseableResponse() {
        guard let successResponse = getResponseFrom(jsonFileName: "getCharactersNonParseableResponse") else {
            XCTFail("Unable to load response")
            return
        }
        
        let failure = expectation(description: "failure")
        let urlString = ServerHostURL.charactersListURL()
        let offset = 0
        let limit = 20
        var parameters = [String: Any]()
        parameters["limit"] = limit
        parameters["offset"] = offset
        
        requestManagerMock.successResponse = successResponse
        
        repository.getCharacters(offset: offset) { result in
            XCTAssertTrue(self.requestManagerMock.requestURLCalled)
            XCTAssertEqual(self.requestManagerMock.urlString, urlString)
            XCTAssertEqual(self.requestManagerMock.httpMethod, .get)
            XCTAssertEqual(self.requestManagerMock.parameters!["limit"] as! Int, limit)
            XCTAssertEqual(self.requestManagerMock.parameters!["offset"] as! Int, offset)
            XCTAssertNil(self.requestManagerMock.headers)
            
            switch result {
            case .success(_):
                XCTFail("Invalid response")
            case let .failure(error):
                XCTAssertEqual(error, .parsing)
            }
            
            failure.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_givenARepository_whenCallTGoGetCharacters_thenRequestAndReturnAFailedResponse() {
        let failure = expectation(description: "failure")
        let urlString = ServerHostURL.charactersListURL()
        let offset = 0
        let limit = 20
        var parameters = [String: Any]()
        parameters["limit"] = limit
        parameters["offset"] = offset
        
        requestManagerMock.errorResponse = NSError().genericError
        
        repository.getCharacters(offset: offset) { result in
            XCTAssertTrue(self.requestManagerMock.requestURLCalled)
            XCTAssertEqual(self.requestManagerMock.urlString, urlString)
            XCTAssertEqual(self.requestManagerMock.httpMethod, .get)
            XCTAssertEqual(self.requestManagerMock.parameters!["limit"] as! Int, limit)
            XCTAssertEqual(self.requestManagerMock.parameters!["offset"] as! Int, offset)
            XCTAssertNil(self.requestManagerMock.headers)
            
            switch result {
            case .success(_):
                XCTFail("Invalid response")
            case let .failure(error):
                XCTAssertEqual(error, .genericError)
            }
            
            failure.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_givenARepository_whenCallToGetCharacterDetail_thenRequestAndReturnASuccessfulResponse() {
        guard let successResponse = getResponseFrom(jsonFileName: "getCharacterDetailSuccessResponse") else {
            XCTFail("Unable to load response")
            return
        }
        
        let characterId: UInt = 1
        let success = expectation(description: "Success")
        let urlString = ServerHostURL.characterDetailURL(id: characterId)
        
        requestManagerMock.successResponse = successResponse
        
        repository.getCharacterDetailWith(characterId: characterId) { result in
            XCTAssertTrue(self.requestManagerMock.requestURLCalled)
            XCTAssertEqual(self.requestManagerMock.urlString, urlString)
            XCTAssertEqual(self.requestManagerMock.httpMethod, .get)
            XCTAssertNil(self.requestManagerMock.headers)
            
            switch result {
            case let .success(characterModel):
                XCTAssertNotNil(characterModel)
            case .failure(_):
                XCTFail("Invalid response")
            }
            
            success.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_givenARepository_whenCallToGetCharacterDetail_thenRequestAndReturnANonParseableResponse() {
        guard let successResponse = getResponseFrom(jsonFileName: "getCharacterDetailNonParseableResponse") else {
            XCTFail("Unable to load response")
            return
        }
        
        let characterId: UInt = 1
        let failure = expectation(description: "failure")
        let urlString = ServerHostURL.characterDetailURL(id: characterId)
        
        requestManagerMock.successResponse = successResponse
        
        repository.getCharacterDetailWith(characterId: characterId) { result in
            XCTAssertTrue(self.requestManagerMock.requestURLCalled)
            XCTAssertEqual(self.requestManagerMock.urlString, urlString)
            XCTAssertEqual(self.requestManagerMock.httpMethod, .get)
            XCTAssertNil(self.requestManagerMock.headers)
            
            switch result {
            case .success(_):
                XCTFail("Invalid response")
            case let .failure(error):
                XCTAssertEqual(error, .parsing)
            }
            
            failure.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_givenARepository_whenCallToGetCharacterDetail_thenRequestAndReturnAFailedResponse() {
        let characterId: UInt = 1
        let failure = expectation(description: "failure")
        let urlString = ServerHostURL.characterDetailURL(id: characterId)
        
        requestManagerMock.errorResponse = NSError().genericError
        
        repository.getCharacterDetailWith(characterId: characterId) { result in
            XCTAssertTrue(self.requestManagerMock.requestURLCalled)
            XCTAssertEqual(self.requestManagerMock.urlString, urlString)
            XCTAssertEqual(self.requestManagerMock.httpMethod, .get)
            XCTAssertNil(self.requestManagerMock.headers)
            
            switch result {
            case .success(_):
                XCTFail("Invalid response")
            case let .failure(error):
                XCTAssertEqual(error, .genericError)
            }
            
            failure.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_givenARepository_whenICallToStoreAsFavoriteCharacter_thenStoreIdIsCalled() {
        let characterId: UInt = 1
        
        repository.storeAsFavoriteCharacterWith(characterId: characterId)
        
        XCTAssertTrue(localStorageManagerMock.storeIdCalled)
        XCTAssertEqual(localStorageManagerMock.id, characterId)
        XCTAssertEqual(localStorageManagerMock.collectionKey, favoritesCharactersSetKey)
    }
    
    func test_givenARepository_whenICallToRemoveAsFavoriteCharacter_thenRemoveIdIsCalled() {
        let characterId: UInt = 1
        
        repository.removeAsFavoriteCharacterWith(characterId: characterId)
        
        XCTAssertTrue(localStorageManagerMock.removeIdCalled)
        XCTAssertEqual(localStorageManagerMock.id, characterId)
        XCTAssertEqual(localStorageManagerMock.collectionKey, favoritesCharactersSetKey)
    }
    
    func test_givenARepository_whenICallToCharacterIsFavorite_thenIdContainedInCollectionIsCalled() {
        let characterId: UInt = 1
        localStorageManagerMock.idContainedInCollectionResponse = true
        
        let characterIsFavorite = repository.characterIsFavorite(characterId: characterId)
        
        XCTAssertTrue(localStorageManagerMock.idContainedInCollectionCalled)
        XCTAssertTrue(characterIsFavorite)
        XCTAssertEqual(localStorageManagerMock.id, characterId)
        XCTAssertEqual(localStorageManagerMock.collectionKey, favoritesCharactersSetKey)
    }
}
