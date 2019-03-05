//
//  ViewController.swift
//  example
//
//  Created by Oliver Letterer on 03.03.19.
//  Copyright © 2019 Oliver Letterer. All rights reserved.
//

import UIKit
import KoalaInjection

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("-[\(self) viewWillDisappear:\(animated)]")
    }
}
