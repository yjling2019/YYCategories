//
//  NSObject+KVC.m
//  VVRootLib
//
//  Created by KOTU on 2019/8/9.
//  Copyright © 2019 com.lebby.www. All rights reserved.
//

#import "NSObject+KTHelpForKVC.h"

@implementation NSObject (KTHelpForKVC)

- (BOOL)kt_copyValueToInstance:(nonnull __kindof NSObject *)obj
					byProtocol:(nonnull NSString *)protocolStr {
    return [self kt_copyValueToInstance:obj byProtocol:protocolStr whiteList:nil blackList:nil];
}

- (BOOL)kt_copyValueToInstance:(nonnull __kindof NSObject *)obj
					byProtocol:(nonnull NSString *)protocolStr
					 whiteList:(nonnull NSArray<NSString *> *)whiteList {
    return [self kt_copyValueToInstance:obj byProtocol:protocolStr whiteList:whiteList blackList:nil];
}

- (BOOL)kt_copyValueToInstance:(nonnull __kindof NSObject *)obj
					byProtocol:(nonnull NSString *)protocolStr
					 blackList:(nonnull NSArray<NSString *> *)blackList {
    return [self kt_copyValueToInstance:obj byProtocol:protocolStr whiteList:nil blackList:blackList];
}

- (BOOL)kt_copyValueToInstance:(nonnull __kindof NSObject *)obj
			  bySingleProtocol:(nonnull NSString *)protocolStr {
    return [self kt_copyValueToInstance:obj bySingleProtocolStr:protocolStr whiteList:nil blackList:nil];
}

- (BOOL)kt_copyValueToInstance:(nonnull __kindof NSObject *)obj
			  bySingleProtocol:(nonnull NSString *)protocolStr
					 whiteList:(nonnull NSArray<NSString *> *)whiteList {
    return [self kt_copyValueToInstance:obj bySingleProtocolStr:protocolStr whiteList:whiteList blackList:nil];
}

- (BOOL)kt_copyValueToInstance:(nonnull __kindof NSObject *)obj
			  bySingleProtocol:(nonnull NSString *)protocolStr
					 blackList:(nonnull NSArray<NSString *> *)blackList {
    return [self kt_copyValueToInstance:obj bySingleProtocolStr:protocolStr whiteList:nil blackList:blackList];
}

#pragma mark - - private method - -
__unused static void cleanUpBlock(__strong void(^*block)(void)) {
    (*block)();
}

- (BOOL)kt_copyValueToInstance:(nonnull __kindof NSObject *)obj
					byProtocol:(nonnull NSString *)protocolStr
					 whiteList:(nullable NSArray<NSString *> *)whiteList
					 blackList:(nullable NSArray<NSString *> *)blackList {
    if (!obj || !protocolStr) {
#if DEBUG
        NSAssert(obj, @"obj can't be nil");
        NSAssert(protocolStr, @"protocolStr can't be nil");
#endif
        return NO;
    }
    
    if ([protocolStr hasPrefix:@"NS"] || [protocolStr hasPrefix:@"UI"]) {
#if DEBUG
        NSAssert(![protocolStr hasPrefix:@"NS"], @"make sure [protocolStr hasPrefix:@\"NS\"] be NO");
        NSAssert(![protocolStr hasPrefix:@"UI"], @"make sure [protocolStr hasPrefix:@\"UI\"] be NO");
#endif
        return NO;
    }
    
    Protocol *targetProtocol = objc_getProtocol(protocolStr.UTF8String);
    if (!targetProtocol) {
#if DEBUG
        NSAssert(NO, @"targetProtocol is not exist");
#endif
        return NO;
    }
    
    if (![obj conformsToProtocol:targetProtocol]) {
        return NO;
    }
    
    unsigned int protocolListCount = 0;
    __unsafe_unretained Protocol **protocolList = protocol_copyProtocolList(targetProtocol, &protocolListCount);
    __strong void(^attribute_cleanup_block)(void) __attribute__((cleanup(cleanUpBlock), unused)) = ^{
        if (protocolList) {
            free(protocolList);
        }
    };
    if (protocolListCount > 0) {
        for (int i = 0; i < protocolListCount; i++) {
            Protocol *protocol = protocolList[i];
            const char *name = protocol_getName(protocol);
            NSString *protocolName = [NSString stringWithUTF8String:name];
            if ([protocolName hasPrefix:@"NS"] || [protocolName hasPrefix:@"UI"]) {
                continue;
            }
            BOOL result = [self kt_copyValueToInstance:obj bySingleProtocol:protocol whiteList:whiteList blackList:blackList];
            if (!result) {
                return result;
            }
        }
        return [self kt_copyValueToInstance:obj bySingleProtocol:targetProtocol whiteList:whiteList blackList:blackList];
    }
    return [self kt_copyValueToInstance:obj bySingleProtocol:targetProtocol whiteList:whiteList blackList:blackList];
}

- (BOOL)kt_copyValueToInstance:(nonnull __kindof NSObject *)obj
		   bySingleProtocolStr:(nonnull NSString *)protocolStr
					 whiteList:(nullable NSArray<NSString *> *)whiteList
					 blackList:(nullable NSArray<NSString *> *)blackList {
    if (!obj || !protocolStr) {
#if DEBUG
        NSAssert(obj, @"obj can't be nil");
        NSAssert(protocolStr, @"protocolStr can't be nil");
#endif
        return NO;
    }
    if ([protocolStr hasPrefix:@"NS"] || [protocolStr hasPrefix:@"UI"]) {
#if DEBUG
        NSAssert(![protocolStr hasPrefix:@"NS"], @"make sure [protocolStr hasPrefix:@\"NS\"] be NO");
        NSAssert(![protocolStr hasPrefix:@"UI"], @"make sure [protocolStr hasPrefix:@\"UI\"] be NO");
#endif
        return NO;
    }
    Protocol *protocol = NSProtocolFromString(protocolStr);
    return [self kt_copyValueToInstance:obj bySingleProtocol:protocol whiteList:whiteList blackList:blackList];
}

- (BOOL)kt_copyValueToInstance:(nonnull __kindof NSObject *)obj
			  bySingleProtocol:(nonnull Protocol *)protocol
					 whiteList:(nullable NSArray<NSString *> *)whiteList
					 blackList:(nullable NSArray<NSString *> *)blackList {
    if (!protocol) {
#if DEBUG
        NSAssert(NO, @"protocol can't be nil");
#endif
        return NO;
    }
    
    if (![self conformsToProtocol:protocol]) {
#if DEBUG
        NSAssert(NO, @"make sure [self conformsToProtocol:protocol] be YES");
#endif
        return NO;
    }
    
    if (![obj conformsToProtocol:protocol]) {
        return NO;
    }
    
    /// 获取协议中的属性
    unsigned int outCount;
    objc_property_t *propertyList;
//    if (@available(iOS 10.0, *)) {
//        //只有iOS 10 以上才支持获取optional属性
//        propertyList = protocol_copyPropertyList2(protocol, &outCount, NO, YES);
//    } else {
    //  只能获取required的属性
        propertyList = protocol_copyPropertyList(protocol, &outCount);
//    }
        
    NSMutableSet <NSString *> *propertyNamesFromProtocol = NSMutableSet.set;
    for (unsigned int i = 0; i < outCount; i++) {
        objc_property_t property = propertyList[i];
        const char *propertyName = property_getName(property);
        NSString *keyName = @(propertyName);
        [propertyNamesFromProtocol addObject:keyName];
    }
    if (propertyList) {
        free(propertyList);
    }
    
    /// 赋值
    for (NSString *targetPropertyName in propertyNamesFromProtocol) {
        SEL getSel = NSSelectorFromString(targetPropertyName);
        if (![self respondsToSelector:getSel]) {
#if DEBUG
            NSAssert(NO, @"make sure [self respondsToSelector:propertySel] be YES");
#endif
            return NO;
        }
        NSString *name = targetPropertyName.copy;
        if ([targetPropertyName hasPrefix:@"_"]) {
            name = [name substringFromIndex:1];
        }
        if (whiteList && ![whiteList containsObject:name]) {
            continue;
        }
        if (blackList && [blackList containsObject:name]) {
            continue;
        }
        NSString *selectorName = nil;
        if (name.length > 1) {
            selectorName = [NSString stringWithFormat:@"set%@%@:",[name substringWithRange:NSMakeRange(0, 1)].uppercaseString,[name substringFromIndex:1]];
        } else if (name.length == 1) {
            selectorName = [NSString stringWithFormat:@"set%@:",[name substringWithRange:NSMakeRange(0, 1)].uppercaseString];
        } else {
            continue;
        }
        
        SEL setSel = NSSelectorFromString(selectorName);
        if (![obj respondsToSelector:setSel]) {
#if DEBUG
            NSAssert(NO, @"make sure [obj respondsToSelector:setSel] be YES");
#endif
            return NO;
        }
        id value = [self valueForKey:targetPropertyName];
        if (value) {
            [obj setValue:value forKey:targetPropertyName];
        } else {
            IMP imp = [obj methodForSelector:setSel];
            void (*func)(id, SEL,id) = (void *)imp;
            func(obj, setSel,nil);
        }
    }
    return YES;
}

#pragma mark - - crash fix - -
- (void)setNilValueForKey:(NSString *)key {
    NSString *selectorName = nil;
    if (key.length > 1) {
        selectorName = [NSString stringWithFormat:@"set%@%@:",[key substringWithRange:NSMakeRange(0, 1)].uppercaseString,[key substringFromIndex:1]];
    } else if (key.length == 1) {
        selectorName = [NSString stringWithFormat:@"set%@:",[key substringWithRange:NSMakeRange(0, 1)].uppercaseString];
    }
    SEL setSelector = NSSelectorFromString(selectorName);
    if (selectorName && [self respondsToSelector:setSelector]) {
        IMP imp = [self methodForSelector:setSelector];
        void (*func)(id, SEL,id) = (void *)imp;
        func(self, setSelector,nil);
    } else {
#if DEBUG
        NSString *desc = [NSString stringWithFormat:@"value can't be nil for %@",key];
        NSAssert(NO, desc);
#endif
    }
}

- (nullable id)valueForUndefinedKey:(NSString *)key {
#if DEBUG
    NSString *desc = [NSString stringWithFormat:@"valueForUndefinedKey:%@",key];
    NSAssert(NO, desc);
#endif
    return nil;
}

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key {
#if DEBUG
    NSString *desc = [NSString stringWithFormat:@"setValue:forUndefinedKey:%@",key];
    NSAssert(NO, desc);
#endif
}

@end
