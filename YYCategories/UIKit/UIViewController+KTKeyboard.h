//
//  UIViewController+TDKeyboardHelp.h
//  FloryDay
//
//  Created by KOTU on 12/9/17.
//  Copyright © 2017年 FloryDay. All rights reserved.
//

//使用方法
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self kt_configKeyboard];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self kt_addKeyboardNotifications];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self kt_removeKeyboardNotifications];
//}

#import <UIKit/UIKit.h>

//管理键盘显示和隐藏的回调Block的声明
typedef void (^KeyboardManageKeyboardShowAndHide) (void);
//管理TextField文本改变的回调Block的声明
typedef void (^KeyboardManageTextFieldTextDidChange) (UITextField * textField);

@interface UIViewController (KTKeyboard)

// 键盘动画周期
@property (nonatomic, assign) CGFloat kt_keyboardAnimationDuration;
// 键盘高度
@property (nonatomic, assign) CGFloat kt_keyboardHeight;

// 键盘是否显示
@property (nonatomic, assign) BOOL kt_isKeyboardShow;
/// 键盘即将显示的回调Block，该block已经在主线程执行
@property (nonatomic, copy) KeyboardManageKeyboardShowAndHide kt_keyboardWillShow;
/// 在该回调Block中，执行键盘显示时的相关动画，该block已经在主线程执行
@property (nonatomic, copy) KeyboardManageKeyboardShowAndHide kt_keyboardShowAnimation;
/// 键盘已经显示的回调Block，该block已经在主线程执行
@property (nonatomic, copy) KeyboardManageKeyboardShowAndHide kt_keyboardDidShow;
/// 键盘是否隐藏
@property (nonatomic, assign) BOOL isKeyboardHide;
/// 键盘即将隐藏的回调Block，该block已经在主线程执行
@property (nonatomic, copy) KeyboardManageKeyboardShowAndHide kt_keyboardWillHide;
/// 在该回调Block中，执行键盘隐藏时的相关动画，该block已经在主线程执行
@property (nonatomic, copy) KeyboardManageKeyboardShowAndHide kt_keyboardHideAnimation;
/// 键盘已经隐藏的回调Block，该block已经在主线程执行
@property (nonatomic, copy) KeyboardManageKeyboardShowAndHide kt_keyboardDidHide;

// TextField的文本改变的回调Block
/// - textField：文本改变的TextField，该block已经在主线程执行
@property (nonatomic, copy) KeyboardManageTextFieldTextDidChange kt_textFieldTextDidChange;

/**
 初始化配置
 */
- (void)kt_configKeyboard;

/**
 监听键盘事件
 */
- (void)kt_addKeyboardNotifications;

/**
 移除键盘监听事件
 */
- (void)kt_removeKeyboardNotifications;

@end

