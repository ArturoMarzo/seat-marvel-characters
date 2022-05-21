import Foundation

class RepositoriesContainer {
    static let shared = RepositoriesContainer()

    lazy var characterRepository: CharactersRepositoryContract = {
        return CharacterRepository()
    }()
}
