//
//  NSArray+KTHelp.h
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/4/4.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provide some some common method for `NSArray`.
 */
@interface NSArray (KTHelp)

/**
 Creates and returns an array from a specified property list data.
 
 @param plist   A property list data whose root object is an array.
 @return A new array created from the plist data, or nil if an error occurs.
 */
+ (nullable NSArray *)kt_arrayWithPlistData:(NSData *)plist;

/**
 Creates and returns an array from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (nullable NSArray *)kt_arrayWithPlistString:(NSString *)plist;

/**
 Serialize the array to a binary property list data.
 
 @return A bplist data, or nil if an error occurs.
 */
- (nullable NSData *)kt_plistData;

/**
 Serialize the array to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (nullable NSString *)kt_plistString;

/**
 Returns the object located at a random index.
 
 @return The object in the array with a random index value.
 If the array is empty, returns nil.
 */
- (nullable id)kt_randomObject;

/**
 Returns the object located at index, or return nil when out of bounds.
 It's similar to `objectAtIndex:`, but it never throw exception.
 
 @param index The object located at index.
 */
- (nullable id)kt_objectAtIndex:(NSUInteger)index;

- (nullable id)kt_objectAtIndex:(NSInteger)index verifyClass:(nullable Class)theClass;

- (nullable NSString *)kt_stringAtIndex:(NSInteger)index;

- (nullable NSNumber *)kt_numberAtIndex:(NSInteger)index;

- (nullable NSDecimalNumber *)kt_decimalNumberAtIndex:(NSInteger)index;

- (nullable NSArray *)kt_arrayAtIndex:(NSInteger)index;

- (nullable NSDictionary *)kt_dictionaryAtIndex:(NSInteger)index;

- (NSInteger)kt_integerAtIndex:(NSInteger)index;

- (NSUInteger)kt_unsignedIntegerAtIndex:(NSInteger)index;

- (BOOL)kt_boolAtIndex:(NSInteger)index;

- (int16_t)kt_int16AtIndex:(NSInteger)index;

- (int32_t)kt_int32AtIndex:(NSInteger)index;

- (int64_t)kt_int64AtIndex:(NSInteger)index;

- (char)kt_charAtIndex:(NSInteger)index;

- (short)kt_shortAtIndex:(NSInteger)index;

- (float)kt_floatAtIndex:(NSInteger)index;

- (CGFloat)kt_cgFloatAtIndex:(NSInteger)index;

- (double)kt_doubleAtIndex:(NSInteger)index;

- (CGPoint)kt_pointAtIndex:(NSInteger)index;

- (CGSize)kt_sizeAtIndex:(NSInteger)index;

- (CGRect)kt_rectAtIndex:(NSInteger)index;

- (nullable NSDate *)kt_dateAtIndex:(NSInteger)index format:(nonnull NSString *)dateFormat;

/// 获取数组元素中key对应的value的集合组成的数据，返回的数组内的元素是可以相同的
/// @param key key
- (nullable NSMutableArray *)kt_valueArrayWithKey:(nonnull NSString *)key;

/// 获取数组元素中key对应的value的集合组成的数据，返回的数组内的元素是不相同
/// @param key key
- (NSArray *)kt_uniqueValuesWithKey:(nonnull NSString *)key;

/**
 Convert object to json string. return nil if an error occurs.
 NSString/NSNumber/NSDictionary/NSArray
 */
- (nullable NSString *)kt_jsonStringEncoded;

/**
 Convert object to json string formatted. return nil if an error occurs.
 */
- (nullable NSString *)kt_jsonPrettyStringEncoded;

/**
 升序 数组元素为纯数字的NSString类型，或者NSNumber类型
 
 @return 排序后的数组
 */
- (nonnull NSArray *)kt_ascSortArray;

/**
 降序 数组元素为纯数字的NSString类型，或者NSNumber类型
 
 @return 排序后的数组
 */
- (nonnull NSArray *)kt_descSortArray;

@end


/**
 Provide some some common method for `NSMutableArray`.
 */
@interface NSMutableArray (KTHelp)

/**
 Creates and returns an array from a specified property list data.
 
 @param plist   A property list data whose root object is an array.
 @return A new array created from the plist data, or nil if an error occurs.
 */
+ (nullable NSMutableArray *)kt_arrayWithPlistData:(NSData *)plist;

/**
 Creates and returns an array from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (nullable NSMutableArray *)kt_arrayWithPlistString:(NSString *)plist;

/**
 Removes the object with the lowest-valued index in the array.
 If the array is empty, this method has no effect.
 
 @discussion Apple has implemented this method, but did not make it public.
 Override for safe.
 */
- (void)kt_removeFirstObject;

/**
 Removes the object with the highest-valued index in the array.
 If the array is empty, this method has no effect.
 
 @discussion Apple's implementation said it raises an NSRangeException if the
 array is empty, but in fact nothing will happen. Override for safe.
 */
- (void)kt_removeLastObject;

/**
 Removes and returns the object with the lowest-valued index in the array.
 If the array is empty, it just returns nil.
 
 @return The first object, or nil.
 */
- (nullable id)kt_popFirstObject;

/**
 Removes and returns the object with the highest-valued index in the array.
 If the array is empty, it just returns nil.
 
 @return The first object, or nil.
 */
- (nullable id)kt_popLastObject;

/// 移除元素，下标异常时，测试环境崩溃，线上环境不处理
- (void)kt_removeObjectAtIndex:(NSUInteger)index;

/**
 Inserts a given object at the end of the array.
 
 @param anObject The object to add to the end of the array's content.
 This value must not be nil. Raises an NSInvalidArgumentException if anObject is nil.
 */
- (void)kt_appendObject:(id)anObject;

/**
 Inserts a given object at the beginning of the array.
 
 @param anObject The object to add to the end of the array's content.
 This value must not be nil. Raises an NSInvalidArgumentException if anObject is nil.
 */
- (void)kt_prependObject:(id)anObject;

/**
 Adds the objects contained in another given array to the end of the receiving
 array's content.
 
 @param objects An array of objects to add to the end of the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 */
- (void)kt_appendObjects:(NSArray *)objects;

/**
 Adds the objects contained in another given array to the beginnin of the receiving
 array's content.
 
 @param objects An array of objects to add to the beginning of the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 */
- (void)kt_prependObjects:(NSArray *)objects;

/**
 Adds the objects contained in another given array at the index of the receiving
 array's content.
 
 @param objects An array of objects to add to the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 
 @param index The index in the array at which to insert objects. This value must
 not be greater than the count of elements in the array. Raises an
 NSRangeException if index is greater than the number of elements in the array.
 */
- (void)kt_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;

/// 添加元素数组，确保类型正确，异常时，测试环境会崩溃,线上环境不处理
- (void)kt_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

/// 交换元素，确保下表正确，异常时，测试环境会崩溃,线上环境不处理
- (void)kt_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;

/**
 Reverse the index of object in this array.
 Example: Before @[ @1, @2, @3 ], After @[ @3, @2, @1 ].
 */
- (void)kt_reverse;

/**
 Sort the object in this array randomly.
 */
- (void)kt_shuffle;

/// 数组生序排列
- (void)kt_ascSort;

/// 数组降序排列
- (void)kt_descSort;

@end

NS_ASSUME_NONNULL_END
