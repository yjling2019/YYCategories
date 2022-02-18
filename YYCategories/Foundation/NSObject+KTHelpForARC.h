//
//  NSObject+KTHelpForARC.h
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/12/15.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

/**
 Debug method for NSObject when using ARC.
 */
@interface NSObject (KTHelpForARC)

/// Same as `retain`
- (instancetype)kt_arcDebugRetain;

/// Same as `release`
- (oneway void)kt_arcDebugRelease;

/// Same as `autorelease`
- (instancetype)kt_arcDebugAutorelease;

/// Same as `retainCount`
- (NSUInteger)kt_arcDebugRetainCount;

@end
