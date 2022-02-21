//
//  UIGestureRecognizer+KTHelp.m
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/10/13.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIGestureRecognizer+KTHelp.h"
#import "YYCategoriesMacro.h"
#import <objc/runtime.h>

static const int block_key;

@interface _KTUIGestureRecognizerBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _KTUIGestureRecognizerBlockTarget

- (id)initWithBlock:(void (^)(id sender))block{
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender {
    if (_block) _block(sender);
}

@end




@implementation UIGestureRecognizer (KTHelp)

- (instancetype)initWithActionBlock:(void (^)(id sender))block {
    self = [self init];
    [self kt_addActionBlock:block];
    return self;
}

- (void)kt_addActionBlock:(void (^)(id sender))block {
    _KTUIGestureRecognizerBlockTarget *target = [[_KTUIGestureRecognizerBlockTarget alloc] initWithBlock:block];
    [self addTarget:target action:@selector(invoke:)];
    NSMutableArray *targets = [self _yy_allUIGestureRecognizerBlockTargets];
    [targets addObject:target];
}

- (void)kt_removeAllActionBlocks{
    NSMutableArray *targets = [self _yy_allUIGestureRecognizerBlockTargets];
    [targets enumerateObjectsUsingBlock:^(id target, NSUInteger idx, BOOL *stop) {
        [self removeTarget:target action:@selector(invoke:)];
    }];
    [targets removeAllObjects];
}

- (NSMutableArray *)_yy_allUIGestureRecognizerBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
