//
//  UIViewController.swift
//  HarryWeather
//
//  Created by Hariyanto Lukman on 11/12/21.
//

import Foundation
import UIKit

extension UIViewController{
    
    func handleAPIError(error: ApiError) {
        switch error {
        case .connectionError:
            UIAlertController.showAlertMessage(vc: self, withTitle: "no_internet".localized(), message: "check_your_internet".localized(), addString: "retry".localized(), cancelString: "cancel".localized(), isOk: {
                self.viewWillAppear(true)
                self.viewDidAppear(true)
            }, isCancel: {
                
            })
        case .middlewareError(_, let message):
            self.view.makeToast(message)
        case .emptyError(let message):
            self.view.makeToast(message)
        default:
            UIAlertController.show(message: error.localizedDescription)
        }
    }
}
