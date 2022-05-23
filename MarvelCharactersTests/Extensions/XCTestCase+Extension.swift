import XCTest

extension XCTestCase {
    // Method to test repositories by loading json files to use them as services responses
    func getResponseFrom(jsonFileName: String) -> (responseJSON: String, data: Data)? {
        let bundle = Bundle(for: type(of: self))

        guard let url = bundle.url(forResource: jsonFileName, withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
            return nil
        }

        return (String(data: data, encoding: .utf8) ?? "", data)
    }
}
