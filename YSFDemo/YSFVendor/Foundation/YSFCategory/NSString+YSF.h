//
//  NSString+YSF.h
//  YSFSDK
//
//  Created by amao on 8/27/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (YSF)

- (NSString *)unescapeHtml;

- (NSString *)ysf_md5;

- (NSString *)ysf_StringByAppendingApiPath:(NSString *)apiPath;

- (NSString *)ysf_urlEncodedString;

- (NSString *)ysf_stringByDeletingPictureResolution;

- (NSString *)ysf_formattedURLString;

- (NSDictionary *)ysf_paramsFromString;

- (CGSize)ysf_stringSizeWithFont:(UIFont *)font;

- (NSDictionary *)ysf_toDict;

- (NSArray *)ysf_toArray;

- (NSString *)ysf_trim;

- (NSString *)ysf_https;

@end
