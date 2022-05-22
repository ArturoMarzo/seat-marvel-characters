import Foundation
import UIKit

/*
By defining a contract it is easier to see the relationship between the
presenter, the view, the router... in VIPER. It also makes easier to test the different layers
*/

protocol CharacterDetailBuilderContract {
    func buildCharacterDetailModuleWith(characterId: UInt) -> UIViewController?
}

protocol CharacterDetailInteractorManagerContract {
    func characterDetailWith(completion: @escaping (Result<CharacterDetailModel, Error>) -> Void)
    func storeAsFavoriteCharacter()
    func removeAsFavoriteCharacter()    
    func characterIsFavorite() -> Bool
}

protocol CharacterDetailPresenterContract {
    func viewDidLoad()
    func retryButtonPressed()
    func favoriteButtonPressed()
}

protocol CharacterDetailViewContract: AnyObject {
    func showHUD()
    func hideHUD()
    func hideErrorMessage()
    func displayCharacterDetailWith(viewModel: CharacterDetailViewModel)
    func displayErrorWith(message: String)
    func setFavorite(value: Bool)
}

protocol CharacterDetailRouterContract {}

protocol CharacterDetailViewModelBuilderContract {
    func buildViewModel(characterDetail: CharacterDetailModel) -> CharacterDetailViewModel
}
