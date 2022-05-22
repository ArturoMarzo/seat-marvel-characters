import Foundation

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

/*
 This class implements HTTPRequestManagerContract to be used by repositories
 */
class HTTPRequestManager: HTTPRequestManagerContract {
    // With this generic method can be built any request needed for remote services
    func request(url urlString: String,
                 httpMethod: HTTPMethod,
                 parameters: [String: Any]?,
                 headers: Dictionary<String, String>?,
                 success: @escaping (_ responseJSON: String, _ data: Data) -> Void,
                 error: @escaping (_ error: Error) -> Void) {
        var urlWithComponents = URL(string: urlString)
        
        if httpMethod == .get, let parameters = parameters, !parameters.isEmpty {
            guard var urlComponents = URLComponents(string: urlString) else {
                error(NSError().genericError)
                return
            }
            
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems!.append(queryItem)
            }
            
            urlWithComponents = urlComponents.url
        }
        
        // Incorrect url
        guard let url = urlWithComponents else {
            error(NSError().genericError)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        // Add optional body parameters
        if httpMethod != .get , let parameters = parameters {
            request.httpBody = parameters.percentEscaped().data(using: .utf8)
        }
        
        // Add optional headers
        if let headers = headers {
            for (headerField, value) in headers {
                request.setValue(value, forHTTPHeaderField: headerField)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, errorResponse in
            guard errorResponse == nil else {
                // A failure has happened during the request
                // Return the data in main thread to prevent failures modifying the interface
                DispatchQueue.main.async {
                    error(errorResponse ?? NSError().genericError)
                }
                return
            }
            
            // Aparently no errors happened
            if let data = data,
               let responseJSON = String(data: data, encoding: .utf8) {
                // The data in the JSON is stored in a string
                // Return the data in main thread to prevent failures modifying the interface
                DispatchQueue.main.async {
                    success(responseJSON, data)
                }
            } else {
                // Incorrect data
                // Return the data in main thread to prevent failures modifying the interface
                DispatchQueue.main.async {
                    error(NSError().genericError)
                }
            }
        }
        
        task.resume()
    }
}
