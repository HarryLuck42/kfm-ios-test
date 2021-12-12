//
//  Encryption.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 08/11/21.
//

import UIKit

class Encryption {
    static let keyData     = "f86618ad845d380e742cdacbead684b0".data(using:String.Encoding.utf8)!
    static let ivData      = "ff86618ad845d380".data(using:String.Encoding.utf8)!
    
    private class func xlEncrypt(data:Data, keyData:Data, ivData:Data, operation:Int) -> Data {
        let cryptLength  = size_t(data.count + kCCBlockSizeAES128)
        var cryptData = Data(count:cryptLength)
        
        let keyLength             = size_t(kCCKeySizeAES256)
        let options               = CCOptions(kCCOptionPKCS7Padding)
        
        
        var numBytesEncrypted :size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes {cryptBytes in
            data.withUnsafeBytes {dataBytes in
                ivData.withUnsafeBytes {ivBytes in
                    keyData.withUnsafeBytes {keyBytes in
                        CCCrypt(CCOperation(operation),
                                CCAlgorithm(kCCAlgorithmAES),
                                options,
                                keyBytes, keyLength,
                                ivBytes,
                                dataBytes, data.count,
                                cryptBytes, cryptLength,
                                &numBytesEncrypted)
                    }
                }
            }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
            
        } else {
            print("Error: \(cryptStatus)")
        }
        
        return cryptData
    }
    
    static func decrypt(param: String) -> String {
        let input = Data(base64Encoded: param, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        let decrypt = Encryption.xlEncrypt(data:input!, keyData:keyData, ivData:ivData, operation:kCCDecrypt)
        return (String(bytes:decrypt, encoding:String.Encoding.utf8)?.trimmingCharacters(in: CharacterSet(charactersIn: "\0")))!
    }
    
    static func encrypt(param: String) -> String {
        let messageData = param.data(using:String.Encoding.utf8)!
        let encryptedData = Encryption.xlEncrypt(data:messageData,   keyData:keyData, ivData:ivData, operation:kCCEncrypt)
        return encryptedData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    static func MD5(string: String) -> Data {
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData
    }
}
