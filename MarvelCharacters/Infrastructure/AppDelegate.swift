import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let container = Container.shared
    private let repositoriesContainer = RepositoriesContainer.shared


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        // Short-circuit starting app if running unit tests
        let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        guard !isUnitTesting else {
            return true
        }
        #endif
        
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
