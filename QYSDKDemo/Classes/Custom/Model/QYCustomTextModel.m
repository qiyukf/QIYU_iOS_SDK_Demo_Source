//
//  QYCustomTextModel.m
//  YSFDemo
//
//  Created by liaosipei on 2018/11/26.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "QYCustomTextModel.h"
#import "QYCustomKeyDefine.h"
#import "QYCustomTextMessage.h"

@implementation QYCustomTextModel

- (NSString *)cellReuseIdentifier {
    return @"QYCustomTextModelReuseIdentifier";
}

- (CGSize)contentSizeForBubbleMaxWidth:(CGFloat)bubbleMaxWidth {
    if (![self.message isKindOfClass:[QYCustomTextMessage class]]) {
        return CGSizeZero;
    }
    QYCustomTextMessage *textMsg = (QYCustomTextMessage *)self.message;
    
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:16.0f]};
    CGSize size = [textMsg.text boundingRectWithSize:CGSizeMake(bubbleMaxWidth, 1000)
                                             options:0
                                          attributes:dict
                                             context:nil].size;
    
    return CGSizeMake(size.width + 2, size.height + 5);
}

- (UIEdgeInsets)contentViewInsets {
    return UIEdgeInsetsMake(10, 10 + 4, 10, 10);
}

@end
