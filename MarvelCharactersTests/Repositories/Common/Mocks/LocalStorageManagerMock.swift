import XCTest
@testable import MarvelCharacters

// Mock to simulate read/write processes in local storage
class LocalStorageManagerMock: LocalStorageManagerContract {
    var storeIdCalled = false
    var removeIdCalled = false
    var idContainedInCollectionCalled = false
    var id: UInt?
    var collectionKey: String?
    var idContainedInCollectionResponse = false
    
    func storeId(id: UInt, collectionKey: String) {
        storeIdCalled = true
        self.id = id
        self.collectionKey = collectionKey
    }
    
    func removeId(id: UInt, collectionKey: String) {
        removeIdCalled = true
        self.id = id
        self.collectionKey = collectionKey
    }
    
    func idContainedInCollection(id: UInt, collectionKey: String) -> Bool {
        idContainedInCollectionCalled = true
        self.id = id
        self.collectionKey = collectionKey
        
        return idContainedInCollectionResponse
    }
}
