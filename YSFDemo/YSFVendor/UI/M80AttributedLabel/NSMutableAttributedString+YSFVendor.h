//
//  NSMutableAttributedString+YSF.h
//  YSFAttributedLabel
//
//  Created by amao on 13-8-31.
//  Copyright (c) 2013年 www.xiangwangfeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

extern NSString *const kYSFCustomAttributeAttributeName;
extern NSString *const kYSFCustomLinkAttributeName;
extern NSString *const kYSFCustomAttachmentAttributeName;

#define YSF_UNICODE_OBJECT_PLACEHOLDER @"\ufffc"

@interface NSMutableAttributedString (YSFVendor)

- (void)ysf_setTextColor:(UIColor*)color;
- (void)ysf_setTextColor:(UIColor*)color range:(NSRange)range;

- (void)ysf_setFont:(UIFont*)font;
- (void)ysf_setFont:(UIFont*)font range:(NSRange)range;

- (void)ysf_setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier;
- (void)ysf_setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier
                    range:(NSRange)range;

@end
