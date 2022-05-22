import Foundation
import UIKit

/*
By defining a contract it is easier to see the relationship between the
presenter, the view, the router... in VIPER. It also makes easier to test the different layers
*/

protocol CharactersListBuilderContract {
    func buildCharactersListModule() -> UIViewController?
}

protocol CharactersListInteractorManagerContract {
    func characters(offset: Int, completion: @escaping (Result<CharactersModel, NetworkError>) -> Void)
}

protocol CharactersListPresenterContract: LoadingTableViewCellDelegate {
    func viewDidLoad()
    func loadingCellShown()
    func retryButtonPressed()
    func selectedCharacterWith(characterId: UInt)
}

protocol CharactersListViewContract: AnyObject {
    func showHUD()
    func hideHUD()
    func hideErrorMessage()
    func displayCharacters(withViewModel viewModel: CharactersListViewModel)
    func displayErrorWith(message: String)
}

protocol CharactersListRouterContract {
    func navigateToCharacterDetailWith(characterId: UInt)
}

protocol CharactersListViewModelBuilderContract {
    func buildViewModel(characters: CharactersModel) -> CharactersListViewModel
    func buildViewModelWith(viewModel: CharactersListViewModel,
                            appendingCharacters characters: CharactersModel) -> CharactersListViewModel
    func buildViewModel(characters: [CharacterViewModel],
                        charactersListViewModelMode: CharactersListViewModelMode) -> CharactersListViewModel
}
