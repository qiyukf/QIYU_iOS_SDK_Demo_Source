//
//  NSDictionary+YSF.h
//  YSFSDK
//
//  Created by amao on 8/27/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YSF)
- (NSData *)ysf_postParam;

- (NSString *)ysf_getParam;

- (NSDictionary *)ysf_formattedDict;

- (NSString *)ysf_toUTF8String;

@end
