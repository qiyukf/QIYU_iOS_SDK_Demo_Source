//
//  iToast.h
//  eim_iphone
//
//  Created by zhou jezhee on 11/21/12.
//  Copyright (c) 2012 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kYSFToastPositionTop,
    kYSFToastPositionCenter,
    kYSFToastPositionBottom,
} YSFToastPosition;


@interface YSFiToast : NSObject
@property (strong, nonatomic) NSString  *toastText;

- (id)initWithText: (NSString *)text;
- (void)showAt:(YSFToastPosition)position duration:(double)duration;
- (void)showAtCenter:(CGPoint)center duration:(double)duration;
+ (YSFiToast *)makeToast: (NSString *)text;

@end

