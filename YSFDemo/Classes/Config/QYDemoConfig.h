//
//  YSFDemoConfig.h
//  YSFDemo
//
//  Created by amao on 9/1/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYDemoConfig : NSObject
+ (instancetype)sharedConfig;
@property (nonatomic,copy)  NSString    *appKey;
@property (nonatomic,copy)  NSString    *appName;
- (void)setEnvironment:(NSInteger)isTest;
@end
