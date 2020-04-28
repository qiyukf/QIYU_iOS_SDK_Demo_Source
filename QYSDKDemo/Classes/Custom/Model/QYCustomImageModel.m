//
//  QYCustomImageModel.m
//  YSFDemo
//
//  Created by liaosipei on 2018/11/28.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "QYCustomImageModel.h"
#import "QYCustomKeyDefine.h"
#import "QYCustomImageMessage.h"

@implementation QYCustomImageModel

- (NSString *)cellReuseIdentifier {
    return @"QYCustomImageModelReuseIdentifier";
}

- (CGSize)contentSizeForBubbleMaxWidth:(CGFloat)bubbleMaxWidth {
    if (![self.message isKindOfClass:[QYCustomImageMessage class]]) {
        return CGSizeZero;
    }
    QYCustomImageMessage *imgMsg = (QYCustomImageMessage *)self.message;
    if (imgMsg.showImage) {
        return CGSizeMake(120, 110);
    } else {
        return CGSizeMake(120, 60);
    }
}

- (UIEdgeInsets)contentViewInsets {
    return UIEdgeInsetsMake(5, 5, 5, 9);
}

@end
