//
//  runtime.m
//  KoalaInjection
//
//  Created by Oliver Letterer on 03.03.19.
//  Copyright © 2019 Oliver Letterer. All rights reserved.
//

#import "runtime.h"
#import "KOAInvocation.h"
#import <objc/message.h>

static void * memberLookupKey = &memberLookupKey;

Method koala_lookupMember(Class klass, NSString *member)
{
    unsigned int count = 0;
    Method *methods = class_copyMethodList(klass, &count);

    for (unsigned int i = 0; i < count; i++) {
        Method method = methods[i];
        NSString *memberName = [NSStringFromSelector(method_getName(method)) stringByReplacingOccurrencesOfString:@":" withString:@""]; // no support for selectors of type xxx::: 🌬

        if ([memberName isEqualToString:member]) {
            free(methods);
            return method;
        }
    }

    free(methods);

    Class superKlass = class_getSuperclass(klass);
    return superKlass != Nil ? koala_lookupMember(superKlass, member) : NULL;
}

void koala_hookMember(id object, NSString *member, BOOL before, void(^block)(id object, KOAInvocation *invocation))
{
    if ([object class] != object_getClass(object)) {
        assert([@(class_getName(object_getClass(object))) hasPrefix:@"KoalaInjection_"]); // Don't break KVO or CoreData
    }
    
    NSMutableDictionary<NSString *, NSMutableArray *> *memberLookup = objc_getAssociatedObject(object, memberLookupKey) ?: [NSMutableDictionary dictionary];
    objc_setAssociatedObject(object, memberLookupKey, memberLookup, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSString *newClass = [NSString stringWithFormat:@"KoalaInjection_%@_%@", [object class], NSUUID.UUID.UUIDString];
    Class koalaClass = objc_allocateClassPair(object_getClass(object), newClass.UTF8String, 0);

    Method method = koala_lookupMember([object class], member);
    assert(method != NULL);

    SEL koalaSelector = NSSelectorFromString([NSString stringWithFormat:@"_koala_%@_%@", NSUUID.UUID.UUIDString, NSStringFromSelector(method_getName(method))]);
    class_addMethod(koalaClass, koalaSelector, method_getImplementation(method), method_getTypeEncoding(method));
    class_addMethod(koalaClass, method_getName(method), (IMP)_objc_msgForward, method_getTypeEncoding(method));

    Class(^class)(id object) = ^(id object) {
        Class result = object_getClass(object);
        while ([@(class_getName(result)) hasPrefix:@"KoalaInjection_"]) {
            result = class_getSuperclass(result);
        }
        return result;
    };
    class_addMethod(koalaClass, @selector(class), imp_implementationWithBlock(class), method_getTypeEncoding(class_getInstanceMethod(NSObject.class, @selector(class))));

    NSMethodSignature *(^methodSignatureForSelector)(id object, SEL selector) = ^NSMethodSignature *(id object, SEL selector) {
        if (selector == method_getName(method)) {
            return [NSMethodSignature signatureWithObjCTypes:method_getTypeEncoding(method)];
        }

        struct objc_super super = {
            .receiver = object,
            .super_class = class_getSuperclass(koalaClass)
        };
        return ((NSMethodSignature *(*)(struct objc_super *, SEL, SEL))objc_msgSendSuper)(&super, @selector(methodSignatureForSelector:), selector);
    };
    class_addMethod(koalaClass, @selector(methodSignatureForSelector:), imp_implementationWithBlock(methodSignatureForSelector), method_getTypeEncoding(class_getInstanceMethod(NSObject.class, @selector(methodSignatureForSelector:))));

    void(^forwardInvocation)(__unsafe_unretained id object, NSInvocation *invocation) = ^(__unsafe_unretained id object, NSInvocation *invocation) { // dealloc support
        if (invocation.selector == method_getName(method)) {
            if ([member isEqualToString:@"dealloc"] || before) {
                block(object, [[KOAInvocation alloc] initWithInvocation:invocation]);
            }
            
            NSArray *subklasses = memberLookup[member];
            Class nextSuperklass = [subklasses indexOfObject:koalaClass] > 0 ? [subklasses objectAtIndex:[subklasses indexOfObject:koalaClass] - 1] : Nil;
            
            if (nextSuperklass != Nil) { // support for multiple koala implementations
                IMP super = class_getMethodImplementation(nextSuperklass, @selector(forwardInvocation:));
                ((void(*)(id, SEL, NSInvocation *))super)(object, @selector(forwardInvocation:), invocation);
            }

            if ([subklasses indexOfObject:koalaClass] == 0) {
                invocation.selector = koalaSelector;
                [invocation invoke];
            }

            if (![member isEqualToString:@"dealloc"] && !before) {
                block(object, [[KOAInvocation alloc] initWithInvocation:invocation]);
            }

            return;
        }

        struct objc_super super = {
            .receiver = object,
            .super_class = class_getSuperclass(koalaClass)
        };
        ((void(*)(struct objc_super *, SEL, NSInvocation *))objc_msgSendSuper)(&super, @selector(forwardInvocation:), invocation);
    };
    class_addMethod(koalaClass, @selector(forwardInvocation:), imp_implementationWithBlock(forwardInvocation), method_getTypeEncoding(class_getInstanceMethod(NSObject.class, @selector(forwardInvocation:))));

    objc_registerClassPair(koalaClass);
    object_setClass(object, koalaClass);
    
    NSMutableArray *subklasses = memberLookup[member] ?: [NSMutableArray array];
    memberLookup[member] = subklasses;
    
    [subklasses addObject:koalaClass];
}
