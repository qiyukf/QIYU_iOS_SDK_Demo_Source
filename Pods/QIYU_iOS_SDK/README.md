# 网易七鱼 iOS SDK 开发指南

## 简介

网易七鱼 iOS SDK 是客服系统访客端的解决方案，既包含了客服聊天逻辑管理，也提供了聊天界面，开发者可方便的将客服功能集成到自己的 App 中。iOS SDK 支持 iOS7 以上版本，同时支持 iPhone、iPad，同时支持竖屏和横屏。

## 将SDK导入工程（必须）

### 手动集成

* 下载 QY SDK，得到3个 .a 文件、 QYResouce 文件夹和 ExportHeaders 文件夹，将他们导入工程。
* 添加 QY SDK 依赖库：

  * UIKit.framework
  * AVFoundation.framework
  * SystemConfiguration.framework
  * MobileCoreService.framework
  * CoreTelephony.framework
  * CoreText.framework
  * CoreMedia.framework
  * AudioToolbox.framework
  * Photos.framework
  * AssetsLibrary.framework
  * CoreMotion.framework
  * libz.tbd
  * libc++.tbd
  * libsqlite3.0.tbd
  * libxml2.tbd

* 在 Build Settings -> Other Linker Flags 中添加 -ObjC 。

### CocoaPods集成

在 Podfile 文件中加入：

```objective-c
pod    'QIYU_iOS_SDK',    '~> x.x.x'
```
"x.x.x" 代表版本号，比如想要使用 3.0.0 版本，可加入如下代码：

```objective-c
pod    'QIYU_iOS_SDK',    '~> 3.0.0'
```

如果无法安装 SDK 最新版本，运行以下命令更新本地的 CocoaPods 仓库列表：

```objective-c
pod repo update
```

### 解决符号重复的冲突

从 v3.1.0 开始，没有 QIYU_iOS_SDK_Exclude_Libcrypto、QIYU_iOS_SDK_Exclude_NIM 版本了，统一使用 QIYU_iOS_SDK，此 SDK 中将各个第三方库独立出来了，总共3个.a：libQYSDK.a、libcrypto.a、libevent.a。

1. 如果您同时使用了网易云信 iOS SDK，请只导入 libQYSDK.a，不要导入其他两个 .a 文件。
2. 如果您同时使用了 OpenSSL 库，或者您集成的其它静态库使用了 OpenSSL 库（比如支付宝 SDK ），请只导入 libQYSDK.a、libevent.a，不要导入 libcrypto.a。
3. 如果是其他情况的冲突，请根据实际情况有选择的导入 libevent.a、libcrypto.a。

### https相关

v3.1.3 版本开始，SDK 已经全面支持 https，但是聊天消息中可能存在链接，点击链接会用 UIWebView 打开，链接地址有可能是 http 的，为了能够正常打开，需要增加配置项。在 Info.plist 中加入以下内容：

```objective-c
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSAllowsArbitraryLoadsInWebContent</key>
    <true/>
</dict>
```

加了这些配置项，在 iOS9 下，会放开所有 http 请求，在 iOS10 下，因 iOS10 规定，如果设置了 NSAllowsArbitraryLoadsInWebContent，就会忽略 NSAllowsArbitraryLoads，所以效果是只允许 UIWebView 中使用 http。

### iOS10权限设置

在 Info.plist 中加入以下内容：

```objective-c
<key>NSPhotoLibraryUsageDescription</key>
<string>需要照片权限</string>
<key>NSCameraUsageDescription</key>
<string>需要相机权限</string>
<key>NSMicrophoneUsageDescription</key>
<string>需要麦克风权限</string>
```

如果不加，会 crash。

### iOS11权限设置

在 Info.plist 中加入以下内容：

```objective-c
<key>NSPhotoLibraryAddUsageDescription</key>
<string>App需要您的同意,才能添加照片到相册</string>
```

如果不加，会 crash。请注意，iOS11 需要的是 NSPhotoLibraryAddUsageDescription，跟 iOS10 需要的 NSPhotoLibraryUsageDescription 不一样。

### iOS11兼容性

请使用 v3.11.0 以上的版本。

### 其它说明

* 在需要使用 SDK 的地方 import "QYSDK.h"。
* 由于 SDK 是静态库，且为了方便开发者使用，我们将 armv7、arm64、i386、x86_64 平台的静态库合并成一个 Fat Library，导致整个 SDK 比较大。但实际编译后大约只会增加 App 4-5M 大小。

### 可能遇到的问题1
1. 无法用 CocoaPods 下载到最新的 SDK
   - 有可能是使用了淘宝源，尝试使用默认源。

## 初始化SDK（必须）

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ......
    
    [[QYSDK sharedSDK] registerAppId:AppKey appName:App名称];
    
    ......
    
    return YES;
}
```
1. AppKey 可以在 管理后台 -> 设置 -> App接入 -> 2. App Key 找到。
AppName 对应管理后台添加一个 App 时填写的 “App 名称”。如果管理后台还没有添加 App，请及时添加。如果 AppName 跟管理后台 App 的 “App 名称” 不一致，会导致无法正常收到苹果的消息推送。
2. 一般在 “application: didFinishLaunchingWithOptions:” 这个方法里面调用 “registerAppId: appName:” 方法，如果在其他时刻调用，在调用之前，就等于没有在使用七鱼的服务。在整个软件运行期间必须只调用一次，如果调用多次，将会有严重的不可预测的问题。

## 集成聊天组件（必须）

```objective-c
[[QYSDK sharedSDK] sessionViewController];
```

应用层获取此 sessionViewController 之后，必须嵌入到 UINavigationController 中，便可以获得聊天窗口的UI以及所有功能。 sessionViewController 只会使用到导航栏的 self.navigationItem.title 和 self.navigationItem.rightBarButtonItem。self.navigationItem.title 放置标题栏； self.navigationItem.rightBarButtonItem 放置"人工客服"、“评价”等入口。必须注意， 不能在 sessionViewController 外层套其他 viewController 之后再嵌入到 UINavigationcontroller。

### 集成方式一

如果调用代码所在的 viewController 在 UINavigationController 中，可如下方式集成：

```objective-c
QYSource *source = [[QYSource alloc] init];
source.title = @"七鱼金融";
source.urlString = @"https://8.163.com/";
QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
sessionViewController.sessionTitle = @"七鱼金融";
sessionViewController.source = source;
sessionViewController.hidesBottomBarWhenPushed = YES;
[self.navigationController pushViewController:sessionViewController animated:YES];
```

### 集成方式二

如果调用代码所在的 viewController 不在 UINavigationController 中，可如下方式集成：

```objective-c
QYSource *source = [[QYSource alloc] init];
source.title = @"七鱼金融";
source.urlString = @"https://8.163.com/";
QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
sessionViewController.sessionTitle = @"七鱼金融";
sessionViewController.source = source;
UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sessionViewController];
[self presentViewController:nav animated:YES completion:nil];
```
一般来说，第二种方式需要在左上角加一个返回按钮，在 “initWithRootViewController:” 之前加上：

```objective-c
UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
sessionViewController.navigationItem.leftBarButtonItem = leftItem;
```

“onBack:” 的样例：

```objective-c
- (void)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
```

如果您的代码要求所有 viewController 继承某个公共基类，并且公共基类对 UINavigationController 统一做了某些处理，或者对 UINavigationController 做了自己的扩展，这种情况可能会导致集成之后存在某些问题；或者其他原因导致使用第一种方式集成会有问题；这些情况下，建议您使用第二种方式集成。

### 可能遇到的问题2
1. 进入访客聊天界面马上 crash
   - 检查 App 工程配置－> Build Phases -> copy Bundle Resources 里面有没有 QYResource.bundle；如果没有，必须加上。
2. 一直显示正在连接客服
   - 可能是 AppKey 填写错误。
3. 能否同时创建多个 sessionViewController
   - 不能，需要保持全局唯一。每次调用 [[QYSDK sharedSDK] sessionViewController] 会得到一个全新的 QYSessionViewController 对象，开发者需要保证此对象全局唯一，尽量避免循环引用导致的内存泄漏问题。
4. 怎么知道 sessionViewController 被 pop 了

   - 请参考 UINavigationControllerDelegate 中提供的转场函数：

     ```objective-c
     - (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;
     ```
5. sessionViewController 的导航栏可以自定义吗
   - 部分自定义。sessionViewController 会占用 self.navigationItem.title 和 self.navigationItem.rightBarButtonItem；navigationItem 的其它部分，比如 leftBarButtonItem 等，您可以根据需要做任何自定义。
6. 聊天界面可以自定义吗
   - 部分自定义。 具体可参考 QYCustomUIConfig 类，Demo 源码中也有相关样例代码。
7. 评价按钮为什么不能点
   - 请求到客服之后，评价按钮才能点。如果客服不在线或者排队中，是不能点的。
8. 键盘出现异常

   - 检查下 App 中是否用到了会影响全局的键盘处理，如果是这种情况，需要对 QYSessionViewController 做屏蔽。典型的比如第三方键盘库 IQKeyboardManager，如果用的是 IQKeyboardManager v4.0.4 以前的版本（不包括 v4.0.4 ），加入以下屏蔽代码：

     ```objective-c
     [[IQKeyboardManager sharedManager] disableDistanceHandlingInViewControllerClass:[QYSessionViewController class]];
     ```

   - 如果用的是 IQKeyboardManager v4.0.4 或以后的版本，加入以下屏蔽代码：

     ```objective-c
     [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[QYSessionViewController class]];
     ```
9. 如何强制竖屏

   - 如果您的 App 是横屏的，但是希望聊天界面是竖屏的，可以在 sessionViewController 所在的 UINavigationController 中实现以下方法，返回 UIInterfaceOrientationMaskPortrait 即可：

     ```objective-c
     - (UIInterfaceOrientationMask)supportedInterfaceOrientations {
         return UIInterfaceOrientationMaskPortrait;
     }
     ```

## 注销（必须）

```objective-c
[[QYSDK sharedSDK] logout:^{}];
```

应用层退出自己的账号时必须调用 SDK 的注销操作。该接口仅在用户注销账号或是账号过期等情况下调用，应避免频繁调用造成反复创建账号。

## 完成各项设置（可选）

### 会话管理类

#### 获取会话管理类

```objective-c
[[QYSDK sharedSDK] conversationManager];
```

返回的是会话管理类 QYConversationManager，通过这个类获得消息未读数、清除未读数、获取会话列表、设置 delegate 委托，通过此 delegate 还可监听消息未读数变化、会话列表变化及消息接收事件。

#### 获取消息未读数

```objective-c
[[[QYSDK sharedSDK] conversationManager] allUnreadCount];
```

此接口返回的消息未读数是总未读数，若想分别获取不同会话的消息未读数需获取会话列表。

#### 获取会话列表

```objective-c
[[[QYSDK sharedSDK] conversationManager] getSessionList];
```
返回结果是 QYSessionInfo 数组，QYSessionInfo.h 内容如下：

```objective-c
/**
 *  会话状态类型
 */
typedef NS_ENUM(NSInteger, QYSessionStatus) {
    QYSessionStatusNone,        //无
    QYSessionStatusWaiting,     //排队中
    QYSessionStatusInSession    //会话中
};

/**
 *  会话列表中的会话详情信息
 */
@interface QYSessionInfo : NSObject

/**
 *  会话最后一条消息文本
 */
@property (nonatomic, copy) NSString *lastMessageText;

/**
 *  消息类型
 */
@property (nonatomic, assign) QYMessageType lastMessageType;

/**
 *  会话未读数
 */
@property (nonatomic, assign) NSInteger unreadCount;

/**
 *  会话状态
 */
@property (nonatomic, assign) QYSessionStatus status;

/**
 *  会话最后一条消息的时间
 */
@property (nonatomic, assign) NSTimeInterval lastMessageTimeStamp;

/**
 *  是否存在垃圾词汇
 */
@property (nonatomic, assign) BOOL hasTrashWords;

@end
```

#### 监听消息未读数变化

需要遵循协议 QYConversationManagerDelegate，并设置会话管理类的 delegate 委托：

```objective-c
[[[QYSDK sharedSDK] conversationManager] setDelegate:self];
```

然后实现该 delegate 中的如下方法：

```objective-c
/**
 *  会话未读数变化
 *
 *  @param count 未读数
 */
- (void)onUnreadCountChanged:(NSInteger)count;
```

#### 监听会话列表变化

实现协议 QYConversationManagerDelegate 中的如下方法：

```objective-c
/**
 *  会话列表变化；非平台电商用户，只有一个会话项，平台电商用户，有多个会话项
 */
- (void)onSessionListChanged:(NSArray<QYSessionInfo *> *)sessionList;
```

#### 监听消息接收

实现协议 QYConversationManagerDelegate 中的如下方法：

```objective-c
/**
 *  接收消息
 */
- (void)onReceiveMessage:(QYMessageInfo *)message;
```

### APNS推送
* [制作推送证书并在管理后台配置](./iOS_apns.html "target=_blank")
* 初始化，注册推送服务 APNS；注意 iOS10 及以上系统推送相关 API 变化较大，可分系统做注册处理。

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ......
    
    //注册 APNS
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UIUserNotificationType types = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:types completionHandler:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
    ......
    
    return YES;
}
```

* 将获取到的 deviceToken 传给 SDK。

```objective-c
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    ......
    
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
    
    ......
}
```
#### 可能遇到的问题3
1. 无法正常推送

   - 检查管理后台 App接入 中是否配置过推送证书 p12 文件，此证书是否就是此 App bundle ID 关联的推送证书。

   - 检查初始化时填的 AppName 是否和管理后台 “添加一个App” 时填写的 “App名称” 一致。

   - 检查证书的线上、测试环境是否跟管理后台配置的相同。请注意，若您想同时在 Debug 包和 Release 包中均接收推送消息，应添加两个 App，分别填入不同的名称并上传线上环境和测试环境的证书，同时在注册 AppKey 的地方这样写代码：

    ```objective-c
    #if DEBUG
        [[QYSDK sharedSDK] registerAppId:Appkey appName:Debug包App名称];
    #else
        [[QYSDK sharedSDK] registerAppId:Appkey appName:Release包App名称];
    #endif
    ```

   - 检查 provision profile 是否包含了推送证书。

   - 检查推送证书中是否有 p12 文件。

   - 检查代码调试是否可以获取到 deviceToken。

   - 使用第三方推送工具检查是否可以正常推送，如果不能，说明可能是证书本身的问题。
2. 可以同时使用第三方推送工具吗
   - 可以同时使用第三方推送工具和 SDK 的消息推送，两者可以共存，不会有任何冲突。
3. 能否区分出哪些推送消息是来自七鱼的
   - 所有来自七鱼的推送消息中 payload 都带有 "nim:1"，通过这个可以判断出是七鱼的推送消息。

### 自定义聊天组件UI效果

获取自定义 UI 类对象：

```objective-c
[[QYSDK sharedSDK] customUIConfig];
```
QYCustomUIConfig 是负责自定义 UI 的类，必须在集成聊天组件之前完成配置项设置。相关内容如下：

```objective-c
/**
 *  自定义UI配置类：QYCustomUIConfig，单例模式
 */
@interface QYCustomUIConfig : NSObject

+ (instancetype)sharedInstance;

/**
 *  恢复默认设置
 */
- (void)restoreToDefault;

/**
 *  会话窗口上方提示条中的文本字体颜色
 */
@property (nonatomic, strong) UIColor *sessionTipTextColor;

/**
 *  会话窗口上方提示条中的文本字体大小
 */
@property (nonatomic, assign) CGFloat sessionTipTextFontSize;

/**
 *  会话窗口上方提示条中的背景颜色
 */
@property (nonatomic, strong) UIColor *sessionTipBackgroundColor;

/**
 *  访客文本消息字体颜色
 */
@property (nonatomic, strong) UIColor *customMessageTextColor;

/**
 *  访客文本消息中的链接字体颜色
 */
@property (nonatomic, strong) UIColor *customMessageHyperLinkColor;

/**
 *  访客文本消息字体大小
 */
@property (nonatomic, assign) CGFloat customMessageTextFontSize;

/**
 *  客服文本消息字体颜色
 */
@property (nonatomic, strong) UIColor *serviceMessageTextColor;

/**
 *  客服文本消息中的链接字体颜色
 */
@property (nonatomic, strong) UIColor *serviceMessageHyperLinkColor;

/**
 *  客服文本消息字体大小
 */
@property (nonatomic, assign) CGFloat serviceMessageTextFontSize;

/**
 *  提示文本消息字体颜色；提示文本消息有很多种，比如“***为你服务”就是一种
 */
@property (nonatomic, strong) UIColor *tipMessageTextColor;

/**
 *  提示文本消息字体大小；提示文本消息有很多种，比如“***为你服务”就是一种
 */
@property (nonatomic, assign) CGFloat tipMessageTextFontSize;

/**
 *  输入框文本消息字体颜色
 */
@property (nonatomic, strong) UIColor *inputTextColor;

/**
 *  输入框文本消息字体大小
 */
@property (nonatomic, assign) CGFloat inputTextFontSize;

/**
 *  消息tableview的背景图片
 */
@property (nonatomic, strong) UIImageView *sessionBackground;

/**
 *  访客头像
 */
@property (nonatomic, strong) UIImage *customerHeadImage;
@property (nonatomic, copy) NSString *customerHeadImageUrl;

/**
 *  客服头像
 */
@property (nonatomic, strong) UIImage *serviceHeadImage;
@property (nonatomic, copy) NSString *serviceHeadImageUrl;

/**
 *  人工按钮文案
 */
@property (nonatomic, copy) NSString *humanButtonText;

/**
 *  访客消息气泡normal图片
 */
@property (nonatomic, strong) UIImage *customerMessageBubbleNormalImage;

/**
 *  访客消息气泡pressed图片
 */
@property (nonatomic, strong) UIImage *customerMessageBubblePressedImage;

/**
 *  客服消息气泡normal图片
 */
@property (nonatomic, strong) UIImage *serviceMessageBubbleNormalImage;

/**
 *  客服消息气泡pressed图片
 */
@property (nonatomic, strong) UIImage *serviceMessageBubblePressedImage;

/**
 *  输入框上方操作按钮文字颜色
 */
@property (nonatomic, strong) UIColor *actionButtonTextColor;

/**
 *  输入框上方操作按钮边框颜色
 */
@property (nonatomic, strong) UIColor *actionButtonBorderColor;

/**
 *  消息竖直方向间距
 */
@property (nonatomic, assign) CGFloat sessionMessageSpacing;

/**
 *  头像与消息气泡间距，默认为5pt
 */
@property (nonatomic, assign) CGFloat headMessageSpacing;

/**
 *  是否显示头像
 */
@property (nonatomic, assign) BOOL showHeadImage;

/**
 *  默认是YES,默认rightBarButtonItem内容是黑色，设置为NO，可以修改为白色
 */
@property (nonatomic, assign) BOOL rightBarButtonItemColorBlackOrWhite;

/**
 *  默认是YES,默认显示发送语音入口，设置为NO，可以修改为隐藏
 */
@property (nonatomic, assign) BOOL showAudioEntry;

/**
 *  默认是YES,默认在机器人模式下显示发送语音入口，设置为NO，可以修改为隐藏
 */
@property (nonatomic, assign) BOOL showAudioEntryInRobotMode;

/**
 *  默认是YES,默认显示发送表情入口，设置为NO，可以修改为隐藏
 */
@property (nonatomic, assign) BOOL showEmoticonEntry;

/**
 *  默认是YES,默认显示发送图片入口，设置为NO，可以修改为隐藏
 */
@property (nonatomic, assign) BOOL showImageEntry;

/**
 *  默认是YES,默认进入聊天界面，是文本输入模式的话，会弹出键盘，设置为NO，可以修改为不弹出
 */
@property (nonatomic, assign) BOOL autoShowKeyboard;

/**
 *  表示聊天组件离界面底部的间距，默认是0；比较典型的是底部有tabbar，这时候设置为tabbar的高度即可
 */
@property (nonatomic, assign) CGFloat bottomMargin;

/**
 *  默认是NO,默认隐藏关闭会话入口，设置为YES，可以修改为显示
 */
@property (nonatomic, assign) BOOL showCloseSessionEntry;

/**
 *  访客分流展示模式
 */
@property (nonatomic, assign) QYBypassDisplayMode bypassDisplayMode;

/**
 *  以下配置项在v4.4.0版本前，只有平台电商版本有；v4.4.0以后，平台电商/非平台电商均有这些配置项
 *  聊天窗口右上角按钮（对于平台电商来说，这里可以考虑放“商铺入口”）显示，默认不显示
 */
@property (nonatomic, assign)   BOOL showShopEntrance;

/**
 *  聊天窗口右上角按钮（对于平台电商来说，这里可以考虑放“商铺入口”）icon
 */
@property (nonatomic, strong) UIImage *shopEntranceImage;

/**
 *  聊天窗口右上角按钮（对于平台电商来说，这里可以考虑放“商铺入口”）文本
 */
@property (nonatomic, copy) NSString *shopEntranceText;

/**
 *  聊天内容区域的按钮（对于平台电商来说，这里可以考虑放置“会话列表入口“）显示，默认不显示
 */
@property (nonatomic, assign) BOOL showSessionListEntrance;

/**
 *  聊天内容区域的按钮（对于平台电商来说，这里可以考虑放置“会话列表入口“）在聊天页面的位置，YES代表在右上角，NO代表在左上角，默认在右上角
 */
@property (nonatomic, assign) BOOL sessionListEntrancePosition;

/**
 *  会话列表入口icon
 */
@property (nonatomic, strong) UIImage *sessionListEntranceImage;

/**
 *  输入框下方“完全自定义”配置项
 */
@property (nonatomic, strong) NSArray<QYCustomInputItem *> *customInputItems;

@end

```

#### 更换图片素材

QYCustomUIConfig 只负责修改部分样式效果，不包含所有图片素材的替换。iOS SDK 支持所有图片素材替换，只需新建 QYCustomResource.bundle，在其中放置跟 QYResource.bundle 中同名的图片素材，即可替换 QYResource.bundle 中的对应素材。为了保持效果统一，应该放置同等尺寸的图片。

#### 访客分流展示样式

QYCustomUIConfig 中 bypassDisplayMode 用于指定访客分流展示样式，默认分流弹层从底部弹出，还可指定 None 或是从中间弹出：

```objective-c
/**
 *  访客分流展示模式
 */
typedef NS_ENUM(NSInteger, QYBypassDisplayMode) {
    QYBypassDisplayModeNone,
    QYBypassDisplayModeCenter,
    QYBypassDisplayModeBottom,
};
```

#### “照相机”替换为“更多”按钮

在 v4.4.0 版本中，聊天界面输入区域 “照相机” 按钮可替换成 “更多” 按钮，点击“更多”按钮展开显示配置的选项。需要设置 QYCustomUIConfig 的 customInputItems 属性，该属性为数组类型，每个元素均为  QYCustomInputItem 类型对象，代表一个选项。QYCustomInputItem 定义如下：

```objective-c
/**
 *  输入框下方“更多”配置项点击回调
 */
typedef void (^QYCustomInputItemBlock)();

/**
 *  输入框下方“完全自定义”配置项
 */
@interface QYCustomInputItem : NSObject

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) QYCustomInputItemBlock block;

@end
```

配置 customInputItems 示例如下：

```objective-c
QYCustomInputItem *photoItem = [[QYCustomInputItem alloc] init];
photoItem.normalImage = [UIImage imageNamed:@"icon_media_photo_normal"];
photoItem.selectedImage = [UIImage imageNamed:@"icon_media_photo_pressed"];
photoItem.text = @"相册";
photoItem.block = ^{ };

QYCustomInputItem *cameraItem = [[QYCustomInputItem alloc] init];
cameraItem.normalImage = [UIImage imageNamed:@"icon_media_camera_normal"];
cameraItem.selectedImage = [UIImage imageNamed:@"icon_media_camera_pressed"];
cameraItem.text = @"拍摄";
cameraItem.block = ^{ };

QYCustomInputItem *humanItem = [[QYCustomInputItem alloc] init];
humanItem.normalImage = [UIImage imageNamed:@"icon_media_human_normal"];
humanItem.selectedImage = [UIImage imageNamed:@"icon_media_human_pressed"];
humanItem.text = @"人工客服";
humanItem.block = ^{ };
	    
NSArray *items = @[photoItem, cameraItem, humanItem];
[[QYSDK sharedSDK] customUIConfig].customInputItems = items;
```

### 自定义聊天组件事件处理

获取自定义事件处理类对象：

```objective-c
[[QYSDK sharedSDK] customActionConfig];
```
QYCustomActionConfig 是负责自定义事件处理的类。相关内容如下：

```objc
/**
 *  本类提供了所有自定义行为的接口
 *  每个接口对应一个自定义行为的处理，如果设置了，则使用设置的处理，如果不设置，则采用默认处理
 */

/**
 *  action事件回调
 */
typedef void (^QYActionBlock)(QYAction *action);

/**
 *  链接点击事件回调
 */
typedef void (^QYLinkClickBlock)(NSString *linkAddress);

/**
 *  bot点击事件回调
 */
typedef void (^QYBotClickBlock)(NSString *target, NSString *params);

/**
 *  退出排队回调
 */
typedef void (^QYQuitWaitingBlock)(QuitWaitingType quitType);

/**
 *  显示bot自定义信息回调
 */
typedef void (^QYShowBotCustomInfoBlock)(NSArray *array);

/**
 *  bot商品卡片按钮点击事件回调
 */
typedef void (^QYSelectedCommodityActionBlock)(QYSelectedCommodityInfo *commodityInfo);

/**
 *  扩展视图点击回调
 *
 *  @param extInfo 附带信息
 */
typedef void (^QYExtraViewClickBlock)(NSString *extInfo);

/**
 *  系统消息点击回调
 *
 *  @param message 消息对象
 */
typedef void (^QYSystemNotificationClickBlock)(id message);

/**
 *  所有消息内事件点击回调
 *
 *  @param eventName 事件名称
 *  @param eventData 数据
 *  @param messageId 消息ID
 */
typedef void (^QYEventBlock)(NSString *eventName, NSString *eventData, NSString *messageId);


/**
 *  自定义行为配置类：QYCustomActionConfig，单例模式
 */
@interface QYCustomActionConfig : NSObject

+ (instancetype)sharedInstance;

/**
 *  action事件
 */
@property (nonatomic, copy) QYActionBlock actionBlock;

/**
 *  所有消息中的链接（自定义商品消息、文本消息、机器人答案消息）的回调处理
 */
@property (nonatomic, copy) QYLinkClickBlock linkClickBlock;

/**
 *  bot相关点击
 */
@property (nonatomic, copy) QYBotClickBlock botClick;

/**
 *  推送消息相关点击
 */
@property (nonatomic, copy) QYLinkClickBlock pushMessageClick;

/**
 *  显示bot自定义信息
 */
@property (nonatomic, copy) QYShowBotCustomInfoBlock showBotCustomInfoBlock;

/**
 *  bot商品卡片按钮点击事件
 */
@property (nonatomic, copy) QYSelectedCommodityActionBlock commodityActionBlock;

/**
 *  扩展视图点击
 */
@property (nonatomic, copy) QYExtraViewClickBlock extraClickBlock;

/**
 *  系统消息点击
 */
@property (nonatomic, copy) QYSystemNotificationClickBlock notificationClickBlock;

/**
 *  消息内点击
 */
@property (nonatomic, copy) QYEventBlock eventClickBlock;

/**
 *  设置录制或者播放语音完成以后是否自动deactivate AVAudioSession
 *
 *  @param deactivate 是否deactivate，默认为YES
 */
- (void)setDeactivateAudioSessionAfterComplete:(BOOL)deactivate;

/**
 *  显示退出排队提示
 *
 *  @param quitWaitingBlock 选择结果回调
 */
- (void)showQuitWaiting:(QYQuitWaitingBlock)quitWaitingBlock;

@end
```

#### 客服相关事件处理

在 v4.6.0 版本中，修改了关于客服相关事件的对外接口，可以拦截所有请求客服前和请求客服后的事件，需要设置 QYCustomActionConfig 中的 actionBlock 属性，该 block 返回一个 QYAction 对象，此对象定义如下：

```objective-c
/**
 *  QYAction定义了部分动作，通过type区分不同情形，并调用各自对应的回调
 *  若需要获取这部分动作，请在QYCustomActionConfig单例中设置QYAction属性
 */
@interface QYAction : NSObject

/**
 *  动作类型
 */
@property (nonatomic, assign) QYActionType type;

/**
 *  请求客服前调用
 */
@property (nonatomic, copy) QYRequestStaffBeforeBlock requestStaffBeforeBlock;

/**
 *  请求客服后调用
 */
@property (nonatomic, copy) QYRequestStaffAfterBlock requestStaffAfterBlock;

@end
```

其中 QYActionType 目前定义了如下动作场景：

```objective-c
/**
 *  动作类型
 */
typedef NS_ENUM(NSInteger, QYActionType) {
    QYActionTypeNone = 0,
    QYActionTypeRequestStaffBefore,     //请求客服前
    QYActionTypeRequestStaffAfter,      //请求客服后
};
```

QYRequestStaffBeforeBlock 为请求客服前回调的 block，该事件给出了当前请求客服是何种场景，开发者可针对不同场景做定制化处理，其定义如下：

```objective-c
/**
 *  通用回调，一般用于告诉SDK是否继续进行后续操作
 *  例如：设置了请求客服前回调后，通过调用此QYCallback来继续或是中断请求客服
 */
typedef void (^QYCallback)(BOOL continueIfNeeded);

/**
 *  请求客服场景
 */
typedef NS_ENUM(NSInteger, QYRequestStaffBeforeScene) {
    QYRequestStaffBeforeSceneNone,               //无需关心的请求客服场景
    QYRequestStaffBeforeSceneInit,               //进入会话页面，初次请求客服
    QYRequestStaffBeforeSceneRobotUnable,        //机器人模式下告知无法解答，点击消息中人工按钮
    QYRequestStaffBeforeSceneNavHumanButton,     //机器人模式下，点击右上角人工按钮
    QYRequestStaffBeforeSceneActiveRequest,      //主动请求人工客服
    QYRequestStaffBeforeSceneChangeStaff,        //切换人工客服
};

/**
 *  请求客服前回调
 *
 *  @param scene 请求客服场景
 *  @param onlyHuman 是否只请求人工客服
 *  @param callback 处理完成后的回调，若需继续请求客服，则调用callback(YES)；若需停止请求，调用callback(NO)
 */
typedef void (^QYRequestStaffBeforeBlock)(QYRequestStaffBeforeScene scene, BOOL onlyHuman, QYCallback callback);
```

QYRequestStaffAfterBlock 为请求客服后回调的 block，其中 info 为新会话的相关信息，包括客服ID、昵称、头像等，block 定义如下：

```objective-c
/**
 *  请求客服后回调
 *
 *  @param info 会话相关信息
 *  @param error 错误信息
 */
typedef void (^QYRequestStaffAfterBlock)(NSDictionary *info, NSError *error);
```

以下为客服相关事件处理的示例代码：

```objective-c
QYActionBlock actionBlock = ^(QYAction *action) {
    if (action.type == QYActionTypeRequestStaffBefore) {
        action.requestStaffBeforeBlock = ^(QYRequestStaffBeforeScene scene, BOOL onlyHuman, QYCallback callback) {
            NSLog(@"当前请求客服的场景是:%lld", (long long)scene);
            ......
            
            //若继续请求客服
            if (callback) {
                callback(YES);
            }
            //若中断请求客服
            if (callback) {
                callback(NO);
            }
        }
    } else if (action.type == QYActionTypeRequestStaffAfter) {
        action.requestStaffAfterBlock = ^(NSDictionary *info, NSError *error) {
            if (error) {
                NSLog(@"请求客服失败，error：%@", error);
            } else {
                NSLog(@"请求客服成功，info：%@", (info ? info : @"none"));
            }
        };
    }
};
[[QYSDK sharedSDK] customActionConfig].actionBlock = actionBlock;
```

注：在 v4.4.0 版本中，仅可拦截请求客服前事件；若要拦截，请设置 QYCustomActionConfig 中的 requestStaffBlock，处理完成后，请主动调用该 block 中的 completion 回调，并设置 needed 参数，YES 表示继续请求客服，NO 表示中断请求客服。

### 自定义商品信息

获取到 sessionViewController 之后，可以指定商品信息并主动发送给客服。带着商品信息进入聊天界面，分为两种情况：如果当前还没请求到人工客服， 则不会发送商品信息，等待请求人工客服成功后会主动发送；如果当前已经处于人工客服会话状态中了，会立即发送商品信息。示例如下：

```objective-c
QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
commodityInfo.title = @"网易七鱼";
commodityInfo.desc = @"网易七鱼是网易旗下一款专注于解决企业与客户沟通的客服系统产品。";
commodityInfo.pictureUrlString = @"http://qiyukf.com/main/res/img/index/barcode.png";
commodityInfo.urlString = @"http://qiyukf.com/";
commodityInfo.note = @"￥10000";
commodityInfo.show = YES;

sessionViewController.commodityInfo = commodityInfo;
```

QYCommodityInfo.h 相关内容如下：

```objective-c
/**
 *  QYCommodityTag：自定义商品信息卡片按钮信息
 */
@interface QYCommodityTag : NSObject

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *focusIframe;
@property (nonatomic, copy) NSString *data;

@end


/**
 *  商品信息类：QYCommodityInfo
 */
@interface QYCommodityInfo : NSObject

/**
 *  商品标题，字符数要求小于100
 */
@property (nonatomic, copy) NSString *title;

/**
 *  商品描述，字符数要求小于300
 */
@property (nonatomic, copy) NSString *desc;

/**
 *  商品图片url，字符数要求小于1000
 */
@property (nonatomic, copy) NSString *pictureUrlString;

/**
 *  跳转url，字符数要求小于1000
 */
@property (nonatomic, copy) NSString *urlString;

/**
 *  备注信息，可以显示价格，订单号等，字符数要求小于100
 */
@property (nonatomic, copy) NSString *note;

/**
 *  发送时是否要在用户端隐藏，YES为显示，NO为隐藏，默认为NO
 */
@property (nonatomic, assign) BOOL show;

/**
 *  自定义商品信息按钮数组，最多显示三个按钮;
 */
@property (nonatomic, copy) NSArray<QYCommodityTag *> *tagsArray;

/**
 *  自定义商品信息按钮数组，最多显示三个按钮;NSString *类型，跟上面的数组类型二选一
 */
@property (nonatomic, copy) NSString *tagsString;

/**
 *  是否自定义，YES代表是，NO代表否，默认NO。
 *  自定义的话，只有pictureUrlString、urlString有效，只显示一张图片 (v4.4.0)
 */
@property (nonatomic, assign) BOOL isCustom;

/**
 *  是否由访客手动发送，YES代表是，NO代表否，默认NO (v4.4.0)
 */
@property (nonatomic, assign) BOOL sendByUser;

/**
 *  发送按钮文案 (v4.4.0)
 */
@property (nonatomic, copy) NSString *actionText;

/**
 *  发送按钮文案颜色 (v4.4.0)
 */
@property (nonatomic, strong) UIColor *actionTextColor;

/**
 *  一般用户不需要填这个字段，这个字段仅供特定用户使用
 */
@property (nonatomic, copy) NSString *ext;

@end
```

以上的自动发送商品信息功能仅在人工客服下有效，在 v4.4.0 版本中，获取到 sessionViewController 后，可设置机器人模式下是否开启自动发送商品卡片功能，默认不开启。若开启，则设置商品信息后，机器人模式下也可直接发送商品卡片：

```objective-c
sessionViewController.autoSendInRobot = YES;
```

#### 主动发送商品信息

QYSessionViewController.h 中开放了发送商品信息接口，可以主动调用发送：

```objective-c
[sessionViewController sendCommodityInfo:commodityInfo];
```

#### 可能遇到的问题4

1. 商品链接的点击处理可自定义，请参看此文档关于 QYCustomActionConfig 的相关说明。

### 指定客服ID或客服组ID

在获取 sessionViewController 之后，可以指定客服ID或客服组ID：

```objective-c
sessionViewController.groupId = groupId;
sessionViewController.staffId = staffId;
```

指定之后，进入聊天界面时，会直接以此ID去请求对应的客服或者客服组。在 管理后台 -> 设置 -> 高级设置 -> 访客分配 -> ID查询 中可查询到客服ID或客服组ID。

### 多机器人接入

在获取 sessionViewController 之后，可以指定机器人ID：

```objective-c
sessionViewController.robotId = robotId;
```

指定之后，进入聊天界面时，会直接以此ID去请求对应的机器人。在 管理后台 -> 设置 -> 机器人 -> 机器人列表 -> 机器人ID 中可查询到机器人ID。

### 指定常见问题模版ID

在获取 sessionViewController 之后，可以指定常见问题模版ID：

```objective-c
sessionViewController.commonQuestionTemplateId = commonQuestionTemplateId;
```

指定之后，进入聊天界面时，会直接以此ID去请求对应的常见问题模版。在 管理后台 -> 设置 -> 机器人 -> 常见问题设置 中可查询到常见问题模版ID。

### 访客分流是否开启机器人 

在获取 sessionViewController 之后，可以指定访客分流是否开启机器人，默认不开启。如果开启机器人，则选择客服或者客服分组之后，先进入机器人模式：

```objective-c
sessionViewController.openRobotInShuntMode = YES;
```

### 自定义客服信息

在 v4.6.0 版本中，新增自定义人工客服信息功能，配置完成后人工客服的昵称、头像、接入语等均会被设置的信息替换。需要在 QYSessionViewController 中设置如下属性：

```objective-c
/**
 *  人工客服信息
 */
@property (nonatomic, strong) QYStaffInfo *staffInfo;
```

QYStaffInfo 对象可配置人工客服的多项信息，注意必须配置 staffId，用以区分人工客服；其他的配置项若设置了则替换，未设置则使用默认，QYStaffInfo 定义如下：

```objective-c
/**
 *  人工客服信息
 */
@interface QYStaffInfo : NSObject

/**
 *  客服ID，限制20字符
 */
@property (nonatomic, copy) NSString *staffId;

/**
 *  客服昵称，限制20字符
 */
@property (nonatomic, copy) NSString *nickName;

/**
 *  客服头像URL
 */
@property (nonatomic, copy) NSString *iconURL;

/**
 *  接入提示，限制50字符
 */
@property (nonatomic, copy) NSString *accessTip;

/**
 *  客服信息描述
 */
@property (nonatomic, copy) NSString *infoDesc;

@end
```

### 请求人工客服

在 v4.4.0 版本中，获取到 sessionViewController 后，提供直接请求人工客服接口：

```objective-c
[sessionViewController requestHumanStaff];
```

该接口仅在当前无会话或机器人模式下才能主动请求人工客服。

### 切换人工客服

在 v4.6.0 版本中，获取到 sessionViewController 后，提供切换人工客服接口：

```objective-c
/**
 *  切换人工客服
 *
 *  @param staffId 客服ID
 *  @param groupId 分组ID
 *  @param closetip 切换提示语
 *  @param closeCompletion 退出旧会话完成的回调
 *  @param requestCompletion 请求新会话完成的回调
 */
- (void)changeHumanStaffWithStaffId:(int64_t)staffId
                            groupId:(int64_t)groupId
                           closetip:(NSString *)closetip
                    closeCompletion:(QYCompletion)closeCompletion
                  requestCompletion:(QYCompletion)requestCompletion;
```

切换客服逻辑为自动结束当前会话，并使用设置的 staffId 或 groupId 去请求新的人工客服；在结束当前会话时，消息流中会展示一条 “您退出了咨询”，此文案可通过设置接口中的 closetip 来替换。

### 设置VIP等级 

在获取 sessionViewController 之后，可以设置访客的 VIP 等级，默认是 非VIP 。VIP 等级分两种，一种是 非VIP 和 VIP1 ～ VIP10，VIP 对应的数值是1 ～ 10；另一种是 非VIP 和 VIP ，VIP 对应的数值是11。

```objective-c
sessionViewController.vipLevel = 1;
```

### CRM上报

可以主动上报 CRM 信息，使用 QYSDK.h 中的 setUserInfo: 接口设置用户信息，QYUserInfo 定义如下：

```objective-c
/**
 *  个人信息
 */
@interface QYUserInfo : NSObject

/**
 *  个人账号Id
 */
@property (nonatomic, copy) NSString *userId;

/**
 *  用户详细信息json数据
 */
@property (nonatomic, copy) NSString *data;

@end
```

示例代码：

```objective-c
static NSString * const QYKey = @"key";
static NSString * const QYValue = @"value";
static NSString * const QYHidden = @"hidden";
static NSString * const QYIndex = @"index";
static NSString * const QYLabel = @"label";

QYUserInfo *userInfo = [[QYUserInfo alloc] init];
userInfo.userId = @"userId";
NSDictionary *nameDict = @{
                           QYKey : @"real_name",
                           QYValue : @"边晨",
                           };
NSDictionary *phoneDict = @{
                            QYKey : @"mobile_phone",
                            QYValue : @"13805713536",
                            QYHidden : @(NO),
                            };
NSDictionary *emailDict = @{
                            QYKey : @"email",
                            QYValue : @"bianchen@163.com",
                            };
NSDictionary *authDict = @{
                           QYKey : @"authentication",
                           QYValue : @"已认证",
                           QYIndex : @"0",
                           QYLabel : @"实名认证",
                           };
NSDictionary *cardDict = @{
                           QYKey : @"bankcard",
                           QYValue : @"622202******01116068",
                           QYIndex : @"1",
                           QYLabel : @"绑定银行卡",
                           };
NSArray *array = @[nameDict, phoneDict, emailDict, authDict, cardDict];
NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
if (data) {
    userInfo.data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

[[QYSDK sharedSDK] setUserInfo:userInfo];
```
具体请看官网 CRM 相关文档：<a>http://qiyukf.com/newdoc/html/qiyu_crm_interface.html</a>

### 七鱼系统推送消息

七鱼系统推送消息与苹果的 APNS 推送无关。可以主动要求服务器推送指定的消息：

```objc
/**
 *  获取推送消息
 *
 *  @param messageId 消息id
 */
- (void)getPushMessage:(NSString *)messageId;
```

可以接收服务器返回的消息，进行界面展示；不管是主动获取的消息还是管理后台主动推送的消息，都通过此接口获取：

```objective-c
/**
 *  推送消息回调
 */
typedef void(^QYPushMessageBlock)(QYPushMessage *pushMessage);

/**
 *  注册推送消息通知回调
 *
 *  @param block 收到消息的回调
 */
- (void)registerPushMessageNotification:(QYPushMessageBlock)block;
```

### 设置输入区域上方工具栏

在 v3.13.0 版本 中，开放了输入区域上方工具栏按钮设置，设置 QYSessionViewController 中如下属性：

```objective-c
/**
 *  输入区域上方工具栏内的按钮信息
 */
@property (nonatomic, copy) NSArray<QYButtonInfo *> *buttonInfoArray;
```

数组中元素为 QYButtonInfo 对象，定义如下：

```objective-c
/**
 *  输入区域上方工具栏内按钮信息类：QYButtonInfo
 *  注: actionType及index为button点击事件传递信息，仅可读
 *  actionType为1表示发送文本消息title，2表示openURL或是自定义行为；index表示该button位置
 */
@interface QYButtonInfo : NSObject

@property (nonatomic, strong) id buttonId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) id userData;
@property (nonatomic, assign, readonly) NSUInteger actionType;
@property (nonatomic, assign, readonly) NSUInteger index;

@end
```

添加按钮的示例代码：

```objective-c
QYButtonInfo *button_1 = [[QYButtonInfo alloc] init];
button_1.buttonId = [NSNumber numberWithLongLong:1001];
button_1.title = @"按钮标题1";

QYButtonInfo *button_2 = [[QYButtonInfo alloc] init];
button_2.buttonId = [NSNumber numberWithLongLong:1002];
button_2.title = @"按钮标题2";

sessionViewController.buttonInfoArray = @[button_1, button_2];
```

#### 按钮点击事件处理

按钮点击事件回调定义在 QYSessionViewController 中，该 block 透传 QYButtonInfo 相关信息：

```objective-c
/**
 *  工具栏内按钮点击回调定义
 */
typedef void (^QYButtonClickBlock)(QYButtonInfo *action);

/**
 *  输入区域上方工具栏内的按钮点击事件
 */
@property (nonatomic, copy) QYButtonClickBlock buttonClickBlock;
```

### 访问轨迹与行为轨迹上报

#### 访问轨迹

在 v4.0.0 版本中，SDK 支持记录用户在 App 内的访问轨迹并上报。使用该功能，需要企业开通 “访问轨迹” 功能。访问轨迹接口定义在 QYSDK.h 中：

```objective-c
/**
 *  访问轨迹
 *  @param title 标题
 *  @param enterOrOut 进入还是退出
 */
- (void)trackHistory:(NSString *)title enterOrOut:(BOOL)enterOrOut key:(NSString *)key;
```

接口调用示例：

```objective-c
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_key) {
        _key = [[NSUUID UUID] UUIDString];
        [[QYSDK sharedSDK] trackHistory:@"七鱼金融" enterOrOut:YES key:_key];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_key)  {
        [[QYSDK sharedSDK] trackHistory:@"七鱼金融" enterOrOut:NO key:_key];
        _key = nil;
    }
}
```

#### 行为轨迹

在 v4.4.0 版本中，SDK 支持记录用户在 App 内的行为轨迹并上报。使用该功能，需要企业开通 “行为轨迹” 功能。行为轨迹是建立在访问轨迹之上的，如果需要使用行为轨迹，请先开启访问轨迹。

行为轨迹主要用于记录用户行为，例如购买了某件商品，可设置 title 参数为“购买xxx商品”，并在 description 参数中以 key-value 形式设置详细的商品信息，客服可查看此类信息，用于分析用户行为。行为轨迹接口定义在 QYSDK.h 中：

```objective-c
/**
 *  行为轨迹
 *  @param title 标题
 *  @param description 具体信息，以key-value表示信息对，例如key为“商品价格”，value为“999”
 */
- (void)trackHistory:(NSString *)title description:(NSDictionary *)description key:(NSString *)key;
```

### 历史消息收起

在 v4.7.0 版本中，获取到 sessionViewController 后，可配置每页消息加载最大数量，该设置项控制了初次进入聊天界面的消息数量以及历史消息每次下拉加载的数量，默认为20条：

```objective-c
sessionViewController.messagePageLimit = 20;
```

可配置进入聊天界面时是否收起之前的历史消息，仅在创建新会话时收起，若为以下情况：上一次会话未结束、新会话创建失败、最后一条消息为可点击的访客分流消息、有未读消息，则仍显示历史会话，此配置项默认为NO：

```objective-c
sessionViewController.hideHistoryMessages = NO;
```

hideHistoryMessages = YES 情况下，首次下拉加载历史消息时会显示提示消息，提示文案可配置，默认为 “以上是历史消息” ：

```objective-c
sessionViewController.historyMessagesTip = @"以上是历史消息";
```

### 自定义顶部区域

在 v4.7.0 版本中，获取到 sessionViewController 后，可自定义聊天界面顶部区域，支持外部注册入视图，可配置视图高度和边距；此视图悬停在聊天界面导航栏下方、消息列表上方，不随消息流滚动。注册接口为：

```objective-c
/**
 *  注册聊天界面顶部悬停视图
 *
 *  @param hoverView 顶部悬停视图
 *  @param height 视图高度
 *  @param insets 视图边距，默认UIEdgeInsetsZero；top表示视图与导航栏底部距离，bottom设置无效，left/right分别表示距离屏幕左右边距
 */
- (void)registerTopHoverView:(UIView *)hoverView height:(CGFloat)height marginInsets:(UIEdgeInsets)insets;
```

支持销毁此视图，支持设置是否有渐隐动画及动画时长，销毁接口如下：

```objective-c
/**
 *  销毁聊天界面顶部悬停视图
 */
- (void)destroyTopHoverViewWithAnmation:(BOOL)animated duration:(NSTimeInterval)duration;
```

### 清理文件缓存

部分带附件的消息接收并下载后可以通过此接口清理已下载到本地的缓存文件：

```objective-c
/**
 *  清理接收文件缓存
 *  @param completeBlock 清理缓存完成block
 */
- (void)cleanResourceCacheWithBlock:(QYCleanResourceCacheCompleteBlock)completeBlock;
```

## 平台电商版本

平台电商版本相关头文件全部在 "QIYU_iOS_SDK/POP" 目录下。在需要使用的地方 import "QYPOPSDK.h"。平台电商版本针对 QYSessionViewController 扩展了分类 QYPOPSessionViewController，增加了两个配置项：

```objective-c
/**
 *  平台电商专用
 */
@interface QYSessionViewController (POP)

/**
 *  平台电商店铺ID，不是平台电商不用管
 */
@property (nonatomic, copy) NSString *shopId;

/**
 *  会话窗口回调
 */
@property (nonatomic, weak) id<QYSessionViewDelegate> delegate;

@end
```

### 请求特定商家

通过设置 shopId 可以在进入聊天窗口后请求对应的商家客服：

```objective-c
sessionViewController.shopId = @"shopId";
```

### 监听聊天窗口事件

通过设置 delegate 可以监听聊天窗口部分事件：

```objective-c
sessionViewController.delegate = self;
```

协议为 QYSessionViewDelegate，定义如下：

```objective-c
/**
 *  QYSessionViewDelegate：右上角入口以及聊天内容区域按钮点击回调
 */
@protocol QYSessionViewDelegate <NSObject>

/**
 *  点击右上角按钮回调（对于平台电商来说，这里可以考虑放“商铺入口”）
 */
- (void)onTapShopEntrance;

/**
 *  点击聊天内容区域的按钮回调（对于平台电商来说，这里可以考虑放置“会话列表入口“）
 */
- (void)onTapSessionListEntrance;

@end
```

### 删除会话项

使用 QYPOPConversationManager 中如下接口删除会话列表中某一项：

```objective-c
/**
 *  删除会话列表中的会话
 *
 *  @param shopId 商铺ID
 *  @param isDelete 是否删除消息记录，YES删除，NO不删除
 */
- (void)deleteRecentSessionByShopId:(NSString *)shopId deleteMessages:(BOOL)isDelete;
```

## 参考DEMO源码

如果您看完此文档后，还有任何集成方面的疑问，可以参考 iOS SDK Demo 源码：https://github.com/qiyukf/QIYU_iOS_SDK_Demo_Source.git 。源码充分的展示了 iOS SDK 的能力，并且为集成 iOS SDK 提供了样例代码。

## 更新说明

#### V4.7.1（2018-12-17）

1. 修复部分已知问题

#### V4.7.0（2018-12-05）

1. 支持进入新会话时收起历史消息
2. 新增自定义聊天界面顶部悬停区域
3. 满意度评价支持顺序调整和标签/备注必填
4. 新增自定义消息及视图功能

#### V4.6.0（2018-11-15）

1. 满意度支持多次评价和评价时效设置
2. 支持撤回消息展示
3. 新增自定义客服信息功能
4. 新增请求客服相关事件处理
5. 新增切换人工客服功能
6. 优化请求客服逻辑
7. 优化部分接口定义

#### V4.5.0（2018-10-09）

1. 新增小视频收发功能
2. 优化富文本消息显示和复制功能
3. SDK 新增依赖库：Photos.framework 及 CoreMotion.framework

#### V4.4.0（2018-09-06）

1. 自定义商品信息新增“自定义图片”、“手动发送”功能
2. “聊天界面右上角按钮自定义功能”之前仅平台电商版本支持，现修改为平台电商、非平台电商版本均支持
3. 聊天界面输入区域“照相机”按钮可配置为“更多”按钮，点击“更多”按钮可展开显示用户配置的选项
4. 根据用户输入的消息与企业知识库进行匹配，匹配到的结果显示在输入框上方工具栏
5. bot支持自定义商品消息，可实现定制化
6. 新增拦截请求客服事件的功能
7. 新增机器人自动发送商品卡片的功能
8. bot 商品卡片底部新增自定义按钮
9. 新增请求人工客服接口
10. 新增记录用户行为轨迹功能
11. 修复了偶现的访客未进入机器人直接请求到人工客服的问题

#### V4.2.1

1. 支持客服端发送自定义商品信息
2. bot 中的"图文混排"消息支持富文本

#### V4.1.0

1. 自定义商品信息扩展
2. 长消息阅读优化
3. 主动消息推送扩展
4. 访客输入联想知识库问题

#### V4.0.0

1. 访客排队过程中可与机器人会话
2. 新增反垃圾处理
3. 新增 App 访问轨迹
4. 访客分流支持不同的展现方式
5. UI优化：机器人订单选择器样式、机器人热门问题样式、物流消息折叠

#### V3.14.0

1. 优化满意度，新增自定义标签

#### V3.13.0

1. 输入区域上方工具栏支持设置，可以添加按钮、设置按钮点击事件的处理

#### V3.12.0

1. 支持多机器人

#### V3.11.0

1. 兼容 iOS 11
2. 兼容 iPhone X
3. SDK 新增依赖库：AssetsLibrary.framework

#### V3.7.0

1. 新增富文本处理
2. 新增对机器人答案进行评价
3. SDK 新增依赖库：libxml2.tbd



