import UIKit

/*
 This class allows to configure different environments to request remote data.
 For the moment only has information for a production environment
 */
class ServerHostURL {
    enum Environment: String {
        
        case mock = "mock"
        case development = "development"
        case test = "test"
        case production = "production"
    }
    
    private static let directoryMock = ""
    private static let directoryDevelopment = ""
    private static let directoryTest = ""
    private static let directoryProduction = "https://gateway.marvel.com/"
    
    private static let apiVersionMock = ""
    private static let apiVersionDevelopment = ""
    private static let apiVersionTest = ""
    private static let apiVersionProduction = "v1"
    
    private static let charactersListPath = "public/characters"
    private static let characterDetailPath = "public/characters/%u"
    
    private static let publicKey = "06b43310e20a115ad114ac01009310a2"
    private static let privateKey = "e88852df5c88a98f84b0ae64686c5b48ba579bc1"
    
    private static let selectedEnvironment = Environment(rawValue: Configuration.selectedEnvironment()) ?? Environment.production
    
    static func authenticationParameters() -> [String: Any] {
        let timeStamp = String(Int(Date().timeIntervalSince1970))
        return ["ts": timeStamp,
                "apikey": publicKey,
                "hash": MD5(string: "\(timeStamp)\(privateKey)\(publicKey)").map { String(format: "%02hhx", $0) }.joined()]
    }
    
    static func charactersListURL() -> String {
        return getEnvironmentURLForEnvironment(selectedEnvironment, path: charactersListPath)
    }
    
    static func characterDetailURL(id: UInt) -> String {
        return getEnvironmentURLForEnvironment(selectedEnvironment, path: String.init(format: characterDetailPath, id))
    }
}

// MARK: - Private Methods
private extension ServerHostURL {
    private static func getEnvironmentURLForEnvironment(_ selectedEnvironment: Environment, path: String) -> String {
        var urlPath: String
        switch selectedEnvironment {
        case .mock:
            urlPath = directoryDevelopment + apiVersionMock + "/" + path
        case .development:
            urlPath = directoryDevelopment + apiVersionDevelopment + "/" + path
        case .test:
            urlPath = directoryTest + apiVersionTest  + "/" + path
        case .production:
            urlPath = directoryProduction + apiVersionProduction + "/" + path
        }
        
        return urlPath
    }
}
