//
//  NVSI420Frame.h
//  nvs
//
//  Created by fenric on 15/4/17.
//  Copyright (c) 2015年 yixin.dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NVSI420Frame : NSObject

@property (nonatomic, readonly) int width;
@property (nonatomic, readonly) int height;
@property (nonatomic, readonly) UInt8 *data;
@property (nonatomic, readonly) int dataLength;

- (id)initWithWidth:(int)w height:(int)h;

@end
