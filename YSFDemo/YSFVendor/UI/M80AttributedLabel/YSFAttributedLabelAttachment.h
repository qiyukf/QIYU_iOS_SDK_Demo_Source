//
//  YSFAttributedLabelAttachment.h
//  YSFAttributedLabel
//
//  Created by amao on 13-8-31.
//  Copyright (c) 2013年 www.xiangwangfeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFAttributedLabelDefines.h"

void YSFDeallocCallback(void* ref);
CGFloat YSFAscentCallback(void *ref);
CGFloat YSFDescentCallback(void *ref);
CGFloat YSFWidthCallback(void* ref);

@interface YSFAttributedLabelAttachment : NSObject
@property (nonatomic,strong)    id                  content;
@property (nonatomic,assign)    UIEdgeInsets        margin;
@property (nonatomic,assign)    YSFImageAlignment   alignment;
@property (nonatomic,assign)    CGFloat             fontAscent;
@property (nonatomic,assign)    CGFloat             fontDescent;
@property (nonatomic,assign)    CGSize              maxSize;


+ (YSFAttributedLabelAttachment *)attachmentWith: (id)content
                                          margin: (UIEdgeInsets)margin
                                       alignment: (YSFImageAlignment)alignment
                                         maxSize: (CGSize)maxSize;

- (CGSize)boxSize;

@end
