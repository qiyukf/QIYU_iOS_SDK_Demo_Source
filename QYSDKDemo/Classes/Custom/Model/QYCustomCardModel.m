//
//  QYCustomCardModel.m
//  YSFDemo
//
//  Created by liaosipei on 2018/11/29.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "QYCustomCardModel.h"
#import "QYCustomCardMessage.h"

@implementation QYCustomCardModel

- (NSString *)cellReuseIdentifier {
    return @"QYCustomCardModelReuseIdentifier";
}

- (CGSize)contentSizeForBubbleMaxWidth:(CGFloat)bubbleMaxWidth {
    if (![self.message isKindOfClass:[QYCustomCardMessage class]]) {
        return CGSizeZero;
    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 200);
}

- (BOOL)needShowAvatar {
    return NO;
}

- (BOOL)needShowBubble {
    return NO;
}

@end
