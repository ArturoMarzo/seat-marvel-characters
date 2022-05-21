import UIKit

/*
 This class allows to retrieve the information of configuration from
 the Configuration.plist file
 */
class Configuration {
    static let defaultEnvironment = "production"
    
    // Access to the file
    private static func getConfigFile() -> [String: AnyObject]? {
        let path = Bundle.main.path(forResource: "Configuration", ofType: "plist")!
        
        return NSDictionary(contentsOfFile: path) as? [String: AnyObject]
    }
    
    // Method to read the environment to wich request remote data
    static func selectedEnvironment() -> String {
        if let configDictionary = self.getConfigFile(),
            let serverConfig = configDictionary["SERVER_CONFIG"] as? [String: AnyObject],
            let selectedEnvironment = serverConfig["SelectedEnvironment"] as? String {
            
            return selectedEnvironment
        } else {
            
            return defaultEnvironment
        }
    }
}
