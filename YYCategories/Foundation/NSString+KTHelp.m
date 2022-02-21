//
//  NSString+KTHelp.m
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/4/3.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSString+KTHelp.h"
#import "NSData+KTHelp.h"
#import "NSNumber+KTHelp.h"
#import "UIDevice+KTHelp.h"
#import "YYCategoriesMacro.h"

@implementation NSString (KTHelp)

- (NSString *)kt_md2String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] kt_md2String];
}

- (NSString *)kt_md4String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] kt_md4String];
}

- (NSString *)kt_md5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] kt_md5String];
}

- (NSString *)kt_sha1String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] kt_sha1String];
}

- (NSString *)kt_sha224String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] kt_sha224String];
}

- (NSString *)kt_sha256String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] kt_sha256String];
}

- (NSString *)kt_sha384String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] kt_sha384String];
}

- (NSString *)kt_sha512String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] kt_sha512String];
}

- (NSString *)kt_crc32String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] kt_crc32String];
}

- (NSString *)kt_hmacMD5StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            kt_hmacMD5StringWithKey:key];
}

- (NSString *)kt_hmacSHA1StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            kt_hmacSHA1StringWithKey:key];
}

- (NSString *)kt_hmacSHA224StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            kt_hmacSHA224StringWithKey:key];
}

- (NSString *)kt_hmacSHA256StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            kt_hmacSHA256StringWithKey:key];
}

- (NSString *)kt_hmacSHA384StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            kt_hmacSHA384StringWithKey:key];
}

- (NSString *)kt_hmacSHA512StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            kt_hmacSHA512StringWithKey:key];
}

- (NSString *)kt_base64EncodedString {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] kt_base64EncodedString];
}

+ (NSString *)kt_stringWithBase64EncodedString:(NSString *)base64EncodedString {
    NSData *data = [NSData kt_dataWithBase64EncodedString:base64EncodedString];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)kt_stringByURLEncode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        /**
         AFNetworking/AFURLRequestSerialization.m
         
         Returns a percent-escaped string following RFC 3986 for a query string key or value.
         RFC 3986 states that the following characters are "reserved" characters.
            - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
            - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
         In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
         query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
         should be percent-escaped in the query string.
            - parameter string: The string to be percent-escaped.
            - returns: The percent-escaped string.
         */
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)kt_stringByURLDecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)kt_stringByEscapingHTML {
    NSUInteger len = self.length;
    if (!len) return self;
    
    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) return self;
    [self getCharacters:buf range:NSMakeRange(0, len)];
    
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < len; i++) {
        unichar c = buf[i];
        NSString *esc = nil;
        switch (c) {
            case 34: esc = @"&quot;"; break;
            case 38: esc = @"&amp;"; break;
            case 39: esc = @"&apos;"; break;
            case 60: esc = @"&lt;"; break;
            case 62: esc = @"&gt;"; break;
            default: break;
        }
        if (esc) {
            [result appendString:esc];
        } else {
            CFStringAppendCharacters((CFMutableStringRef)result, &c, 1);
        }
    }
    free(buf);
    return result;
}

- (CGSize)kt_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGFloat)kt_widthForFont:(UIFont *)font {
    CGSize size = [self kt_sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)kt_heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self kt_sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

- (NSInteger)kt_lineCountForFont:(UIFont *)font width:(CGFloat)width {
	if (self.length == 0) {
		return 0;
	}
	
	// 获取单行时候的内容的size
	CGSize singleSize = [self sizeWithAttributes:@{NSFontAttributeName:font}];
	// 获取多行时候,文字的size
	CGSize textSize = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
										 options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}
										 context:nil].size;
	// 返回计算的行数
	return ceil(textSize.height / singleSize.height);
}

- (BOOL)kt_matchesRegex:(NSString *)regex {
	NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	return [pre evaluateWithObject:self];
}

- (BOOL)kt_matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options {
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:NULL];
    if (!pattern) return NO;
    return ([pattern numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0);
}

- (void)kt_enumerateRegexMatches:(NSString *)regex
                      options:(NSRegularExpressionOptions)options
                   usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block {
    if (regex.length == 0 || !block) return;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!regex) return;
    [pattern enumerateMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        block([self substringWithRange:result.range], result.range, stop);
    }];
}

- (NSString *)kt_stringByReplacingRegex:(NSString *)regex
                             options:(NSRegularExpressionOptions)options
                          withString:(NSString *)replacement; {
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!pattern) return self;
    return [pattern stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:replacement];
}

- (char)kt_charValue {
    return self.kt_numberValue.charValue;
}

- (unsigned char) kt_unsignedCharValue {
    return self.kt_numberValue.unsignedCharValue;
}

- (short) kt_shortValue {
    return self.kt_numberValue.shortValue;
}

- (unsigned short) kt_unsignedShortValue {
    return self.kt_numberValue.unsignedShortValue;
}

- (unsigned int) kt_unsignedIntValue {
    return self.kt_numberValue.unsignedIntValue;
}

- (long) kt_longValue {
    return self.kt_numberValue.longValue;
}

- (unsigned long) kt_unsignedLongValue {
    return self.kt_numberValue.unsignedLongValue;
}

- (unsigned long long) kt_unsignedLongLongValue {
    return self.kt_numberValue.unsignedLongLongValue;
}

- (NSUInteger) kt_unsignedIntegerValue {
    return self.kt_numberValue.unsignedIntegerValue;
}

- (BOOL)kt_isHTMLStringWithString {
	NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"<[^>]+>" options:0 error:nil];
	NSArray *matches = [regularExpression matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
	return matches.count > 0;
}

- (NSAttributedString *)kt_getHTMLAttributedString {
	NSAttributedString *HTML = [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding]
																options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType}
													 documentAttributes:nil
																  error:nil];
	
	NSMutableAttributedString *mutableHTML = [[NSMutableAttributedString alloc] initWithAttributedString:HTML];
	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	style.lineBreakMode = NSLineBreakByTruncatingTail;
	[mutableHTML addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, mutableHTML.length)];
	return mutableHTML;
}

- (nullable NSURL *)kt_toUrl {
	if (self.length == 0) {
		return nil;
	}
	NSURL *url = [NSURL URLWithString:self];
	return url;
}

- (nullable NSDictionary *)kt_getURLQueries {
	if (self.length == 0) {
		return nil;
	}
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	NSURLComponents *components = [NSURLComponents componentsWithString:self];
	[components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
		[params setValue:obj.value forKey:obj.name];
	}];
	return params.copy;
}

+ (NSString *)kt_stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

+ (NSString *)kt_stringWithUTF32Char:(UTF32Char)char32 {
    char32 = NSSwapHostIntToLittle(char32);
    return [[NSString alloc] initWithBytes:&char32 length:4 encoding:NSUTF32LittleEndianStringEncoding];
}

+ (NSString *)kt_stringWithUTF32Chars:(const UTF32Char *)char32 length:(NSUInteger)length {
    return [[NSString alloc] initWithBytes:(const void *)char32
                                    length:length * 4
                                  encoding:NSUTF32LittleEndianStringEncoding];
}

- (void)kt_enumerateUTF32CharInRange:(NSRange)range usingBlock:(void (^)(UTF32Char char32, NSRange range, BOOL *stop))block {
    NSString *str = self;
    if (range.location != 0 || range.length != self.length) {
        str = [self substringWithRange:range];
    }
    NSUInteger len = [str lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4;
    UTF32Char *char32 = (UTF32Char *)[str cStringUsingEncoding:NSUTF32LittleEndianStringEncoding];
    if (len == 0 || char32 == NULL) return;
    
    NSUInteger location = 0;
    BOOL stop = NO;
    NSRange subRange;
    UTF32Char oneChar;
    
    for (NSUInteger i = 0; i < len; i++) {
        oneChar = char32[i];
        subRange = NSMakeRange(location, oneChar > 0xFFFF ? 2 : 1);
        block(oneChar, subRange, &stop);
        if (stop) return;
        location += subRange.length;
    }
}

- (NSString *)kt_stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)kt_stringByAppendingNameScale:(CGFloat)scale {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    return [self stringByAppendingFormat:@"@%@x", @(scale)];
}

- (NSString *)kt_stringByAppendingPathScale:(CGFloat)scale {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    NSString *ext = self.pathExtension;
    NSRange extRange = NSMakeRange(self.length - ext.length, 0);
    if (ext.length > 0) extRange.location -= 1;
    NSString *scaleStr = [NSString stringWithFormat:@"@%@x", @(scale)];
    return [self stringByReplacingCharactersInRange:extRange withString:scaleStr];
}

- (CGFloat)kt_pathScale {
    if (self.length == 0 || [self hasSuffix:@"/"]) return 1;
    NSString *name = self.stringByDeletingPathExtension;
    __block CGFloat scale = 1;
    [name kt_enumerateRegexMatches:@"@[0-9]+\\.?[0-9]*x$" options:NSRegularExpressionAnchorsMatchLines usingBlock: ^(NSString *match, NSRange matchRange, BOOL *stop) {
        scale = [match substringWithRange:NSMakeRange(1, match.length - 2)].doubleValue;
    }];
    return scale;
}

- (BOOL)kt_isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

//- (BOOL)containsString:(NSString *)string {
//    if (string == nil) return NO;
//    return [self rangeOfString:string].location != NSNotFound;
//}

- (BOOL)kt_containsCharacterSet:(NSCharacterSet *)set {
    if (set == nil) return NO;
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
}

- (NSNumber *)kt_numberValue {
    return [NSNumber kt_numberWithString:self];
}

- (NSData *)kt_dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSRange)kt_rangeOfAll {
    return NSMakeRange(0, self.length);
}

- (id)kt_jsonValueDecoded {
    return [[self kt_dataValue] kt_jsonValueDecoded];
}

+ (NSString *)kt_stringNamed:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (!str) {
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"txt"];
        str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    }
    return str;
}

- (NSString *)kt_removeDashSymbol {
	if (self.length == 0) {
		return self;
	}
	
	NSError *error;
	NSRegularExpression *espress = [NSRegularExpression regularExpressionWithPattern:@"#[0-9a-fA-F]{6}" options:NSRegularExpressionCaseInsensitive error:&error];
	NSArray *arrayofRange = [espress matchesInString:self options:0 range:NSMakeRange(0, self.length)];
	NSString *resultString = self.copy;
	if (!error && arrayofRange.count != 0) {
		for (NSTextCheckingResult *result in arrayofRange) {
			NSString *colorSring = [self substringWithRange:result.range];
			if ([colorSring hasPrefix:@"#"]) {
				colorSring = [colorSring substringFromIndex:1];
			}
			resultString = [resultString stringByReplacingCharactersInRange:result.range withString:colorSring];
		}
	}
	return resultString;
}

- (NSString *)kt_toArDateString {
	NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
	dateFormatter1.dateFormat = @"MM/dd";
	NSDate *date1 = [dateFormatter1 dateFromString:self];
	
	NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
	yearFormatter.dateFormat = @"MM/dd";
	yearFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ar"];
	NSString *yearString = [yearFormatter stringFromDate:date1];
	return yearString;
}

- (NSAttributedString *)kt_highLightedEmailWithColor:(UIColor *)color {
	return [NSString kt_distinguishWithString:self pattern:kEmailRegex highLightColor:color];
}

+ (NSAttributedString *)kt_distinguishWithString:(NSString *)string pattern:(NSString *)pattern highLightColor:(UIColor *)color {
	NSError *error;
	NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
	
	NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
	if (!error && regexps != nil) {
		[regexps enumerateMatchesInString:string options:0 range:string.kt_rangeOfAll usingBlock:^(NSTextCheckingResult *_Nullable result, NSMatchingFlags flags, BOOL *_Nonnull stop) {
			NSRange stringRange = result.range;
			//添加下划线
			/**
			 NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
			 [str addAttributes:attribtDic range:stringRange];
			 */
			//设置相关富文本显示颜色
			[str addAttribute:NSForegroundColorAttributeName value:color range:stringRange];
		}];
	}
	return str.copy;
}

@end
