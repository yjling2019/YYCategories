//
//  UIScrollView+KTHelp.m
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/4/5.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UIScrollView+KTHelp.h"
#import "YYCategoriesMacro.h"

@implementation UIScrollView (KTHelp)

- (void)kt_scrollToTop {
    [self kt_scrollToTopAnimated:YES];
}

- (void)kt_scrollToBottom {
    [self kt_scrollToBottomAnimated:YES];
}

- (void)kt_scrollToLeft {
    [self kt_scrollToLeftAnimated:YES];
}

- (void)kt_scrollToRight {
    [self kt_scrollToRightAnimated:YES];
}

- (void)kt_scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)kt_scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)kt_scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)kt_scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end
