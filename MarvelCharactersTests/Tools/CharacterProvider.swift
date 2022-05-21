import UIKit

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
