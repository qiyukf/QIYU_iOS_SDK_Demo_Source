//
//  NSData+QY.h
//  YSFSDK
//
//  Created by amao on 8/27/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (YSF)
- (NSString *)qy_md5;

- (NSData *)qy_gzippedData;

- (NSData *)qy_gunzippedData;

- (NSData *)qy_gzippedDataWithCompressLevel:(float)level;

@end
