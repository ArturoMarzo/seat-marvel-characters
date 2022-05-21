import UIKit

class Container {
    static let shared = Container()
}

// MARK: - AppDelegate
extension Container {
    func inject() -> UIWindow? {
        guard let window = window() else {
            return nil
        }
        
        return window
    }

    func window() -> UIWindow? {
        let window = UIWindow(frame: screen().bounds)
        
        guard let rootVC = Container.shared.charactersListBuilder().buildCharactersListModule() else {
            return nil
        }
        
        let charactersListNavigationController = BaseNavigationController(rootViewController: rootVC)
        charactersListNavigationController.interactivePopGestureRecognizer?.isEnabled = true
        window.rootViewController = charactersListNavigationController
        
        return window
    }

    func screen() -> UIScreen {
        return UIScreen.main
    }
}

extension Container {
    func sharedApplication() -> UIApplication {
        return UIApplication.shared
    }
}
