//
//  NSAttributedString+HTML.h
//  yixin_iphone
//
//  Created by Xuhui on 15/1/11.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (YSFHTML)

- (instancetype)initWithHTMLString:(NSString *)str defautAttributes:(NSDictionary *)attributes;

@end
