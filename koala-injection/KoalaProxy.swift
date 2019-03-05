//
//  KoalaProxy.swift
//  KoalaInjection
//
//  Created by Oliver Letterer on 03.03.19.
//  Copyright © 2019 Oliver Letterer. All rights reserved.
//

import Foundation

public protocol InjectionLocation {}

public class Before: InjectionLocation {}
public class After: InjectionLocation {}

@dynamicMemberLookup
public class KoalaProxy<Type: AnyObject, Location: InjectionLocation> {
    private let object: Type
    private let injectBefore: Bool

    private init(object: Type, injectBefore: Bool) {
        self.object = object
        self.injectBefore = injectBefore
    }
}

public extension KoalaProxy where Location: Before {
    public convenience init(object: Type) {
        self.init(object: object, injectBefore: true)
    }
}

public extension KoalaProxy where Location: After {
    public convenience init(object: Type) {
        self.init(object: object, injectBefore: false)
    }
    
    var before: KoalaProxy<Type, Before> {
        return KoalaProxy<Type, Before>(object: self.object)
    }
}

// only allow Void return typed method implementation before the original implementation
public extension KoalaProxy where Location: Before {
    public subscript(dynamicMember member: String) -> (@escaping () -> Void) -> Void {
        return { closure in
            koala_hookMember(self.object, member, self.injectBefore, { _, _ in
                return closure()
            })
        }
    }
    
    public subscript(dynamicMember member: String) -> (@escaping (Type) -> Void) -> Void {
        return { closure in
            koala_hookMember(self.object, member, self.injectBefore, { object, _ in
                closure(object as! Type)
            })
        }
    }
    
    public subscript(dynamicMember member: String) -> (@escaping (Type, Invocation<Location>) -> Void) -> Void {
        return { closure in
            koala_hookMember(self.object, member, self.injectBefore, { object, invocation in
                closure(object as! Type, Invocation(invocation: invocation))
            })
        }
    }
}


// allow arbitrary return types after original implementation, except void return typed
public extension KoalaProxy where Location: After {
    public subscript<T>(dynamicMember member: String) -> (@escaping () -> T) -> Void where T: AnyObject {
        return { closure in
            koala_hookMember(self.object, member, self.injectBefore, { _, invocation in
                var value = Unmanaged.passRetained(closure())
                invocation.setReturnValue(&value)
            })
        }
    }
    
    public subscript<T>(dynamicMember member: String) -> (@escaping (Type) -> T) -> Void where T: AnyObject {
        return { closure in
            koala_hookMember(self.object, member, self.injectBefore, { object, invocation in
                var value = Unmanaged.passRetained(closure(object as! Type))
                invocation.setReturnValue(&value)
            })
        }
    }
    
    public subscript<T>(dynamicMember member: String) -> (@escaping (Type, Invocation<Location>) -> T) -> Void where T: AnyObject {
        return { closure in
            koala_hookMember(self.object, member, self.injectBefore, { object, invocation in
                var value = Unmanaged.passRetained(closure(object as! Type, Invocation(invocation: invocation)))
                invocation.setReturnValue(&value)
            })
        }
    }
    
    public subscript<T>(dynamicMember member: String) -> (@escaping (Type, Invocation<Location>, T) -> T) -> Void where T: AnyObject {
        return { closure in
            koala_hookMember(self.object, member, self.injectBefore, { object, invocation in
                var returned: Unmanaged<T>?
                invocation.getReturnValue(&returned)
                
                var value = Unmanaged.passRetained(closure(object as! Type, Invocation(invocation: invocation), returned!.takeUnretainedValue()))
                invocation.setReturnValue(&value)
            })
        }
    }
    
    public subscript<T>(dynamicMember member: String) -> (@escaping () -> T) -> Void where T: Any {
        return { closure in
            koala_hookMember(self.object, member, self.injectBefore, { _, invocation in
                var value: T? = closure()
                invocation.setReturnValue(&value)
            })
        }
    }
    
    public subscript<T>(dynamicMember member: String) -> (@escaping (Type) -> T) -> Void where T: Any {
        return { closure in
            koala_hookMember(self.object, member, self.injectBefore, { object, invocation in
                var value: T? = closure(object as! Type)
                invocation.setReturnValue(&value)
            })
        }
    }
    
    public subscript<T>(dynamicMember member: String) -> (@escaping (Type, Invocation<Location>) -> T) -> Void where T: Any {
        return { closure in
            koala_hookMember(self.object, member, self.injectBefore, { object, invocation in
                var value: T? = closure(object as! Type, Invocation(invocation: invocation))
                invocation.setReturnValue(&value)
            })
        }
    }
    
    public subscript<T>(dynamicMember member: String) -> (@escaping (Type, Invocation<Location>, T) -> T) -> Void where T: Any {
        return { closure in
            koala_hookMember(self.object, member, self.injectBefore, { object, invocation in
                var returned: T?
                invocation.getReturnValue(&returned)
                
                var value: T? = closure(object as! Type, Invocation(invocation: invocation), returned!)
                invocation.setReturnValue(&value)
            })
        }
    }
    
    public subscript(dynamicMember member: String) -> (@escaping () -> Void) -> Void {
        return { closure in
            koala_hookMember(self.object, member, self.injectBefore, { _, _ in
                return closure()
            })
        }
    }
    
    public subscript(dynamicMember member: String) -> (@escaping (Type) -> Void) -> Void {
        return { closure in
            koala_hookMember(self.object, member, self.injectBefore, { object, _ in
                closure(object as! Type)
            })
        }
    }
    
    public subscript(dynamicMember member: String) -> (@escaping (Type, Invocation<Location>) -> Void) -> Void {
        return { closure in
            koala_hookMember(self.object, member, self.injectBefore, { object, invocation in
                closure(object as! Type, Invocation(invocation: invocation))
            })
        }
    }

}
