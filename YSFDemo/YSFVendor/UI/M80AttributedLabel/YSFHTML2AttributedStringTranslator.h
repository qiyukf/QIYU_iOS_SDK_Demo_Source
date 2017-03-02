//
//  HTML2AttributedStringTranslator.h
//  yixin_iphone
//
//  Created by Xuhui on 15/1/11.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YSFHTMLParserProtocol;

@interface YSFHTML2AttributedStringTranslator : NSObject

@property (nonatomic, strong) id<YSFHTMLParserProtocol> parser;
@property (nonatomic, strong) NSDictionary *defaultAttributes;

- (instancetype)initWithHTMLString:(NSString *)str;

- (NSAttributedString *)translate;

@end
