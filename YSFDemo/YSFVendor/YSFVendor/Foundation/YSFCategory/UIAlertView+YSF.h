//
//  UIAlertView+YSF.h
//  YSFSDK
//
//  Created by amao on 9/7/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <UIKit/UIKit.h>

typedef void (^YSFUIAlertViewBlock)(NSInteger index);

@interface UIAlertView (YSF)
- (void)ysf_showWithCompletion:(YSFUIAlertViewBlock)block;
@end
