//
//  QYAppKeyConfig.m
//  YSFDemo
//
//  Created by liaosipei on 2020/2/19.
//  Copyright © 2020 Netease. All rights reserved.
//

#import "QYAppKeyConfig.h"

@implementation QYAppKeyConfig

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_appKey forKey:@"appkey"];
    [aCoder encodeObject:@(_isFusion) forKey:@"fusion"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _appKey = [aDecoder decodeObjectForKey:@"appkey"];
        _isFusion = [[aDecoder decodeObjectForKey:@"fusion"] boolValue];
    }
    return self;
}

@end
