import Foundation

extension Error {
    // generic error to return if something unexpected happened
    var genericError: Error {
        NSError(domain: NSURLErrorDomain, code: 999, userInfo: nil)
    }
    var code: Int {
        (self as NSError).code
    }
    var domain: String {
        (self as NSError).domain
    }
}
