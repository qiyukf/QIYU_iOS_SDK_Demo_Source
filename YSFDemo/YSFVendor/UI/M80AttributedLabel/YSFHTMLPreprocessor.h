//
//  HTMLPreprocessor.h
//  yixin_iphone
//
//  Created by Xuhui on 15/1/13.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YSFHTMLPreprocessorProtocol <NSObject>

- (NSString *)process:(NSString *)htmlString;

@end

@interface YSFPAHTMLPreprocessor : NSObject <YSFHTMLPreprocessorProtocol>

@end
