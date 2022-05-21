import UIKit
import os
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

// Class to store generics methods that can be used all along the project

// Logs a string in debug mode
func DLog( message: @autoclosure () -> String, filename: String = #file, function: String = #function, line: Int = #line) {
    
    if #available(iOS 10.0, *) {
        let lastPathComponent = (filename as NSString).lastPathComponent
        //        let output = "\(lastPathComponent):\(line): \(function):" + message()
        os_log("%{public}@ %{public}@", type: .debug, "\(lastPathComponent):\(line): \(function):", message())
    } else {
        #if DEBUG
        let lastPathComponent = (filename as NSString).lastPathComponent
        NSLog("\(lastPathComponent):\(line): \(function): %@", message())
        #endif
    }
}

func MD5(string: String) -> Data {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: length)

    _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
        messageData.withUnsafeBytes { messageBytes -> UInt8 in
            if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                let messageLength = CC_LONG(messageData.count)
                CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
            }
            return 0
        }
    }
    return digestData
}
