//
//  runtime.h
//  KoalaInjection
//
//  Created by Oliver Letterer on 03.03.19.
//  Copyright © 2019 Oliver Letterer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@class KOAInvocation;

NS_ASSUME_NONNULL_BEGIN

_Nullable Method koala_lookupMember(Class klass, NSString *member);
void koala_hookMember(id object, NSString *member, BOOL before, void(^block)(id object, KOAInvocation *invocation));

NS_ASSUME_NONNULL_END
