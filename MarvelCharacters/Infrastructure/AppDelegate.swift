import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let container = Container.shared
    private let repositoriesContainer = RepositoriesContainer.shared


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureMainViewController(application)
        
        return true
    }
}

extension AppDelegate {
    // MARK: - Main View Controller
    private func configureMainViewController(_ application: UIApplication) {
        window = container.inject()
        window!.makeKeyAndVisible()
    }
}
