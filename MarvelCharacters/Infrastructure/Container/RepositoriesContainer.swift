import Foundation

class RepositoriesContainer {
    static let shared = RepositoriesContainer()

    lazy var characterRepository: CharactersRepositoryContract = {
        let requestService = HTTPRequestManager()
        let localStoreManager = LocalStorageManager()
        
        return CharactersRepository(requestService: requestService, localStorageManager: localStoreManager)
    }()
}
