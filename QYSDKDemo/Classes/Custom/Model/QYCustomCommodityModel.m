//
//  QYCustomTicketModel.m
//  YSFDemo
//
//  Created by liaosipei on 2019/11/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "QYCustomCommodityModel.h"
#import <QYSDK/QYCustomSDK.h>

@implementation QYCustomCommodityModel

- (NSString *)cellReuseIdentifier {
    return @"QYCustomTicketModelReuseIdentifier";
}

- (CGSize)contentSizeForBubbleMaxWidth:(CGFloat)bubbleMaxWidth {
    if (![self.message isKindOfClass:[QYCustomCommodityInfo class]]) {
        return CGSizeZero;
    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 180);
}

- (BOOL)needShowAvatar {
    return NO;
}

- (BOOL)needShowBubble {
    return NO;
}

@end
