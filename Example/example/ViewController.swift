//
//  ViewController.swift
//  example
//
//  Created by Oliver Letterer on 03.03.19.
//  Copyright © 2019 Oliver Letterer. All rights reserved.
//

import UIKit
import KoalaInjection

class Dummy: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("-[\(self) initWithFrame:]")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("-[\(self) dealloc]")
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc dynamic func update(dummy: Dummy) {
        dummy.backgroundColor = UIColor.red
    }
    
    @objc dynamic func update(returned: Dummy) -> Bool {
        returned.backgroundColor = UIColor.red
        return true
    }
    
    @objc dynamic func update(object: Dummy) -> Dummy {
        object.backgroundColor = UIColor.red
        return object
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("-[\(self) viewWillDisappear:\(animated)]")
    }
}
