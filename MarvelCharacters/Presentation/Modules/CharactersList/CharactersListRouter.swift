import UIKit

class CharactersListRouter: CharactersListRouterContract {
    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK - Navigation functions
    func navigateToCharacterDetailWith(characterId: UInt) {
        guard let characterDetailViewController =
                characterDetailBuilder().buildCharacterDetailModuleWith(characterId: characterId) else {
            return
        }
        
        viewController?.navigationController?.pushViewController(characterDetailViewController, animated: true)
    }
    
    // MARK: - Private functions
    private func characterDetailBuilder() -> CharacterDetailBuilderContract {
        return Container.shared.characterDetailBuilder()
    }
}
