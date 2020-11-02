//
//  AppDelegate.swift
//  TinderCardDemo
//
//  Created by Dung Vu on 10/30/20.
//

import UIKit
import RIBs

#if DEBUG
var loadFile: Bool = false
var loadNumberItems: Int = 50
let urlPathWrong: String = "/abc"
var urlArgument: String?
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TinderCardDemoDependency {
    var window: UIWindow?
    private lazy var builder: TinderCardDemoBuilder = TinderCardDemoBuilder(dependency: self)
    private var launchRouter: LaunchRouting?
    private lazy var mNetworkRequester: NetworkRequester = {
        #if DEBUG
        if CommandLine.arguments.contains("requester-testing-wrongPath") {
            urlArgument = urlPathWrong
        }
        
        if CommandLine.arguments.contains("requester-load-only-two") {
            loadNumberItems = 2
        }
        
        if CommandLine.arguments.contains("requester-load-local-file"){
            loadFile = true
        }
        
        return .default
        #else
        return .default
        #endif
    }()
    
    var networkRequester: RequestNetworkProtocol {
        return mNetworkRequester
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let launchRouter = builder.build()
        self.launchRouter = launchRouter
        launchRouter.launchFromWindow(window)
        return true
    }
}

