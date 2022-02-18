//
//  NSDictionary+KTHelp.h
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/4/4.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provide some some common method for `NSDictionary`.
 */
@interface NSDictionary (KTHelp)

#pragma mark - Dictionary Convertor
///=============================================================================
/// @name Dictionary Convertor
///=============================================================================

/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the plist data, or nil if an error occurs.
 */
+ (nullable NSDictionary *)kt_dictionaryWithPlistData:(NSData *)plist;

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (nullable NSDictionary *)kt_dictionaryWithPlistString:(NSString *)plist;

/**
 Serialize the dictionary to a binary property list data.
 
 @return A bplist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
- (nullable NSData *)kt_plistData;

/**
 Serialize the dictionary to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (nullable NSString *)kt_plistString;

/**
 Returns a new array containing the dictionary's keys sorted.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)kt_allKeysSorted;

/**
 Returns a new array containing the dictionary's values sorted by keys.
 
 The order of the values in the array is defined by keys.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's values sorted by keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)kt_allValuesSortedByKeys;

/**
 Returns a BOOL value tells if the dictionary has an object for key.
 
 @param key The key.
 */
- (BOOL)kt_containsObjectForKey:(id)key;

/**
 Returns a new dictionary containing the entries for keys.
 If the keys is empty or nil, it just returns an empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)kt_entriesForKeys:(NSArray *)keys;

/**
 Convert dictionary to json string. return nil if an error occurs.
 */
- (nullable NSString *)kt_jsonStringEncoded;

/**
 Convert dictionary to json string formatted. return nil if an error occurs.
 */
- (nullable NSString *)kt_jsonPrettyStringEncoded;

/**
 Try to parse an XML and wrap it into a dictionary.
 If you just want to get some value from a small xml, try this.
 
 example XML: "<config><a href="test.com">link</a></config>"
 example Return: @{@"_name":@"config", @"a":{@"_text":@"link",@"href":@"test.com"}}
 
 @param xmlDataOrString XML in NSData or NSString format.
 @return Return a new dictionary, or nil if an error occurs.
 */
+ (nullable NSDictionary *)kt_dictionaryWithXML:(id)xmlDataOrString;

#pragma mark - Dictionary Value Getter
///=============================================================================
/// @name Dictionary Value Getter
///=============================================================================

/// 根据key获取元素值，并对元素类型进行判断
/// @param key key
/// @param theClass 进行判定的类
- (nullable id)kt_objectForKey:(nonnull NSString *)key verifyClass:(nullable Class)theClass;

- (BOOL)kt_boolValueForKey:(NSString *)key withDefault:(BOOL)def;

- (char)kt_charValueForKey:(NSString *)key withDefault:(char)def;
- (unsigned char)kt_unsignedCharValueForKey:(NSString *)key withDefault:(unsigned char)def;

- (short)kt_shortValueForKey:(NSString *)key withDefault:(short)def;
- (unsigned short)kt_unsignedShortValueForKey:(NSString *)key withDefault:(unsigned short)def;

- (int)kt_intValueForKey:(NSString *)key withDefault:(int)def;
- (unsigned int)kt_unsignedIntValueForKey:(NSString *)key withDefault:(unsigned int)def;

- (long)kt_longValueForKey:(NSString *)key withDefault:(long)def;
- (unsigned long)kt_unsignedLongValueForKey:(NSString *)key withDefault:(unsigned long)def;

- (long long)kt_longLongValueForKey:(NSString *)key withDefault:(long long)def;
- (unsigned long long)kt_unsignedLongLongValueForKey:(NSString *)key withDefault:(unsigned long long)def;

- (float)kt_floatValueForKey:(NSString *)key withDefault:(float)def;
- (double)kt_doubleValueForKey:(NSString *)key withDefault:(double)def;

- (NSInteger)kt_integerValueForKey:(NSString *)key withDefault:(NSInteger)def;
- (NSUInteger)kt_unsignedIntegerValueForKey:(NSString *)key withDefault:(NSUInteger)def;

- (nullable NSNumber *)kt_numberForKey:(NSString *)key;
- (nullable NSNumber *)kt_numberForKey:(NSString *)key withDefault:(nullable NSNumber *)def;
- (nullable NSString *)kt_stringForKey:(NSString *)key;
- (nullable NSString *)kt_stringForKey:(NSString *)key withDefault:(nullable NSString *)def;
- (nullable NSArray *)kt_arrayForKey:(nonnull NSString *)key;
- (nullable NSArray *)kt_arrayForKey:(nonnull NSString *)key withDefault:(nullable NSArray *)def;
- (nullable NSDictionary *)kt_dictionaryForKey:(nonnull NSString *)key;
- (nullable NSDictionary *)kt_dictionaryForKey:(nonnull NSString *)key withDefault:(nullable NSDictionary *)def;


- (BOOL)kt_boolForKeyPath:(nonnull NSString *)keyPath;
/// 存在精度问题，可以通过限定位数，NSDecimalNumber 实现更高的精度
/// @param keyPath keyPath
- (float)kt_floatForKeyPath:(nonnull NSString *)keyPath;
/// 存在精度问题，可以通过限定位数，NSDecimalNumber 实现更高的精度
/// @param keyPath keyPath
- (double)kt_doubleForKeyPath:(nonnull NSString *)keyPath;
- (NSInteger)kt_integerForKeyPath:(nonnull NSString *)keyPath;
- (nullable NSNumber *)kt_numberForKeyPath:(nonnull NSString *)keyPath;
- (nullable NSString *)kt_stringForKeyPath:(nonnull NSString *)keyPath;
- (nullable NSArray *)kt_arrayForKeyPath:(nonnull NSString *)keyPath;
- (nullable NSDictionary *)kt_dictionaryForKeyPath:(nonnull NSString *)keyPath;

@end



/**
 Provide some some common method for `NSMutableDictionary`.
 */
@interface NSMutableDictionary (KTHelp)

/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the plist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (nullable NSMutableDictionary *)kt_dictionaryWithPlistData:(NSData *)plist;

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 */
+ (nullable NSMutableDictionary *)kt_dictionaryWithPlistString:(NSString *)plist;


/**
 Removes and returns the value associated with a given key.
 
 @param aKey The key for which to return and remove the corresponding value.
 @return The value associated with aKey, or nil if no value is associated with aKey.
 */
- (nullable id)kt_popObjectForKey:(id)aKey;

/**
 Returns a new dictionary containing the entries for keys, and remove these
 entries from reciever. If the keys is empty or nil, it just returns an
 empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)kt_popEntriesForKeys:(NSArray *)keys;

@end

NS_ASSUME_NONNULL_END
