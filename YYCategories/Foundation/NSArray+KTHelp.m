//
//  NSArray+KTHelp.m
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/4/4.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSArray+KTHelp.h"
#import "NSData+YYAdd.h"

@implementation NSArray (KTHelp)

+ (NSArray *)kt_arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([array isKindOfClass:[NSArray class]]) return array;
    return nil;
}

+ (NSArray *)kt_arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self kt_arrayWithPlistData:data];
}

- (NSData *)kt_plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

- (NSString *)kt_plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return xmlData.utf8String;
    return nil;
}

- (id)kt_randomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

- (id)kt_objectOrNilAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}

- (nullable id)kt_objectAtIndex:(NSInteger)index verifyClass:(nullable Class)theClass {
	id object = [self kt_objectOrNilAtIndex:index];
	if (!theClass) {
		return object;
	}
	return [object isKindOfClass:theClass] ? object : nil;
}

- (nullable NSString *)kt_stringAtIndex:(NSInteger)index {
	id value = [self kt_objectOrNilAtIndex:index];
	if ([value isKindOfClass:[NSString class]]) {
		return (NSString *)value;
	}
	if ([value isKindOfClass:[NSNumber class]]) {
		return [value stringValue];
	}
	return nil;
}

- (nullable NSNumber *)kt_numberAtIndex:(NSInteger)index {
	id value = [self kt_objectOrNilAtIndex:index];
	if ([value isKindOfClass:[NSNumber class]]) {
		return (NSNumber *)value;
	}
	if ([value isKindOfClass:[NSString class]]) {
		NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];
		return [f numberFromString:(NSString *)value];
	}
	return nil;
}

- (nullable NSDecimalNumber *)kt_decimalNumberAtIndex:(NSInteger)index {
	id value = [self kt_objectOrNilAtIndex:index];
	if ([value isKindOfClass:[NSDecimalNumber class]]) {
		return value;
	}
	if ([value isKindOfClass:[NSNumber class]]) {
		NSNumber * number = (NSNumber*)value;
		return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
	}
	if ([value isKindOfClass:[NSString class]]) {
		NSString * str = (NSString*)value;
		return [str isEqualToString:@""] ? nil : [NSDecimalNumber decimalNumberWithString:str];
	}
	return nil;
}

- (nullable NSArray *)kt_arrayAtIndex:(NSInteger)index {
	id value = [self kt_objectOrNilAtIndex:index];
	if ([value isKindOfClass:[NSArray class]]) {
		return value;
	}
	return nil;
}

- (nullable NSDictionary *)kt_dictionaryAtIndex:(NSInteger)index {
	id value = [self kt_objectOrNilAtIndex:index];
	if ([value isKindOfClass:[NSDictionary class]]) {
		return value;
	}
	return nil;
}

- (NSInteger)kt_integerAtIndex:(NSInteger)index {
	id value = [self kt_objectOrNilAtIndex:index];
	if ([value isKindOfClass:[NSString class]] ||
		[value isKindOfClass:[NSNumber class]]) {
		return [value integerValue];
	}
	return 0;
}

- (NSUInteger)kt_unsignedIntegerAtIndex:(NSInteger)index {
	id value = [self kt_objectOrNilAtIndex:index];
	if ([value isKindOfClass:[NSString class]] ||
		[value isKindOfClass:[NSNumber class]]) {
		return [value unsignedIntegerValue];
	}
	return 0;
}

- (BOOL)kt_boolAtIndex:(NSInteger)index {
	id value = [self kt_objectOrNilAtIndex:index];
	if ([value isKindOfClass:[NSNumber class]] ||
		[value isKindOfClass:[NSString class]]) {
		return [value boolValue];
	}
	return NO;
}

- (int16_t)kt_int16AtIndex:(NSInteger)index {
	id value = [self kt_objectOrNilAtIndex:index];
	if ([value isKindOfClass:[NSNumber class]]) {
		return [(NSNumber *)value shortValue];
	} else if ([value isKindOfClass:[NSString class]]) {
		return [(NSString *)value intValue];
	} else {
		return 0;
	}
}

- (int32_t)kt_int32AtIndex:(NSInteger)index {
	id value = [self kt_objectOrNilAtIndex:index];
	if ([value isKindOfClass:[NSNumber class]] ||
		[value isKindOfClass:[NSString class]]) {
		return [value intValue];
	}
	return 0;
}

- (int64_t)kt_int64AtIndex:(NSInteger)index {
	id value = [self kt_objectOrNilAtIndex:index];
	if ([value isKindOfClass:[NSNumber class]] ||
		[value isKindOfClass:[NSString class]]) {
		return [value longLongValue];
	}
	return 0;
}

- (char)kt_charAtIndex:(NSInteger)index {
	id value = [self kt_objectOrNilAtIndex:index];
	if ([value isKindOfClass:[NSNumber class]] ||
		[value isKindOfClass:[NSString class]]) {
		return [value charValue];
	}
	return 0;
}

- (short)kt_shortAtIndex:(NSInteger)index {
	id value = [self kt_objectOrNilAtIndex:index];
	if ([value isKindOfClass:[NSNumber class]]) {
		return [(NSNumber *)value shortValue];
	} else if ([value isKindOfClass:[NSString class]]) {
		return [(NSString *)value intValue];
	} else {
		return 0;
	}
}

- (float)kt_floatAtIndex:(NSInteger)index {
	id value = [self kt_objectOrNilAtIndex:index];

	if ([value isKindOfClass:[NSNumber class]] ||
		[value isKindOfClass:[NSString class]]) {
		return [value floatValue];
	} else {
		return 0.f;
	}
}

- (CGFloat)kt_cgFloatAtIndex:(NSInteger)index {
	CGFloat value = (CGFloat)[self kt_floatAtIndex:index];
	return value;
}

- (double)kt_doubleAtIndex:(NSInteger)index {
	id value = [self kt_objectOrNilAtIndex:index];
	
	if ([value isKindOfClass:[NSNumber class]] ||
		[value isKindOfClass:[NSString class]]) {
		return [value doubleValue];
	} else {
		return 0.f;
	}
}

- (CGPoint)kt_pointAtIndex:(NSInteger)index {
	id value = [self kt_stringAtIndex:index];
	CGPoint point = CGPointFromString(value);
	return point;
}

- (CGSize)kt_sizeAtIndex:(NSInteger)index {
	id value = [self kt_stringAtIndex:index];
	CGSize size = CGSizeFromString(value);
	return size;
}

- (CGRect)kt_rectAtIndex:(NSInteger)index {
	id value = [self kt_stringAtIndex:index];
	CGRect rect = CGRectFromString(value);
	return rect;
}

- (nullable NSDate *)kt_dateAtIndex:(NSInteger)index
							 format:(nonnull NSString *)dateFormat {
	id value = [self kt_objectOrNilAtIndex:index];
	if ([value isKindOfClass:[NSString class]] &&
		((NSString *)value).length > 0 &&
		dateFormat) {
		NSDateFormatter *formater = [[NSDateFormatter alloc] init];
		formater.dateFormat = dateFormat;
		return [formater dateFromString:value];
	} else {
		return nil;
	}
}

/**
 /// 获取数组元素中key对应的value的集合组成的数据，返回的数组内的元素是可以相同的
 @param key key
 @return key对应的value组成的数组
 */
- (nullable NSMutableArray *)kt_valueArrayWithKey:(nonnull NSString *)key {
	if (!key) {
#if DEBUG
		NSAssert(NO, @"key can not be nil");
#endif
		return nil;
	}
	NSMutableArray *values = [NSMutableArray new];
	for (NSObject *obj in self) {
		if ([obj isKindOfClass:[NSDictionary class]]) {
			NSDictionary *dic = (NSDictionary *)obj;
			id value = [dic objectForKey:key];
			if (value) {
				[values addObject:value];
			}
		} else {
			SEL selector = NSSelectorFromString(key);
			if ([obj respondsToSelector:selector]) {
				id value = [obj valueForKey:key];
				if (value) {
					[values addObject:value];
				}
			}
		}
	}
	return values;
}

/// 获取数组元素中key对应的value的集合组成的数据，返回的数组内的元素是不相同
/// @param key key
- (NSArray *)kt_uniqueValuesWithKey:(nonnull NSString *)key {
	if (!key) {
#if DEBUG
		NSAssert(NO, @"key can't be nil");
#endif
		return nil;
	}
	NSMutableSet *set = [NSMutableSet new];
	for (NSObject *obj in self) {
		if ([obj isKindOfClass:[NSDictionary class]]) {
			NSDictionary *dic = (NSDictionary *)obj;
			id value = [dic objectForKey:key];
			if (value) {
				[set addObject:value];
			}
		} else {
			SEL selector = NSSelectorFromString(key);
			if ([obj respondsToSelector:selector]) {
				id value = [obj valueForKey:key];
				if (value) {
					[set addObject:value];
				}
			}
		}
		
	}
	return [set allObjects];
}

- (NSString *)kt_jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

- (NSString *)kt_jsonPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

- (nonnull NSArray *)kt_ascSortArray {
	NSMutableArray *array = [NSMutableArray arrayWithArray:self];
	[array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [obj1 compare:obj2];
	}];
	return [array copy];
}

- (nonnull NSArray *)kt_descSortArray {
	NSMutableArray *array = [NSMutableArray arrayWithArray:self];
	[array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		NSComparisonResult rs = [obj1 compare:obj2];
		if (rs == NSOrderedAscending) {
			return NSOrderedDescending;
		} else if (rs == NSOrderedDescending) {
			return NSOrderedAscending;
		} else {
			return rs;
		}
	}];
	return [array copy];
}

@end



@implementation NSMutableArray (KTHelp)

+ (NSMutableArray *)kt_arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) return array;
    return nil;
}

+ (NSMutableArray *)kt_arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self kt_arrayWithPlistData:data];
}

- (void)kt_removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)kt_removeLastObject {
    if (self.count) {
        [self removeObjectAtIndex:self.count - 1];
    }
}

#pragma clang diagnostic pop


- (id)kt_popFirstObject {
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self kt_removeFirstObject];
    }
    return obj;
}

- (id)kt_popLastObject {
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self kt_removeLastObject];
    }
    return obj;
}

- (void)kt_removeObjectAtIndex:(NSUInteger)index {
#if DEBUG
	NSAssert(index < self.count, @"make sure index < self.count be YES");
#endif
	
	if (index >= self.count) {
		return;
	}
	
	[self removeObjectAtIndex:index];
}

- (void)kt_appendObject:(id)anObject {
#if DEBUG
	NSAssert(anObject, @"anObject can't be nil");
#endif
	
	if (!anObject) {
		return;
	}
	
    [self addObject:anObject];
}

- (void)kt_prependObject:(id)anObject {
#if DEBUG
	NSAssert(anObject, @"anObject can't be nil");
#endif
	
	if (!anObject) {
		return;
	}
	
    [self insertObject:anObject atIndex:0];
}

- (void)kt_appendObjects:(NSArray *)objects {
    if (!objects) return;
    [self addObjectsFromArray:objects];
}

- (void)kt_prependObjects:(NSArray *)objects {
    if (!objects) return;
    NSUInteger i = 0;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)kt_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    NSUInteger i = index;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)kt_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
#if DEBUG
	NSAssert(anObject, @"anObject can't be nil");
	NSAssert(index < self.count, @"make sure index < self.count be YES");
#endif
	
	if (!anObject) {
		return;
	}
	
	if (index >= self.count) {
		return;
	}
	
	[self replaceObjectAtIndex:index withObject:anObject];
}

- (void)kt_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
#if DEBUG
	NSAssert(idx1 < self.count, @"make sure idx1 < self.count");
	NSAssert(idx2 < self.count, @"make sure idx2 < self.count");
#endif
	
	if (idx1 >= self.count) {
		return;
	}
	
	if (idx2 >= self.count) {
		return;
	}
	
	[self exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)kt_reverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

- (void)kt_shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

- (void)kt_ascSort {
	[self sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		return [obj1 compare:obj2];
	}];
}

- (void)kt_descSort {
	[self sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		NSComparisonResult rs = [obj1 compare:obj2];
		if (rs == NSOrderedAscending) {
			return NSOrderedDescending;
		} else if (rs == NSOrderedDescending) {
			return NSOrderedAscending;
		} else {
			return rs;
		}
	}];
}

@end
