//
//  YSFAttributedLabelURL.h
//  YSFAttributedLabel
//
//  Created by amao on 13-8-31.
//  Copyright (c) 2013年 www.xiangwangfeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFAttributedLabelDefines.h"

@interface YSFAttributedLabelURL : NSObject
@property (nonatomic,strong)    id      linkData;
@property (nonatomic,assign)    NSRange range;
@property (nonatomic,strong)    UIColor *color;

+ (YSFAttributedLabelURL *)urlWithLinkData: (id)linkData
                                     range: (NSRange)range
                                     color: (UIColor *)color;


+ (NSArray *)detectLinks: (NSString *)plainText
              detectLink: (BOOL)detectLink
       detectPhoneNumber: (BOOL)detectPhoneNumber;

+ (void)setCustomDetectMethod:(YSFCustomDetectLinkBlock)block;
@end


