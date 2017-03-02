//
//  NSString+WebView.h
//  yixin_iphone
//
//  Created by amao on 12/4/13.
//  Copyright (c) 2013 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YSFWebView)
- (NSString *)ysf_formattedURLString;   //format URL，如果url不带scheme就自动加上http://

- (NSString *)ysf_URLEncodedString;

- (NSDictionary*)ysf_paramsFromString;
@end
