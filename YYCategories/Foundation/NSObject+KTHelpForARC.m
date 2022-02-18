//
//  NSObject+KTHelpForARC.m
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/12/15.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSObject+KTHelpForARC.h"

#if __has_feature(objc_arc)
#error This file must be compiled without ARC. Specify the -fno-objc-arc flag to this file.
#endif

@implementation NSObject (KTHelpForARC)

- (instancetype)kt_arcDebugRetain {
    return [self retain];
}

- (oneway void)kt_arcDebugRelease {
    [self release];
}

- (instancetype)kt_arcDebugAutorelease {
    return [self autorelease];
}

- (NSUInteger)kt_arcDebugRetainCount {
    return [self retainCount];
}

@end
