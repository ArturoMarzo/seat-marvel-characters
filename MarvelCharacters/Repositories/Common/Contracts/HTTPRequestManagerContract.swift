import Foundation

/*
 By defining this contract, the manager developed to request data can be easily changed to different libraries like AFNetworking
 without affecting the repositories
 */

protocol HTTPRequestManagerContract {
    func request(url urlString: String,
                 httpMethod: HTTPMethod,
                 parameters: [String: Any]?,
                 headers: Dictionary<String, String>?,
                 success: @escaping (_ responseJSON: String, _ data: Data) -> Void,
                 error: @escaping (_ error: Error) -> Void)
}

// With this enumeration it can be built all kind of requests for remote services
enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
    case patch = "PATCH"
}
