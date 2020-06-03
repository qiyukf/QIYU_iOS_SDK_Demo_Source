//
//  NIMMessagePinNotifyCallback.h
//  NIMLib
//
//  Created by 丁文超 on 2020/4/9.
//  Copyright © 2020 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

namespace nimbiz {

    struct IAsynCallbackParam;
    void   CallbackAddMessagePin(struct IAsynCallbackParam *callbackParam);  // 添加PIN的在线通知
    void   CallbackRemoveMessagePin(struct IAsynCallbackParam *callbackParam);   // 删除PIN在线通知
    void   CallbackUpdateMessagePin(struct IAsynCallbackParam *callbackParam);   // 更新PIN在线通知

}
