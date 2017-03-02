//
//  YSFAttributedLabelDefines.h
//  YSFAttributedLabel
//
//  Created by amao on 13-8-31.
//  Copyright (c) 2013年 www.xiangwangfeng.com. All rights reserved.
//

#ifndef YSFAttributedLabel_YSFAttributedLabelDefines_h
#define YSFAttributedLabel_YSFAttributedLabelDefines_h

typedef enum
{
    YSFImageAlignmentTop,
    YSFImageAlignmentCenter,
    YSFImageAlignmentBottom
} YSFImageAlignment;

@class YSFAttributedLabel;

@protocol YSFAttributedLabelDelegate <NSObject>
- (void)ysfAttributedLabel:(YSFAttributedLabel *)label
             clickedOnLink:(id)linkData;

@end

typedef NSArray *(^YSFCustomDetectLinkBlock)(NSString *text);

//如果文本长度小于这个值,直接在UI线程做Link检测,否则都dispatch到共享线程
#define YSFMinAsyncDetectLinkLength 50

#define YSFIOS7 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)

#endif
