//
//  NSURL+WebView.h
//  yixin_iphone
//
//  Created by amao on 12/4/13.
//  Copyright (c) 2013 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (YSFWebView)
- (BOOL)ysf_isYixinURLScheme;

- (BOOL)ysf_isItunesURL;

- (BOOL)ysf_isBindOK;

- (BOOL)ysf_isEquivalent:(NSURL *)aURL;

- (NSDictionary *)ysf_yxQuerys;

@end
