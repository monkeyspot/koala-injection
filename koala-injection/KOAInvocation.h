//
//  KOAInvocation.h
//  KoalaInjection
//
//  Created by Oliver Letterer on 05.03.19.
//  Copyright © 2019 Oliver Letterer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_subclassing_restricted))
@interface KOAInvocation : NSObject

- (instancetype)init NS_DESIGNATED_INITIALIZER NS_UNAVAILABLE;
- (instancetype)initWithInvocation:(NSInvocation *)invocation NS_DESIGNATED_INITIALIZER;

- (void)getArgument:(void *)argument atIndex:(NSInteger)index;
- (void)setArgument:(void *)argument atIndex:(NSInteger)index;

- (void)getReturnValue:(void *)returnValue;
- (void)setReturnValue:(void *)returnValue;

@end

NS_ASSUME_NONNULL_END
