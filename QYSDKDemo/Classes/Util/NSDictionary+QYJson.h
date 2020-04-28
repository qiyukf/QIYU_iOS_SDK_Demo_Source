//
//  NSDictionary+QYJson.h
//  NIM
//
//  Created by amao on 13-7-12.
//  Copyright (c) 2013年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (QYJson)
- (NSString *)qy_jsonString:(NSString *)key;

- (NSDictionary *)qy_jsonDict:(NSString *)key;
- (NSArray *)qy_jsonArray:(NSString *)key;
- (NSArray *)qy_jsonStringArray:(NSString *)key;


- (BOOL)qy_jsonBool:(NSString *)key;
- (NSInteger)qy_jsonInteger:(NSString *)key;
- (NSUInteger)qy_jsonUInteger:(NSString *)key;
- (long long)qy_jsonLongLong:(NSString *)key;
- (unsigned long long)qy_jsonUnsignedLongLong:(NSString *)key;

- (double)qy_jsonDouble:(NSString *)key;
@end
