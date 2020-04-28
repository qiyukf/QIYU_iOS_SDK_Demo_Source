//
//  NSString+QY.h
//  YSFSDK
//
//  Created by amao on 8/27/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (QY)

- (NSString *)unescapeHtml;

- (NSString *)qy_md5;

- (NSString *)qy_StringByAppendingApiPath:(NSString *)apiPath;

- (NSString *)qy_urlEncodedString;

- (NSString *)qy_stringByDeletingPictureResolution;

- (NSString *)qy_formattedURLString;

- (NSDictionary *)qy_paramsFromString;

- (CGSize)qy_stringSizeWithFont:(UIFont *)font;

- (NSDictionary *)qy_toDict;

- (NSArray *)qy_toArray;

- (NSString *)qy_trim;

- (NSString *)qy_https;


- (NSString *)qy_stringByAppendExt:(NSString *)ext;


//判断是否为纯整形
- (BOOL)qy_isPureInteger;

//判断是否为浮点形：
- (BOOL)qy_isPureFloat;

- (NSString *)qy_urlEncodeString;

- (NSString *)qy_urlDecodeString;

//字符串剔除重复的空格和回车换行
- (NSString*)qy_stringByRemoveRepeatedWhitespaceAndNewline;

@end
