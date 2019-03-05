//
//  KOAInvocation.swift
//  KoalaInjection
//
//  Created by Oliver Letterer on 05.03.19.
//  Copyright © 2019 Oliver Letterer. All rights reserved.
//

import Foundation

public class Invocation<Location: InjectionLocation> {
    private let invocation: KOAInvocation

    init(invocation: KOAInvocation) {
        self.invocation = invocation
    }

    public class ArgumentProjection<T, Location: InjectionLocation> {
        private let invocation: KOAInvocation

        init(invocation: KOAInvocation) {
            self.invocation = invocation
        }
    }

    public func arguments<T>() -> ArgumentProjection<T, Location> {
        return ArgumentProjection<T, Location>(invocation: self.invocation)
    }
}

public extension Invocation.ArgumentProjection where T: AnyObject, Location: After {
    public subscript(index: Int) -> T {
        get {
            var value: Unmanaged<T>? = nil
            self.invocation.getArgument(&value, at: index + 2)
            return value!.takeUnretainedValue()
        }
        @available(*, deprecated: 1.0, message: "Setting arguments is not supported after instance implementations, use koala.before instead") set(newValue) {

        }
    }
}

public extension Invocation.ArgumentProjection where T: AnyObject, Location: Before {
    public subscript(index: Int) -> T {
        get {
            var value: Unmanaged<T>? = nil
            self.invocation.getArgument(&value, at: index + 2)
            return value!.takeUnretainedValue()
        }
        set(newValue) {
            var value: Unmanaged<T>? = Unmanaged.passUnretained(newValue)
            self.invocation.setArgument(&value, at: index + 2)
        }
    }
}

public extension Invocation.ArgumentProjection where T: Any, Location: After {
    public subscript(index: Int) -> T {
        get {
            var value: T? = nil
            self.invocation.getArgument(&value, at: index + 2)
            return value!
        }
        @available(*, deprecated: 1.0, message: "Setting arguments is not supported after instance implementations, use koala.before instead") set(newValue) {

        }
    }
}

public extension Invocation.ArgumentProjection where T: Any, Location: Before {
    public subscript(index: Int) -> T {
        get {
            var value: T? = nil
            self.invocation.getArgument(&value, at: index + 2)
            return value!
        }
        set(newValue) {
            var value: T? = newValue
            self.invocation.setArgument(&value, at: index + 2)
        }
    }
}
