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
    @available(*, deprecated: 1.0, message: "use KoalaHost.koala🐨 instead")
    var koala: KoalaProxy<Self, After> {
        return KoalaProxy(object: self)
    }
    
    var koala🐨: KoalaProxy<Self, After> {
        return KoalaProxy(object: self)
    }
}

extension NSObject: KoalaHost {}
