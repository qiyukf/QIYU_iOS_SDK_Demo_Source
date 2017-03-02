//
//  YSFAPI.h
//  YSFSDK
//
//  Created by amao on 8/26/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YSFApiProtocol <NSObject>

- (NSString *)apiPath;

- (NSDictionary *)params;

- (id)dataByJson:(NSDictionary *)json
           error:(NSError **)error;

@optional
- (id)dataByStr:(NSString*)str
          error:(NSError **)error;
@end


typedef void(^YSFApiBlock)(NSError *error,id returendObject);

@interface YSFHttpApi : NSObject
+ (void)post:(id<YSFApiProtocol>)api
  completion:(YSFApiBlock)block;

+ (void)get:(id<YSFApiProtocol>)api
 completion:(YSFApiBlock)block;
@end

