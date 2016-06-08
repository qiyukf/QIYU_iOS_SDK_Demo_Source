//
//  YSFGalleryViewController.h
//  NIMDemo
//
//  Created by ght on 15-2-3.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSFPresentViewController.h"

typedef UIView * (^QueryMessageContentViewCallback)(id messageId);


@interface YSFGalleryItem : NSObject

@property (nonatomic,copy)  NSString    *thumbPath;
@property (nonatomic,copy)  NSString    *imageURL;
@property (nonatomic,copy)  NSString    *name;
@property (nonatomic,weak)  id  messageId;

@end


@interface YSFGalleryViewController : YSFPresentViewController

- (instancetype)initWithCurrentIndex:(NSUInteger)currentIndex allItems:(NSMutableArray *) allItems callback:(QueryMessageContentViewCallback) cb;

@end




