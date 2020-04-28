//
//  YSFUserTableViewController.h
//  YSFDemo
//
//  Created by amao on 9/9/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

extern BOOL isTestMode;

typedef NS_ENUM(NSInteger, QYUserInfoType) {
    QYUserInfoTypeNone,     //匿名帐号
    QYUserInfoTypeA,        //帐号A
    QYUserInfoTypeB,        //帐号B
    QYUserInfoTypeC,        //帐号C
    QYUserInfoTypeD,        //帐号D
    QYUserInfoTypeE,        //帐号E
    QYUserInfoTypeCustom,   //自定义帐号
};


@interface QYUserTableViewController : UIViewController

+ (NSString *)selectUserInfoByID:(NSString *)userId;

@end
