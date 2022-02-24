//
//  NSObject+KVC.h
//  VVRootLib
//
//  Created by KOTU on 2019/8/9.
//  Copyright © 2019 com.lebby.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KTHelpForKVC)

 /// 根据协议的在对象间传递value,如果该协议遵守另外的协议，也会对该协议遵守的其他协议进行传值操作
 /// 如果协议名有NS，UI前缀对自动跳过，不进行赋值操作
 /// BOOL 返回值代表 是否传递成功,
 /// 目前只支持对@required标记的属性机型赋值
 /// @param obj 被赋值对象
 ///@param protocolStr 协议
- (BOOL)kt_copyValueToInstance:(nonnull __kindof NSObject *)obj
					byProtocol:(nonnull NSString *)protocolStr;

/// 根据协议的在对象间传递value,如果该协议遵守另外的协议，也会对该协议遵守的其他协议进行传值操作
/// 目前只支持对@required标记的属性机型赋值
/// PS：如果存在白名单，只对白名单的属性进行赋值，白名单的属性必须遵守协议
/// @param obj 被赋值的对象
/// @param protocolStr 协议名
/// @param whiteList 白名单
- (BOOL)kt_copyValueToInstance:(nonnull __kindof NSObject *)obj
					byProtocol:(nonnull NSString *)protocolStr
					 whiteList:(nonnull NSArray<NSString *> *)whiteList;

/// 根据协议的在对象间传递value,如果该协议遵守另外的协议，也会对该协议遵守的其他协议进行传值操作
/// 目前只支持对@required标记的属性机型赋值
/// PS：如果存在黑名单，不对黑名单中的属性进行赋值操作
/// @param obj 被赋值的对象
/// @param protocolStr 协议名
/// @param blackList 黑名单
- (BOOL)kt_copyValueToInstance:(nonnull __kindof NSObject *)obj
					byProtocol:(nonnull NSString *)protocolStr
					 blackList:(nonnull NSArray<NSString *> *)blackList;

/// 根据协议的在对象间传递value，只会对当前协议的属性进行赋值，该协议遵守的其他协议里的属性不进行赋值操作
/// 如果协议名有NS，UI，不进行赋值操作 返回NO
/// BOOL 返回值代表 是否传递成功,
/// 目前只支持对@required标记的属性机型赋值
/// @param obj 被赋值对象
/// @param protocolStr 协议
- (BOOL)kt_copyValueToInstance:(nonnull __kindof NSObject *)obj
			  bySingleProtocol:(nonnull NSString *)protocolStr;

/// 根据协议的在对象间传递value，只会对当前协议的属性进行赋值，该协议遵守的其他协议里的属性不进行赋值操作
/// 如果协议名有NS，UI，不进行赋值操作 返回NO
/// BOOL 返回值代表 是否传递成功,
/// 目前只支持对@required标记的属性机型赋值
/// PS：如果存在白名单，只对白名单的属性进行赋值，白名单的属性必须遵守协议
/// @param obj 被赋值对象
/// @param protocolStr 协议
/// @param whiteList 白名单
- (BOOL)kt_copyValueToInstance:(nonnull __kindof NSObject *)obj
			  bySingleProtocol:(nonnull NSString *)protocolStr
					 whiteList:(nonnull NSArray<NSString *> *)whiteList;

/// 根据协议的在对象间传递value，只会对当前协议的属性进行赋值，该协议遵守的其他协议里的属性不进行赋值操作
/// 如果协议名有NS，UI，不进行赋值操作 返回NO
/// BOOL 返回值代表 是否传递成功,
/// 目前只支持对@required标记的属性机型赋值
/// PS：如果存在黑名单，不对黑名单中的属性进行赋值操作
/// @param obj 被赋值对象
/// @param protocolStr 协议
/// @param blackList 黑名单
- (BOOL)kt_copyValueToInstance:(nonnull __kindof NSObject *)obj
			  bySingleProtocol:(nonnull NSString *)protocolStr
					 blackList:(nonnull NSArray<NSString *> *)blackList;


@end

NS_ASSUME_NONNULL_END
