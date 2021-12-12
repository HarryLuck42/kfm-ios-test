//
//  AppDelegate.swift
//  BaseHariyantoProject
//
//  Created by Hariyanto Lukman on 04/11/21.
//

import UIKit
import RxSwift
import RxCocoa
import Reachability
import netfox
import AlamofireNetworkActivityLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, URLSessionDelegate, URLSessionTaskDelegate {
    
    static let current = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    var urlSession: URLSession!
    
    func sslPinningTrustKit() {
        self.urlSession = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                     delegate: self,
                                     delegateQueue: OperationQueue.main)
    }
    
    lazy var sessionPINNING: URLSession = {
        URLSession(configuration: URLSessionConfiguration.ephemeral,
                   delegate: self,
                   delegateQueue: OperationQueue.main)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let main = MainViewController.init(nibName: MainViewController.stringRepresentation, bundle: nil)
        window?.rootViewController = main
        
        window?.makeKeyAndVisible()
        
//        #if DEVELOPMENT || NETFOX || STAGING
        NFX.sharedInstance().start()
        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
        
//        #endif
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    
    
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    
}

