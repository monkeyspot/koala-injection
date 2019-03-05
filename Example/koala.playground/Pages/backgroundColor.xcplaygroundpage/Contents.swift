import UIKit
import KoalaInjection

let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
view.backgroundColor = UIColor.blue

view

view.koala🐨.layoutSubviews {
    $0.backgroundColor = UIColor.red
}

view.setNeedsLayout()
view
