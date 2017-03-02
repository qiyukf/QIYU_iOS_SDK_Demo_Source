//
//  NSDictionary+YSFJson.h
//  NIM
//
//  Created by amao on 13-7-12.
//  Copyright (c) 2013年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YSFJson)
- (NSString *)ysf_jsonString:(NSString *)key;

- (NSDictionary *)ysf_jsonDict:(NSString *)key;
- (NSArray *)ysf_jsonArray:(NSString *)key;
- (NSArray *)ysf_jsonStringArray:(NSString *)key;


- (BOOL)ysf_jsonBool:(NSString *)key;
- (NSInteger)ysf_jsonInteger:(NSString *)key;
- (NSUInteger)ysf_jsonUInteger:(NSString *)key;
- (long long)ysf_jsonLongLong:(NSString *)key;
- (unsigned long long)ysf_jsonUnsignedLongLong:(NSString *)key;

- (double)ysf_jsonDouble:(NSString *)key;
@end
