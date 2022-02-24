//
//  UIViewController+TDKeyboardHelp.m
//  FloryDay
//
//  Created by KOTU on 12/9/17.
//  Copyright © 2017年 FloryDay. All rights reserved.
//

#import "UIViewController+KTKeyboard.h"
#import <objc/runtime.h>

static const void *kKeyboardAnimationDuration = &kKeyboardAnimationDuration;
static const void *kKeyboardHeight = &kKeyboardHeight;
static const void *kIsKeyboardShow = &kIsKeyboardShow;
static const void *kKeyboardWillShow = &kKeyboardWillShow;
static const void *kKeyboardShowAnimation = &kKeyboardShowAnimation;
static const void *kKeyboardDidShow = &kKeyboardDidShow;
static const void *kIsKeyboardHide = &kIsKeyboardHide;
static const void *kKeyboardWillHide = &kKeyboardWillHide;
static const void *kKeyboardHideAnimation = &kKeyboardHideAnimation;
static const void *kKeyboardDidHide = &kKeyboardDidHide;
static const void *kTextFieldTextDidChange = &kTextFieldTextDidChange;

@implementation UIViewController (KTKeyboard)

#pragma mark - rewrite property
- (void)setKt_keyboardAnimationDuration:(CGFloat)keyboardAnimationDuration {
	objc_setAssociatedObject(self, kKeyboardAnimationDuration, @(keyboardAnimationDuration), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)kt_keyboardAnimationDuration {
	NSNumber *number = objc_getAssociatedObject(self, kKeyboardAnimationDuration);
	return [number floatValue];
}

- (void)setKt_keyboardHeight:(CGFloat)keyboardHeight {
	objc_setAssociatedObject(self, kKeyboardHeight, @(keyboardHeight), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)kt_keyboardHeight {
	NSNumber *number = objc_getAssociatedObject(self, kKeyboardHeight);
	return [number floatValue];
}

- (void)setKt_isKeyboardShow:(BOOL)isKeyboardShow {
	objc_setAssociatedObject(self, kIsKeyboardShow, @(isKeyboardShow), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)kt_isKeyboardShow {
	NSNumber *number = objc_getAssociatedObject(self, kIsKeyboardShow);
	return [number boolValue];
}

- (void)setKt_keyboardWillShow:(KeyboardManageKeyboardShowAndHide)keyboardWillShow {
	objc_setAssociatedObject(self, kKeyboardWillShow, keyboardWillShow, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (KeyboardManageKeyboardShowAndHide)kt_keyboardWillShow {
	return objc_getAssociatedObject(self, kKeyboardWillShow);
}

- (void)setKt_keyboardShowAnimation:(KeyboardManageKeyboardShowAndHide)keyboardShowAnimation {
	objc_setAssociatedObject(self, kKeyboardShowAnimation, keyboardShowAnimation, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (KeyboardManageKeyboardShowAndHide)kt_keyboardShowAnimation {
	return objc_getAssociatedObject(self, kKeyboardShowAnimation);
}

- (void)setKt_keyboardDidShow:(KeyboardManageKeyboardShowAndHide)keyboardDidShow {
	objc_setAssociatedObject(self, kKeyboardDidShow, keyboardDidShow, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (KeyboardManageKeyboardShowAndHide)kt_keyboardDidShow {
	return objc_getAssociatedObject(self, kKeyboardDidShow);
}

- (void)setIsKeyboardHide:(BOOL)isKeyboardHide {
	objc_setAssociatedObject(self, kIsKeyboardHide, @(isKeyboardHide), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)isKeyboardHide {
	NSNumber *number = objc_getAssociatedObject(self, kIsKeyboardHide);
	return [number boolValue];
}

- (void)setKt_keyboardWillHide:(KeyboardManageKeyboardShowAndHide)keyboardWillHide {
	objc_setAssociatedObject(self, kKeyboardWillHide, keyboardWillHide, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (KeyboardManageKeyboardShowAndHide)kt_keyboardWillHide {
	return objc_getAssociatedObject(self, kKeyboardWillHide);
}

- (void)setKt_keyboardHideAnimation:(KeyboardManageKeyboardShowAndHide)keyboardHideAnimation {
	objc_setAssociatedObject(self, kKeyboardHideAnimation, keyboardHideAnimation, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (KeyboardManageKeyboardShowAndHide)kt_keyboardHideAnimation {
	return objc_getAssociatedObject(self, kKeyboardHideAnimation);
}

- (void)setKt_keyboardDidHide:(KeyboardManageKeyboardShowAndHide)keyboardDidHide {
	objc_setAssociatedObject(self, kKeyboardDidHide, keyboardDidHide, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (KeyboardManageKeyboardShowAndHide)kt_keyboardDidHide {
	return objc_getAssociatedObject(self, kKeyboardDidHide);
}

- (void)setKt_textFieldTextDidChange:(KeyboardManageTextFieldTextDidChange)textFieldTextDidChange {
	objc_setAssociatedObject(self, kTextFieldTextDidChange, textFieldTextDidChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (KeyboardManageTextFieldTextDidChange)kt_textFieldTextDidChange {
	return objc_getAssociatedObject(self, kTextFieldTextDidChange);
}

#pragma mark - setup
- (void)kt_configKeyboard {
	self.kt_isKeyboardShow = NO;
	self.kt_keyboardWillShow = ^{};
	self.kt_keyboardShowAnimation = ^{};
	self.kt_keyboardDidShow = ^{};
	
	self.isKeyboardHide = YES;
	self.kt_keyboardWillHide = ^{};
	self.kt_keyboardHideAnimation = ^{};
	self.kt_keyboardDidHide = ^{};
	
	self.kt_textFieldTextDidChange = ^(UITextField *textField) {};
}

#pragma mark - Keyboard Notification Manager
- (void)kt_addKeyboardNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kt_keyboardWillShowWithNotification:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kt_keyboardDidShowWithNotification:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kt_keyboardWillHideWithNotification:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kt_keyboardDidHideWithNotification:) name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kt_textFieldTextDidChangeWithNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)kt_removeKeyboardNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Keyboard Notification Handle
- (void)kt_keyboardWillShowWithNotification:(NSNotification *)notification {
    void(^block)(void) = ^ {
        NSNumber * animationDuration = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
        self.kt_keyboardAnimationDuration = animationDuration.doubleValue;
        NSValue * frameBegin = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
        self.kt_keyboardHeight = frameBegin.CGRectValue.size.height;
        if (self.kt_keyboardWillShow) {
            self.kt_keyboardWillShow();
        }
        self.isKeyboardHide = NO;
        self.kt_isKeyboardShow = YES;
        [UIView animateWithDuration:self.kt_keyboardAnimationDuration animations:self.kt_keyboardShowAnimation];
    };
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

- (void)kt_keyboardDidShowWithNotification:(NSNotification *)notification {
    void(^block)(void) = ^ {
        if (self.kt_keyboardDidShow) {
            self.kt_keyboardDidShow();
        }
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

- (void)kt_keyboardWillHideWithNotification:(NSNotification *)notification {
    void(^block)(void) = ^ {
        NSNumber * animationDuration = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
        self.kt_keyboardAnimationDuration = animationDuration.doubleValue;
        self.kt_keyboardHeight = 0;
        if (self.kt_keyboardWillHide) {
            self.kt_keyboardWillHide();
        }
        self.kt_isKeyboardShow = NO;
        self.isKeyboardHide = YES;
        [UIView animateWithDuration:self.kt_keyboardAnimationDuration animations:self.kt_keyboardHideAnimation];
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

- (void)kt_keyboardDidHideWithNotification:(NSNotification *)notification {
    void(^block)(void) = ^ {
        if (self.kt_keyboardDidHide) {
            self.kt_keyboardDidHide();
        }
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

- (void)kt_textFieldTextDidChangeWithNotification:(NSNotification *)notification {
    void(^block)(void) = ^ {
        if (self.kt_textFieldTextDidChange) {
            self.kt_textFieldTextDidChange(notification.object);
        }
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

@end
