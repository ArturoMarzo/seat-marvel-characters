import XCTest
@testable import MarvelCharacters

// Mock to simulate responses from services
class HTTPRequestManagerMock: HTTPRequestManagerContract {
    var requestURLCalled = false
    var urlString = ""
    var httpMethod: HTTPMethod? = nil
    var parameters: [String : Any]?
    var headers: Dictionary<String, String>?
    var successResponse: (responseJSON: String, data: Data)?
    var errorResponse: Error?
    
    func request(url urlString: String,
                 httpMethod: HTTPMethod,
                 parameters: [String : Any]?,
                 headers: Dictionary<String, String>?,
                 success: @escaping (String, Data) -> Void,
                 error: @escaping (Error) -> Void) {
        requestURLCalled = true
        self.urlString = urlString
        self.httpMethod = httpMethod
        self.parameters = parameters
        self.headers = headers
        
        if let successResponse = successResponse {
            success(successResponse.responseJSON, successResponse.data)
            return
        }
        
        if let errorResponse = errorResponse {
            error(errorResponse)
            return
        }
    }
}
