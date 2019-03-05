//
//  KoalaProxy+Selectors.swift
//  KoalaInjection
//
//  Created by Oliver Letterer on 05.03.19.
//  Copyright © 2019 Oliver Letterer. All rights reserved.
//

import Foundation

public extension KoalaProxy where Location: Before {
    public subscript(selector: Selector) -> (@escaping () -> Void) -> Void {
        return self[dynamicMember: selector.description.replacingOccurrences(of: ":", with: "")]
    }
    
    public subscript(selector: Selector) -> (@escaping (Type) -> Void) -> Void {
        return self[dynamicMember: selector.description.replacingOccurrences(of: ":", with: "")]
    }
    
    public subscript(selector: Selector) -> (@escaping (Type, Invocation<Location>) -> Void) -> Void {
        return self[dynamicMember: selector.description.replacingOccurrences(of: ":", with: "")]
    }
}

public extension KoalaProxy where Location: After {
    public subscript<T>(selector: Selector) -> (@escaping () -> T) -> Void where T: Any {
        return self[dynamicMember: selector.description.replacingOccurrences(of: ":", with: "")]
    }

    public subscript<T>(selector: Selector) -> (@escaping (Type) -> T) -> Void where T: Any {
        return self[dynamicMember: selector.description.replacingOccurrences(of: ":", with: "")]
    }

    public subscript<T>(selector: Selector) -> (@escaping (Type, Invocation<Location>) -> T) -> Void where T: Any {
        return self[dynamicMember: selector.description.replacingOccurrences(of: ":", with: "")]
    }

    public subscript<T>(selector: Selector) -> (@escaping (Type, Invocation<Location>, T) -> T) -> Void where T: Any {
        return self[dynamicMember: selector.description.replacingOccurrences(of: ":", with: "")]
    }
}
