//
//  UIAlertController.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 11/11/21.
//

import UIKit

extension UIAlertController {
    static func show(title: String? = nil, message: String, completion: (() -> Void)? = nil) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: "ok".localized().uppercased(), style: .destructive, handler: { (_) in
        completion?()
      }))
      
      alert.present(animated: true, completion: nil)
    }
    
    static func showAlertMessage(vc: UIViewController,withTitle: String,
                          message: String,
                          addString: String,
                          cancelString: String,
                          isOk:(() -> Void)?,
                          isCancel:(() -> Void)?) -> Void {
        let alert = UIAlertController(title: withTitle, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: addString, style: .default, handler: { (action: UIAlertAction) in
            
            if (isOk != nil){
                
                do {
                    
                    try isOk!()
                    
                    
                }catch{
                    
                    alert.printLog(info: "", value: error.localizedDescription)
                }
            }
            
        }))
        
        if (isCancel != nil) {
            alert.addAction(UIAlertAction(title: cancelString, style: .cancel, handler: { (action: UIAlertAction) in
                isCancel!()
            }))
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
      if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
        if rootVC.presentedViewController == nil {
          rootVC.present(self, animated: true, completion: completion)
        } else {
          rootVC.presentedViewController?.present(self, animated: true, completion: nil)
        }
      }
    }
    
    func printLog(info:String,value:String){
        NSLog(info, value)
        print("Info:\n \(info) \n Value :\n \(value)")
    }
}
