//
//  NSObject.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 09/11/21.
//

import Foundation
import UIKit

extension NSObject{
    
    //Name Of class
    class var stringRepresentation: String {
        let name = String(describing:self)
        return name
        
    }
    
}
