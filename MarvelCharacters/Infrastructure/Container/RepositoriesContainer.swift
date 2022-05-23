import Foundation

class RepositoriesContainer {
    static let shared = RepositoriesContainer()

    lazy var characterRepository: CharactersRepositoryContract = {
        let requestManager = HTTPRequestManager()
        let localStoreManager = LocalStorageManager()
        
        return CharactersRepository(requestManager: requestManager, localStorageManager: localStoreManager)
    }()
}
