//
//  ALAssetsLibraryAccessor.h
//  yixin_iphone
//
//  Created by huangyaowu on 13-7-2.
//  Copyright (c) 2013年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "YXManager.h"

@class YSFALAssetsLibrary;

@interface YSFALAssetsLibraryAccessor : NSObject {
    YSFALAssetsLibrary *assetsLibrary_;
}

+ (YSFALAssetsLibraryAccessor *)sharedInstance;

- (YSFALAssetsLibrary *)assetsLibrary;

- (void)refreshAssetsLibrary;

@end
