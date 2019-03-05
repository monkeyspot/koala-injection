//
//  AppDelegate.swift
//  example
//
//  Created by Oliver Letterer on 03.03.19.
//  Copyright © 2019 Oliver Letterer. All rights reserved.
//

import UIKit
import KoalaInjection

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // inject code
        window?.koala.layoutSubviews {
            $0.rootViewController?.view.backgroundColor = [UIColor.orange, UIColor.red, UIColor.blue].randomElement()!
        }
        
        playground()
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.window?.rootViewController?.koala.before.viewWillDisappear {
                $1.arguments()[0] = true // always disappear "animted"
            }
            
            self.window?.rootViewController = ViewController()
        }
        
        return true
    }
    
    func playground() {
        // transform return value
        window?.rootViewController?.title = "Hello"
        window?.rootViewController?.koala.title {
            return ($2 as NSString?)?.appending(" world")
        }
        
        // get and set arguments before
        window?.rootViewController?.koala.before.setTitle {
            print($1.arguments()[0] as NSString)
            $1.arguments()[0] = "Hello world" as NSString
        }
        
        // get arguments after
        window?.rootViewController?.koala.setTitle {
            print($1.arguments()[0] as NSString)
            $1.arguments()[0] = "Hello world" as NSString
        }
        
        // no return before
        window?.rootViewController?.koala.before.prefersStatusBarHidden {
            return Bool.random()
        }
        
        // return after
        window?.rootViewController?.koala.prefersStatusBarHidden {
            return Bool.random()
        }
        
        print(window?.rootViewController?.prefersStatusBarHidden ?? false)
        print(window?.rootViewController?.prefersStatusBarHidden ?? false)
        print(window?.rootViewController?.prefersStatusBarHidden ?? false)
        print(window?.rootViewController?.prefersStatusBarHidden ?? false)
        print(window?.rootViewController?.prefersStatusBarHidden ?? false)

    }
}
