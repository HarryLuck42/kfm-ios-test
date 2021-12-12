//
//  ApiError.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 08/11/21.
//

import Foundation

enum ApiError: Error {
    case connectionError(code: Int)
    case invalidJSONError(code: Int)
    case middlewareError(code: Int, message: String?)
    case failedMappingError(code: Int)
    case emptyError(message: String?)
    var code: Int {
        switch self {
        case .connectionError(let code):   //Connection erroe
            return code
        case .invalidJSONError(let code):         //Invalid JSON
            return code
        case .middlewareError(let code, _):          //Response from BE
            return code
        case .failedMappingError(let code):           //Invalid object
            return code
        case .emptyError:
            return 0
        }
    }
    var localizedDescription: String {
        switch self {
        case .connectionError:   //Connection erroe
            return "error_connection"
        case .invalidJSONError:         //Invalid JSON
            return "error_json"
        case .middlewareError(_, let message):          //Response from BE
            return message ?? ""
        case .failedMappingError:           //Invalid object
            return "failed_mapping"
        case .emptyError(let message):
            return message ?? ""
        }
    }
    
}
