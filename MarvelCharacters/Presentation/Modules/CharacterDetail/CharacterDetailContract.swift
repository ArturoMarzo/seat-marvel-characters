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
    func characterDetailWith(withCompletion completion: @escaping (Result<CharacterDetail, Error>) -> Void)
}

protocol CharacterDetailPresenterContract {
    func viewDidLoad()
    func retryButtonPressed()
}

protocol CharacterDetailViewContract: AnyObject {
    func showHUD()
    func hideHUD()
    func hideErrorMessage()
    func displayCharacterDetail(withViewModel viewModel: CharacterDetailViewModel)
    func displayErrorWith(message: String)
}

protocol CharacterDetailRouterContract {}

protocol CharacterDetailViewModelBuilderContract {
    func buildViewModel(characterDetail: CharacterDetail) -> CharacterDetailViewModel
}
