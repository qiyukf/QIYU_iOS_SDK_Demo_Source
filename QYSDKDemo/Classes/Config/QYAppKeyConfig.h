//
//  QYAppKeyConfig.h
//  YSFDemo
//
//  Created by liaosipei on 2020/2/19.
//  Copyright © 2020 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QYAppKeyConfig : NSObject <NSCoding>

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, assign) BOOL isFusion;

@end

