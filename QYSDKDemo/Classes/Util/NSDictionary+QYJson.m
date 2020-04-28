//
//  NSDictionary+QYJson.m
//  NIM
//
//  Created by amao on 13-7-12.
//  Copyright (c) 2013年 Netease. All rights reserved.
//

#import "NSDictionary+QYJson.h"

@implementation NSDictionary (QYJson)

- (NSString *)qy_jsonString:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]])
    {
        return object;
    }
    else if([object isKindOfClass:[NSNumber class]])
    {
        return [object stringValue];
    }
    return nil;
}

- (NSDictionary *)qy_jsonDict:(NSString *)key
{
    id object = [self objectForKey:key];
    return [object isKindOfClass:[NSDictionary class]] ? object : nil;
}


- (NSArray *)qy_jsonArray:(NSString *)key
{
    id object = [self objectForKey:key];
    return [object isKindOfClass:[NSArray class]] ? object : nil;

}

- (NSArray *)qy_jsonStringArray:(NSString *)key
{
    NSMutableArray *result = [NSMutableArray array];
    NSArray *array = [self qy_jsonArray:key];
    BOOL invalid = NO;
    for (id item in array)
    {
        if ([item isKindOfClass:[NSString class]]) {
            [result addObject:item];
        }
        else if([item isKindOfClass:[NSNumber class]])
        {
            [result addObject:[item stringValue]];
        }
        else
        {
            invalid = YES;
            break;
        }
    }
    return invalid ? nil : result;

}

- (BOOL)qy_jsonBool:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object boolValue];
    }
    return NO;
}

- (NSInteger)qy_jsonInteger:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object integerValue];
    }
    return 0;
}

- (NSUInteger)qy_jsonUInteger:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object unsignedIntegerValue];
    }
    return 0;
}

- (long long)qy_jsonLongLong:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object longLongValue];
    }
    return 0;
}

- (unsigned long long)qy_jsonUnsignedLongLong:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNumber class]])
    {
        return [object unsignedLongLongValue];
    }
    if ([object isKindOfClass:[NSString class]]) {
        return [object longLongValue];
    }
    return 0;
}


- (double)qy_jsonDouble: (NSString *)key{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]] ||
        [object isKindOfClass:[NSNumber class]])
    {
        return [object doubleValue];
    }
    return 0;
}

@end
