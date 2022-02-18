//
//  NSNotificationCenter+KTHelp.m
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/8/24.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSNotificationCenter+KTHelp.h"
#include <pthread.h>
#import <objc/runtime.h>

@implementation NSNotificationCenter (KTHelp)

- (void)kt_postNotificationOnMainThread:(NSNotification *)notification {
    if (pthread_main_np()) return [self postNotification:notification];
    [self kt_postNotificationOnMainThread:notification waitUntilDone:NO];
}

- (void)kt_postNotificationOnMainThread:(NSNotification *)notification waitUntilDone:(BOOL)wait {
    if (pthread_main_np()) return [self postNotification:notification];
    [[self class] performSelectorOnMainThread:@selector(_yy_postNotification:) withObject:notification waitUntilDone:wait];
}

- (void)kt_postNotificationOnMainThreadWithName:(NSString *)name object:(id)object {
    if (pthread_main_np()) return [self postNotificationName:name object:object userInfo:nil];
    [self kt_postNotificationOnMainThreadWithName:name object:object userInfo:nil waitUntilDone:NO];
}

- (void)kt_postNotificationOnMainThreadWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
    if (pthread_main_np()) return [self postNotificationName:name object:object userInfo:userInfo];
    [self kt_postNotificationOnMainThreadWithName:name object:object userInfo:userInfo waitUntilDone:NO];
}

- (void)kt_postNotificationOnMainThreadWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo waitUntilDone:(BOOL)wait {
    if (pthread_main_np()) return [self postNotificationName:name object:object userInfo:userInfo];
    NSMutableDictionary *info = [[NSMutableDictionary allocWithZone:nil] initWithCapacity:3];
    if (name) [info setObject:name forKey:@"name"];
    if (object) [info setObject:object forKey:@"object"];
    if (userInfo) [info setObject:userInfo forKey:@"userInfo"];
    [[self class] performSelectorOnMainThread:@selector(_yy_postNotificationName:) withObject:info waitUntilDone:wait];
}

+ (void)_yy_postNotification:(NSNotification *)notification {
    [[self defaultCenter] postNotification:notification];
}

+ (void)_yy_postNotificationName:(NSDictionary *)info {
    NSString *name = [info objectForKey:@"name"];
    id object = [info objectForKey:@"object"];
    NSDictionary *userInfo = [info objectForKey:@"userInfo"];
    
    [[self defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}

@end

#pragma mark - Fast Notification
typedef void(^KTFastNotificationBlock)(NSNotification *notification);

@interface KTFastNotificationProxy : NSObject
@property (nonatomic, copy) NSString *notificationName;
@property (nonatomic, copy) KTFastNotificationBlock block;
@end

@implementation KTFastNotificationProxy

- (instancetype)initWithName:(NSString *)name block:(KTFastNotificationBlock)block {
	self = [super init];
	if (self) {
		self.notificationName = name;
		self.block = block;
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(receivedNotifcation:)
													 name:_notificationName
												   object:nil];
	}
	return self;
}

- (void)receivedNotifcation:(NSNotification *)note {
	if (_block) {
		_block(note);
	}
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:_notificationName object:nil];
}

@end

static const void *kProxyList = &kProxyList;

@implementation NSObject (KTFastNotification)

- (NSMutableArray *)kt_notificationProxyList {
	NSMutableArray *list = objc_getAssociatedObject(self, kProxyList);
	if (!list) {
		list = [NSMutableArray array];
		objc_setAssociatedObject(self, kProxyList, list, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return list;
}

- (void)kt_observeNotificationForName:(NSString *)name
						   usingBlock:(KTFastNotificationBlock)block {
	KTFastNotificationProxy *proxy = [[KTFastNotificationProxy alloc] initWithName:name block:block];
	[[self kt_notificationProxyList] addObject:proxy];
}

- (void)kt_observeNotificationForNames:(NSArray<NSString *> *)names
							usingBlock:(KTFastNotificationBlock)block {
	for (NSString *name in names) {
		KTFastNotificationProxy *proxy = [[KTFastNotificationProxy alloc] initWithName:name block:block];
		[[self kt_notificationProxyList] addObject:proxy];
	}
}

- (void)kt_removeNotification:(NSString *)name {
	@synchronized (self) {
		NSMutableArray *originProxys = [self kt_notificationProxyList];
		NSMutableArray *prxoys = [NSMutableArray array];
		for (KTFastNotificationProxy *proxy in originProxys) {
			if (![proxy.notificationName isEqualToString:name]) {
				[prxoys addObject:proxy];
			}
		}
		if (originProxys.count > 0) {
			objc_setAssociatedObject(self, kProxyList, prxoys, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		}
	}
}

- (nullable NSArray<NSString *> *)kt_notificationNames {
	NSArray<KTFastNotificationProxy *> *proxys;
	@synchronized (self) {
		NSMutableArray *originProxys = [self kt_notificationProxyList];
		proxys = originProxys.copy;
	}
	if (proxys.count <= 0) {
		return nil;
	}
	NSMutableArray<NSString *> *proxyNames = NSMutableArray.new;
	for (KTFastNotificationProxy *proxy in proxys) {
		if (proxy.notificationName) {
			[proxyNames addObject:proxy.notificationName];
		}
	}
	return proxyNames;
}

@end
