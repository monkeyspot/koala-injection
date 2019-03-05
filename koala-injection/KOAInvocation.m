//
//  KOAInvocation.m
//  KoalaInjection
//
//  Created by Oliver Letterer on 05.03.19.
//  Copyright © 2019 Oliver Letterer. All rights reserved.
//

#import "KOAInvocation.h"

@interface KOAInvocation ()

@property (nonatomic, readonly) NSInvocation *invocation;

@end

@implementation KOAInvocation

- (instancetype)initWithInvocation:(NSInvocation *)invocation
{
    if (self = [super init]) {
        _invocation = invocation;
    }
    return self;
}

- (void)getArgument:(void *)argument atIndex:(NSInteger)index
{
    [self.invocation retainArguments];
    [self.invocation getArgument:argument atIndex:index];
}

- (void)setArgument:(void *)argument atIndex:(NSInteger)index
{
    [self.invocation retainArguments];
    [self.invocation setArgument:argument atIndex:index];
}

- (void)getReturnValue:(void *)returnValue
{
    [self.invocation retainArguments];
    
    if (![@(self.invocation.methodSignature.methodReturnType) isEqualToString:@"v"]) {
        [self.invocation getReturnValue:returnValue];
    }
}

- (void)setReturnValue:(void *)returnValue
{
    [self.invocation retainArguments];
    
    if (![@(self.invocation.methodSignature.methodReturnType) isEqualToString:@"v"]) {
        [self.invocation setReturnValue:returnValue];
    }
}

@end
