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
        window?.koala🐨.layoutSubviews {
            $0.rootViewController?.view.backgroundColor = [UIColor.orange, UIColor.red, UIColor.blue].randomElement()!
        }
        
        testMemory()
        playground()
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.window?.rootViewController?.koala🐨.before.viewWillDisappear {
                $1.arguments()[0] = true // always disappear "animted"
            }

            self.window?.rootViewController = ViewController()
        }
        
        return true
    }
    
    func testMemory() {
        print("===========================================================================")
        
        let viewController = ViewController()
        
        viewController.koala🐨.before.updateWithReturned {
            $1.arguments()[0] = Dummy()
        }
        
        viewController.koala🐨.updateWithReturned { (object, invocation, result) -> Bool in
            print("\(object), \(invocation), \(result)")
            return !result
        }
        
        viewController.koala🐨.before.updateWithObject {
            $1.arguments()[0] = Dummy()
        }
        
        viewController.koala🐨.updateWithObject { (object, invocation, result) -> Dummy in
            print("\(object), \(invocation), \(result)")
            return result
        }
        
        viewController.koala🐨.updateWithObject { () -> Dummy in
            return Dummy()
        }
        
        let _ = viewController.update(dummy: Dummy(frame: CGRect.zero))
        let _ = viewController.update(returned: Dummy(frame: CGRect.zero))
        let _ = viewController.update(object: Dummy(frame: CGRect.zero))
        print("===========================================================================")
    }
    
    func playground() {
        // transform return value
        window?.rootViewController?.title = "Hello"
        window?.rootViewController?.koala🐨.title {
            return ($2 as NSString?)?.appending(" world")
        }
        
        window?.rootViewController?.koala🐨.title { (_, _, result) -> NSString? in
            return result?.appending(" world") as NSString?
        }
        
        // get and set arguments before
        window?.rootViewController?.koala🐨.before.setTitle {
            print($1.arguments()[0] as NSString)
            $1.arguments()[0] = "Hello world" as NSString
        }
        
        // get arguments after
        window?.rootViewController?.koala🐨.setTitle {
            print($1.arguments()[0] as NSString)
            $1.arguments()[0] = "Hello world" as NSString
        }
        
        // no return before
        window?.rootViewController?.koala🐨.before.prefersStatusBarHidden {
            return Bool.random()
        }
        
        // return after
        window?.rootViewController?.koala🐨.prefersStatusBarHidden {
            return Bool.random()
        }
        
        print(window?.rootViewController?.prefersStatusBarHidden ?? false)
        print(window?.rootViewController?.prefersStatusBarHidden ?? false)
        print(window?.rootViewController?.prefersStatusBarHidden ?? false)
        print(window?.rootViewController?.prefersStatusBarHidden ?? false)
        print(window?.rootViewController?.prefersStatusBarHidden ?? false)
    }
}
