//
//  YSFAddAppKeyViewController.h
//  YSFDemo
//
//  Created by amao on 9/24/15.
//  Copyright © 2015 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol QYAppKeyAddDelegate <NSObject>
- (void)onAddAppKey:(NSString *)appkey isTesting:(BOOL)isTesting;
@end

@interface QYAddAppKeyViewController : UIViewController
@property (nonatomic,weak)  id<QYAppKeyAddDelegate>    delegate;
@end
