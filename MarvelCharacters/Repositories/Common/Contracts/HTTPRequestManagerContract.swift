import Foundation

/*
 By defining this contract, the manager developed to request data can be easily changed from to different libraries like
 AFNetworking without affecting the repositories
 */

protocol HTTPRequestManagerContract {
    func request(url urlString: String,
                 httpMethod: HTTPMethod,
                 parameters: [String: Any]?,
                 headers: Dictionary<String, String>?,
                 success: @escaping (_ responseJSON: String, _ data: Data) -> Void,
                 error: @escaping (_ error: Error) -> Void)
}
