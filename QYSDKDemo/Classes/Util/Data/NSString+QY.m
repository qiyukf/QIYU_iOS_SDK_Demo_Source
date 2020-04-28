//
//  NSString+QY.m
//  YSFSDK
//
//  Created by amao on 8/27/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NSString+QY.h"
#import "NSData+QY.h"

@implementation NSString (QY)

- (NSString *)unescapeHtml
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&#39;" withString:@"\'"];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return str;
}

- (NSString *)qy_md5
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data qy_md5];
}

- (NSString *)qy_StringByAppendingApiPath:(NSString *)apiPath
{
    if ([self hasSuffix:@"/"] && [apiPath hasPrefix:@"/"])
    {
        return [NSString stringWithFormat:@"%@%@",self,[apiPath substringFromIndex:1]];
    }
    else if (![self hasSuffix:@"/"] && ![apiPath hasPrefix:@"/"])
    {
        return [NSString stringWithFormat:@"%@/%@",self,apiPath];
    }
    else
    {
        return [self stringByAppendingString:apiPath];
    }
}

- (NSString *)qy_urlEncodedString
{
    static NSString * const kAFLegalCharactersToBeEscaped = @"?!@#$^&%*+=,:;'\"`<>()[]{}/\\|~ ";
    
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (__bridge  CFStringRef)self,
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)kAFLegalCharactersToBeEscaped,
                                                                                 kCFStringEncodingUTF8);
    
}

- (NSString *)qy_stringByDeletingPictureResolution{
    NSString *doubleResolution  = @"@2x";
    NSString *tribleResolution = @"@3x";
    NSString *fileName = self.stringByDeletingPathExtension;
    NSString *res = [self copy];
    if ([fileName hasSuffix:doubleResolution] || [fileName hasSuffix:tribleResolution]) {
        res = [fileName substringToIndex:fileName.length - 3];
        if (self.pathExtension.length) {
            res = [res stringByAppendingPathExtension:self.pathExtension];
        }
    }
    return res;
}

- (NSString *)qy_formattedURLString
{
    NSString *url = self;
    NSString *low = [url lowercaseString];
    NSRange commandRange = [low rangeOfString:@"://"];
    NSRange tagRange = [low rangeOfString:@"/"];
    if (commandRange.location == NSNotFound ||
        tagRange.location < commandRange.location) {
        url = [NSString stringWithFormat:@"http://%@", url];
    }
    
    return url;
}

- (NSDictionary *)qy_paramsFromString
{
    NSString *str = self;
    NSMutableDictionary *pairs			= [NSMutableDictionary dictionary];
    NSCharacterSet		*delimiterSet	= [NSCharacterSet characterSetWithCharactersInString:@"&"];
    NSScanner			*scanner		= [[NSScanner alloc] initWithString:str];
    
    while (![scanner isAtEnd]) {
        NSString *pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
        
        if (kvPair.count == 2) {
            NSString	*key	= [[kvPair objectAtIndex:0] ysf_urldecode];
            NSString	*value	= [[kvPair objectAtIndex:1] ysf_urldecode];
            if ([key length] && [value length])
            {
                [pairs setObject:value
                          forKey:key];
            }
        }
    }
    
    return pairs.count > 0 ? pairs : nil;
}

- (NSString *)ysf_urldecode {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (CGSize)qy_stringSizeWithFont:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}


- (NSDictionary *)qy_toDict
{
    NSData *data    = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return nil;
    }
    id dict = [NSJSONSerialization JSONObjectWithData:data
                                               options:0
                                                 error:nil];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return dict;
}

- (NSArray *)qy_toArray
{
    NSData *data    = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return nil;
    }
    id array = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:nil];
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    return array;
}

- (NSString *)qy_trim
{
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)qy_https
{
    static NSString *nosHost = @"nos.netease.com";
    static NSInteger nosHostItemsCount = 3;
    NSString *result = self;
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:self];
    NSString *scheme = [components scheme];
    if ([scheme length]  &&
        [scheme caseInsensitiveCompare:@"http"] == NSOrderedSame)
    {
        NSString *host = [[components host] lowercaseString];
        if ([host length] > [nosHost length] &&
            [host hasSuffix:nosHost])
        {
            NSArray *items = [host componentsSeparatedByString:@"."];
            NSUInteger count = [items count];
            if (count > nosHostItemsCount)
            {
                NSArray *pathItems = [items subarrayWithRange:NSMakeRange(0, count - nosHostItemsCount)];
                NSString *path = [pathItems componentsJoinedByString:@"/"];
                
                //到这里就解析完毕,设置新的host和 path
                components.path = [NSString stringWithFormat:@"/%@%@",path,components.path];
                components.host = nosHost;
            }
            else
            {
                //YSFLogErr(@"invalid parser %@ for https",self);
            }
        }
        
        
        components.scheme = @"https";
        result = components.URL.absoluteString;
        
    }
    
    return result;
}

- (NSString *)qy_stringByAppendExt:(NSString *)ext
{
    return [ext length]? [self stringByAppendingFormat:@".%@",ext] : self;
}

- (BOOL)qy_isPureInteger{
    NSScanner* scan = [NSScanner scannerWithString:self];
    NSInteger val;
    return[scan scanInteger:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)qy_isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}



- (NSString *)qy_urlEncodeString{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

- (NSString *)qy_urlDecodeString{
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)self,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}


/**
 字符串剔除重复的空格和回车换行

 @return 去除掉重复空格和回车换行后的string
 */
- (NSString*)qy_stringByRemoveRepeatedWhitespaceAndNewline {
    NSCharacterSet *whiteSpaces = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSPredicate *noEmptyPred = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *wordArray = [self componentsSeparatedByCharactersInSet:whiteSpaces];
    NSArray *filteredArray = [wordArray filteredArrayUsingPredicate:noEmptyPred];
    NSString *filteredString = [filteredArray componentsJoinedByString:@" "];
    
    return filteredString;
}



@end
