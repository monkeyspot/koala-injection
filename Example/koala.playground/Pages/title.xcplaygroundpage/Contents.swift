import UIKit
import KoalaInjection

let viewController = UIViewController()
viewController.title = "Hello"

viewController.title

viewController.koala🐨.title { (_, _, result) -> NSString? in
    return result?.appending(" world") as NSString?
}

viewController.title
