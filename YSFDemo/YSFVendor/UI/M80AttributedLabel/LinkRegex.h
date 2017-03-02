//
//  LinkRegex.h
//  yixin_iphone
//
//  Created by amao on 13-9-21.
//  Copyright (c) 2013年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSFLinkRegex : NSObject
+ (YSFLinkRegex *)regex;

//检测link
- (void)enumerateMatchesInString: (NSString *)plainText
                           range: (NSRange)range
                      usingBlock: (void (^)(NSString *text, NSRange range, BOOL *stop))block;


//检测电话号码
- (void)enumeratePhoneNumberInString: (NSString *)plainText
                               range: (NSRange)range
                          usingBlock: (void (^)(NSString *text, NSRange range, BOOL *stop))block;

@end
