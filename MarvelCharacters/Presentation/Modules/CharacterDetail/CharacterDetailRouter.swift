import UIKit

class CharacterDetailRouter: CharacterDetailRouterContract {
    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}
