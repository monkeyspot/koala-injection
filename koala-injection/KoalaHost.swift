//
//  KoalaHost.swift
//  KoalaInjection
//
//  Created by Oliver Letterer on 03.03.19.
//  Copyright © 2019 Oliver Letterer. All rights reserved.
//

import Foundation

public protocol KoalaHost: AnyObject {}

public extension KoalaHost where Self: NSObject {
    var koala: KoalaProxy<Self, After> {
        return KoalaProxy(object: self)
    }
}

extension NSObject: KoalaHost {}
