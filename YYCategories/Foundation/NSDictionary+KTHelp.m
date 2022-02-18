//
//  NSDictionary+KTHelp.m
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/4/4.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSDictionary+KTHelp.h"
#import "NSString+YYAdd.h"
#import "NSData+KTHelp.h"
#import "YYCategoriesMacro.h"
#import "NSArray+KTHelp.h"

@interface _YYXMLDictionaryParser : NSObject <NSXMLParserDelegate>
@end

@implementation _YYXMLDictionaryParser {
    NSMutableDictionary *_root;
    NSMutableArray *_stack;
    NSMutableString *_text;
}

- (instancetype)initWithData:(NSData *)data {
    self = super.init;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    return self;
}

- (instancetype)initWithString:(NSString *)xml {
    NSData *data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    return [self initWithData:data];
}

- (NSDictionary *)result {
    return _root;
}

#pragma mark NSXMLParserDelegate

#define XMLText @"_text"
#define XMLName @"_name"
#define XMLPref @"_"

- (void)textEnd {
    _text = _text.stringByTrim.mutableCopy;
    if (_text.length) {
        NSMutableDictionary *top = _stack.lastObject;
        id existing = top[XMLText];
        if ([existing isKindOfClass:[NSArray class]]) {
            [existing addObject:_text];
        } else if (existing) {
            top[XMLText] = [@[existing, _text] mutableCopy];
        } else {
            top[XMLText] = _text;
        }
    }
    _text = nil;
}

- (void)parser:(__unused NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(__unused NSString *)namespaceURI qualifiedName:(__unused NSString *)qName attributes:(NSDictionary *)attributeDict {
    [self textEnd];
    
    NSMutableDictionary *node = [NSMutableDictionary new];
    if (!_root) node[XMLName] = elementName;
    if (attributeDict.count) [node addEntriesFromDictionary:attributeDict];
    
    if (_root) {
        NSMutableDictionary *top = _stack.lastObject;
        id existing = top[elementName];
        if ([existing isKindOfClass:[NSArray class]]) {
            [existing addObject:node];
        } else if (existing) {
            top[elementName] = [@[existing, node] mutableCopy];
        } else {
            top[elementName] = node;
        }
        [_stack addObject:node];
    } else {
        _root = node;
        _stack = [NSMutableArray arrayWithObject:node];
    }
}

- (void)parser:(__unused NSXMLParser *)parser didEndElement:(__unused NSString *)elementName namespaceURI:(__unused NSString *)namespaceURI qualifiedName:(__unused NSString *)qName {
    [self textEnd];
    
    NSMutableDictionary *top = _stack.lastObject;
    [_stack kt_removeLastObject];
    
    NSMutableDictionary *left = top.mutableCopy;
    [left removeObjectsForKeys:@[XMLText, XMLName]];
    for (NSString *key in left.allKeys) {
        [left removeObjectForKey:key];
        if ([key hasPrefix:XMLPref]) {
            left[[key substringFromIndex:XMLPref.length]] = top[key];
        }
    }
    if (left.count) return;
    
    NSMutableDictionary *children = top.mutableCopy;
    [children removeObjectsForKeys:@[XMLText, XMLName]];
    for (NSString *key in children.allKeys) {
        if ([key hasPrefix:XMLPref]) {
            [children removeObjectForKey:key];
        }
    }
    if (children.count) return;
    
    NSMutableDictionary *topNew = _stack.lastObject;
    NSString *nodeName = top[XMLName];
    if (!nodeName) {
        for (NSString *name in topNew) {
            id object = topNew[name];
            if (object == top) {
                nodeName = name; break;
            } else if ([object isKindOfClass:[NSArray class]] && [object containsObject:top]) {
                nodeName = name; break;
            }
        }
    }
    if (!nodeName) return;
    
    id inner = top[XMLText];
    if ([inner isKindOfClass:[NSArray class]]) {
        inner = [inner componentsJoinedByString:@"\n"];
    }
    if (!inner) return;
    
    id parent = topNew[nodeName];
    if ([parent isKindOfClass:[NSArray class]]) {
        parent[[parent count] - 1] = inner;
    } else {
        topNew[nodeName] = inner;
    }
}

- (void)parser:(__unused NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (_text) [_text appendString:string];
    else _text = [NSMutableString stringWithString:string];
}

- (void)parser:(__unused NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    NSString *string = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    if (_text) [_text appendString:string];
    else _text = [NSMutableString stringWithString:string];
}

#undef XMLText
#undef XMLName
#undef XMLPref
@end


@implementation NSDictionary (KTHelp)

+ (NSDictionary *)kt_dictionaryWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([dictionary isKindOfClass:[NSDictionary class]]) return dictionary;
    return nil;
}

+ (NSDictionary *)kt_dictionaryWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self kt_dictionaryWithPlistData:data];
}

- (NSData *)kt_plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

- (NSString *)kt_plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return xmlData.kt_utf8String;
    return nil;
}

- (NSArray *)kt_allKeysSorted {
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSArray *)kt_allValuesSortedByKeys {
    NSArray *sortedKeys = [self kt_allKeysSorted];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id key in sortedKeys) {
        [arr addObject:self[key]];
    }
    return arr;
}

- (BOOL)kt_containsObjectForKey:(id)key {
    if (!key) return NO;
    return self[key] != nil;
}

- (NSDictionary *)kt_entriesForKeys:(NSArray *)keys {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (id key in keys) {
        id value = self[key];
        if (value) dic[key] = value;
    }
    return dic;
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

+ (NSDictionary *)kt_dictionaryWithXML:(id)xml {
    _YYXMLDictionaryParser *parser = nil;
    if ([xml isKindOfClass:[NSString class]]) {
        parser = [[_YYXMLDictionaryParser alloc] initWithString:xml];
    } else if ([xml isKindOfClass:[NSData class]]) {
        parser = [[_YYXMLDictionaryParser alloc] initWithData:xml];
    }
    return [parser result];
}


/// Get a number value from 'id'.
static NSNumber *NSNumberFromID(id value) {
    static NSCharacterSet *dot;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)];
    });
    if (!value || value == [NSNull null]) return nil;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) {
        NSString *lower = ((NSString *)value).lowercaseString;
        if ([lower isEqualToString:@"true"] || [lower isEqualToString:@"yes"]) return @(YES);
        if ([lower isEqualToString:@"false"] || [lower isEqualToString:@"no"]) return @(NO);
        if ([lower isEqualToString:@"nil"] || [lower isEqualToString:@"null"]) return nil;
        if ([(NSString *)value rangeOfCharacterFromSet:dot].location != NSNotFound) {
            return @(((NSString *)value).doubleValue);
        } else {
            return @(((NSString *)value).longLongValue);
        }
    }
    return nil;
}

#define RETURN_VALUE(_type_)                                                     \
if (!key) return def;                                                            \
id value = self[key];                                                            \
if (!value || value == [NSNull null]) return def;                                \
if ([value isKindOfClass:[NSNumber class]]) return ((NSNumber *)value)._type_;   \
if ([value isKindOfClass:[NSString class]]) return NSNumberFromID(value)._type_; \
return def;

- (nullable id)kt_objectForKey:(nonnull NSString *)key verifyClass:(nullable Class)theClass {
	id object = [self objectForKey:key];
	if (!theClass) {
		return object;
	}

	if (![theClass isSubclassOfClass:[NSObject class]]) {
#if DEBUG
		NSAssert(NO, @"theClass must be subClass of NSObject");
#endif
		return nil;
	}
		
	if ([object isKindOfClass:theClass]) {
		return object;
	}
	return nil;
}

- (BOOL)kt_boolValueForKey:(NSString *)key withDefault:(BOOL)def {
    RETURN_VALUE(boolValue);
}

- (char)kt_charValueForKey:(NSString *)key withDefault:(char)def {
    RETURN_VALUE(charValue);
}

- (unsigned char)kt_unsignedCharValueForKey:(NSString *)key withDefault:(unsigned char)def {
    RETURN_VALUE(unsignedCharValue);
}

- (short)kt_shortValueForKey:(NSString *)key withDefault:(short)def {
    RETURN_VALUE(shortValue);
}

- (unsigned short)kt_unsignedShortValueForKey:(NSString *)key withDefault:(unsigned short)def {
    RETURN_VALUE(unsignedShortValue);
}

- (int)kt_intValueForKey:(NSString *)key withDefault:(int)def {
    RETURN_VALUE(intValue);
}

- (unsigned int)kt_unsignedIntValueForKey:(NSString *)key withDefault:(unsigned int)def {
    RETURN_VALUE(unsignedIntValue);
}

- (long)kt_longValueForKey:(NSString *)key withDefault:(long)def {
    RETURN_VALUE(longValue);
}

- (unsigned long)kt_unsignedLongValueForKey:(NSString *)key withDefault:(unsigned long)def {
    RETURN_VALUE(unsignedLongValue);
}

- (long long)kt_longLongValueForKey:(NSString *)key withDefault:(long long)def {
    RETURN_VALUE(longLongValue);
}

- (unsigned long long)kt_unsignedLongLongValueForKey:(NSString *)key withDefault:(unsigned long long)def {
    RETURN_VALUE(unsignedLongLongValue);
}

- (float)kt_floatValueForKey:(NSString *)key withDefault:(float)def {
    RETURN_VALUE(floatValue);
}

- (double)kt_doubleValueForKey:(NSString *)key withDefault:(double)def {
    RETURN_VALUE(doubleValue);
}

- (NSInteger)kt_integerValueForKey:(NSString *)key withDefault:(NSInteger)def {
    RETURN_VALUE(integerValue);
}

- (NSUInteger)kt_unsignedIntegerValueForKey:(NSString *)key withDefault:(NSUInteger)def {
    RETURN_VALUE(unsignedIntegerValue);
}

- (NSNumber *)kt_numberForKey:(NSString *)key {
	return [self kt_numberForKey:key withDefault:nil];
}

- (NSNumber *)kt_numberForKey:(NSString *)key withDefault:(NSNumber *)def {
    if (!key) return def;
    id value = self[key];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) return NSNumberFromID(value);
    return def;
}

- (nullable NSString *)kt_stringForKey:(NSString *)key {
	return [self kt_stringForKey:key withDefault:nil];
}

- (NSString *)kt_stringForKey:(NSString *)key withDefault:(NSString *)def {
    if (!key) return def;
    id value = self[key];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSString class]]) return value;
    if ([value isKindOfClass:[NSNumber class]]) return ((NSNumber *)value).description;
    return def;
}

- (nullable NSArray *)kt_arrayForKey:(nonnull NSString *)key {
	return [self kt_arrayForKey:key withDefault:nil];
}

- (nullable NSArray *)kt_arrayForKey:(nonnull NSString *)key withDefault:(nullable NSArray *)def {
	if (!key) return def;
	id value = self[key];
	if (!value || value == [NSNull null]) return def;
	if ([value isKindOfClass:[NSArray class]]) return value;
	return def;
}

- (nullable NSDictionary *)kt_dictionaryForKey:(nonnull NSString *)key {
	return [self kt_dictionaryForKey:key withDefault:nil];
}

- (nullable NSDictionary *)kt_dictionaryForKey:(nonnull NSString *)key withDefault:(nullable NSDictionary *)def {
	if (!key) return def;
	id value = self[key];
	if (!value || value == [NSNull null]) return def;
	if ([value isKindOfClass:[NSDictionary class]]) return value;
	return def;
}

- (BOOL)kt_boolForKeyPath:(nonnull NSString *)keyPath
{
  NSArray *keys = [keyPath componentsSeparatedByString:@"."];
  NSDictionary *dic = self;
  BOOL value = NO;
  
  for (NSInteger i = 0; i < keys.count; i++) {
	  NSString *key = keys[i];
	  if (i == keys.count - 1) {
		  value = [dic kt_boolValueForKey:key withDefault:NO];
	  } else {
		  dic = [dic kt_dictionaryForKey:key];
		  if (!dic) {
			  break;
		  }
	  }
  }
  
  return value;
}

- (float)kt_floatForKeyPath:(nonnull NSString *)keyPath
{
	NSArray *keys = [keyPath componentsSeparatedByString:@"."];
	NSDictionary *dic = self;
	float value = 0.f;
	
	for (NSInteger i = 0; i < keys.count; i++) {
		NSString *key = keys[i];
		if (i == keys.count - 1) {
			value = [dic kt_floatValueForKey:key withDefault:0.f];
		} else {
			dic = [dic kt_dictionaryForKey:key];
			if (!dic) {
				break;
			}
		}
	}
	
	return value;
}

- (double)kt_doubleForKeyPath:(nonnull NSString *)keyPath
{
   NSArray *keys = [keyPath componentsSeparatedByString:@"."];
   NSDictionary *dic = self;
   double value = 0.f;
   
   for (NSInteger i = 0; i < keys.count; i++) {
	   NSString *key = keys[i];
	   if (i == keys.count - 1) {
		   value = [dic kt_doubleValueForKey:key withDefault:0.f];
	   } else {
		   dic = [dic kt_dictionaryForKey:key];
		   if (!dic) {
			   break;
		   }
	   }
   }
   
   return value;
}

- (NSInteger)kt_integerForKeyPath:(nonnull NSString *)keyPath
{
	NSArray *keys = [keyPath componentsSeparatedByString:@"."];
	NSDictionary *dic = self;
	NSInteger value = 0;
	
	for (NSInteger i = 0; i < keys.count; i++) {
		NSString *key = keys[i];
		if (i == keys.count - 1) {
			value = [dic kt_integerValueForKey:key withDefault:0];
		} else {
			dic = [dic kt_dictionaryForKey:key];
			if (!dic) {
				break;
			}
		}
	}
	
	return value;
}

- (nullable NSNumber *)kt_numberForKeyPath:(nonnull NSString *)keyPath
{
	NSArray *keys = [keyPath componentsSeparatedByString:@"."];
	NSDictionary *dic = self;
	NSNumber *number = nil;
	
	for (NSInteger i = 0; i < keys.count; i++) {
		NSString *key = keys[i];
		if (i == keys.count - 1) {
			number = [dic kt_numberForKey:key];
		} else {
			dic = [dic kt_dictionaryForKey:key];
			if (!dic) {
				break;
			}
		}
	}
	
	return number;
}

- (nullable NSString *)kt_stringForKeyPath:(nonnull NSString *)keyPath
{
	NSArray *keys = [keyPath componentsSeparatedByString:@"."];
	NSDictionary *dic = self;
	NSString *string = nil;
	
	for (NSInteger i = 0; i < keys.count; i++) {
		NSString *key = keys[i];
		if (i == keys.count - 1) {
			string = [dic kt_stringForKey:key];
		} else {
			dic = [dic kt_dictionaryForKey:key];
			if (!dic) {
				break;
			}
		}
	}
	
	return string;
}

- (nullable NSArray *)kt_arrayForKeyPath:(nonnull NSString *)keyPath
{
	NSArray *keys = [keyPath componentsSeparatedByString:@"."];
	NSDictionary *dic = self;
	NSArray *array = nil;
	
	for (NSInteger i = 0; i < keys.count; i++) {
		NSString *key = keys[i];
		if (i == keys.count - 1) {
			array = [dic kt_arrayForKey:key];
			if (!dic) {
				break;
			}
		} else {
			dic = [dic kt_dictionaryForKey:key];
			if (!dic) {
				break;
			}
		}
	}
	
	return array;
}

-  (nullable NSDictionary *)kt_dictionaryForKeyPath:(nonnull NSString *)keyPath
{
	NSArray *keys = [keyPath componentsSeparatedByString:@"."];
	NSDictionary *dic = self;
	
	for (NSInteger i = 0; i < keys.count; i++) {
		NSString *key = keys[i];
		dic = [dic kt_dictionaryForKey:key];
		if (!dic) {
			break;
		}
	}
	
	return dic;
}

@end


@implementation NSMutableDictionary (KTHelp)

+ (NSMutableDictionary *)kt_dictionaryWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([dictionary isKindOfClass:[NSMutableDictionary class]]) return dictionary;
    return nil;
}

+ (NSMutableDictionary *)kt_dictionaryWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self kt_dictionaryWithPlistData:data];
}

- (id)kt_popObjectForKey:(id)aKey {
    if (!aKey) return nil;
    id value = self[aKey];
    [self removeObjectForKey:aKey];
    return value;
}

- (NSDictionary *)kt_popEntriesForKeys:(NSArray *)keys {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (id key in keys) {
        id value = self[key];
        if (value) {
            [self removeObjectForKey:key];
            dic[key] = value;
        }
    }
    return dic;
}

@end
