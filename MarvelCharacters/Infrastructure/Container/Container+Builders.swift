import Foundation

extension Container {
    func charactersListBuilder() -> CharactersListBuilderContract {
        return CharactersListBuilder()
    }
    
    func characterDetailBuilder() -> CharacterDetailBuilderContract {
        return CharacterDetailBuilder()
    }
}
