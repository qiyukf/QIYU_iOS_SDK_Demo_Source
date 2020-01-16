# 网易七鱼 iOS SDK 开发指南

## 概述

网易七鱼 iOS SDK 是客服系统访客端的解决方案，既包含了客服聊天逻辑管理，也提供了聊天界面，开发者可方便的将客服功能集成到自己的 App 中。iOS SDK 支持 iOS8 以上版本，同时支持 iPhone、iPad，同时支持竖屏和横屏。

## 接入说明

### 导入SDK

#### 手动集成

* 下载 QY SDK，得到3个 **.a** 文件、 **QYResouce** 资源文件和 **ExportHeaders** 文件夹，将他们导入工程。
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

* 在 Build Settings -> Other Linker Flags 中添加 **-ObjC** 。

#### 自动集成

使用 **CocoaPods** 集成，在 Podfile 文件中加入：

```objectivec
pod    'QIYU_iOS_SDK',    '~> x.x.x'
```
"x.x.x" 代表版本号，比如想要使用 5.0.0 版本，可加入如下代码：

```objectivec
pod    'QIYU_iOS_SDK',    '~> 5.0.0'
```

如果无法安装 SDK 最新版本，运行以下命令更新本地的 CocoaPods 仓库列表：

```objectivec
pod repo update
```

使用 CocoaPods 过程中可能遇见的问题：

1. 无法用 CocoaPods 下载到最新的 SDK

   - 检查网络环境，若使用默认源及淘宝源均无法下载，可尝试使用 **Ruby China** 源：[https://gems.ruby-china.com](https://gems.ruby-china.com)。

2. 使用 CocoaPods 更新 SDK 后编译报错

   - 需检查下载的 SDK 中三个 .a 静态库文件大小，若明显偏小，则需安装 **Git LFS**（Large File Storage）服务来下载原始 SDK。

   - 可使用 Homebrew 安装 Git LFS：

     ```shell
     brew install git-lfs
     ```

   - 启动 Git LFS：

     ```shell
     git lfs install
     ```

   - 安装后请重新 pod update，若仍报错，尝试清理缓存：pod cache clean --all 。

#### 解决符号冲突

从 V3.1.0 版本开始，不再提供 QIYU_iOS_SDK_Exclude_Libcrypto、QIYU_iOS_SDK_Exclude_NIM 版本，统一使用 **QIYU_iOS_SDK**，此 SDK 中独立第三方库，提供3个静态库文件：libQYSDK.a、libcrypto.a、libevent.a。请注意：

1. 如果您同时使用了网易云信 iOS SDK，请只导入 libQYSDK.a，不要导入其他两个 .a 文件。
2. 如果您同时使用了 **OpenSSL** 库，或者您集成的其它静态库使用了 OpenSSL 库（比如支付宝 SDK ），请只导入 libQYSDK.a、libevent.a，不要导入 libcrypto.a。
   - 请注意，SDK 依赖的 OpenSSL 库版本为 **1.0.2d**，与 1.1.0 及以上版本存在兼容问题。
   - 如遇版本兼容问题，我们提供升级版本 SDK ：<a :href="$withBase('/res/QIYU_iOS_SDK_SSL_v5.7.0.zip')">**QIYU_iOS_SDK_SSL**</a> ，依赖的 OpenSSL 库版本为 **1.1.0c**  ，请下载后不要导入 libcrypto.a。此 SDK 跟随每次版本发布更新。
3. 如果是其他情况的冲突，请根据实际情况有选择的导入 libevent.a、libcrypto.a。

#### 权限设置

在 **Info.plist** 中加入以下内容：

```objectivec
<key>NSPhotoLibraryUsageDescription</key>
<string>需要读取相册权限</string>
<key>NSCameraUsageDescription</key>
<string>需要相机权限</string>
<key>NSMicrophoneUsageDescription</key>
<string>需要麦克风权限</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>需要写入相册权限</string>
```

如果不加，会引发 crash。请注意，iOS11 新增写入相册数据权限 `NSPhotoLibraryAddUsageDescription`。

#### https相关

V3.1.3 版本开始，SDK 已全面支持 https，但是聊天消息中可能存在链接，点击链接会用 `UIWebView` 打开，链接地址有可能是 http 的，为了能够正常打开，需要增加配置项。在 **Info.plist** 中加入以下内容：

```objectivec
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSAllowsArbitraryLoadsInWebContent</key>
    <true/>
</dict>
```

加了这些配置项，在 iOS9 下，系统仅读取 `NSAllowsArbitraryLoads`，会放开所有 http 请求；在 iOS10 及以上系统，设置了 `NSAllowsArbitraryLoadsInWebContent`，就会忽略 `NSAllowsArbitraryLoads`，效果是只允许 `WKWebView` 中使用 http。SDK 消息流链接默认使用 `UIWebView` 打开，可通过截获链接点击事件使用自定义网页视图。

#### 类库说明

SDK 主要提供以下类/协议/方法：

|         类/协议         |      描述      |                      说明                      |
| :---------------------: | :------------: | :--------------------------------------------: |
|        QYHeaders        |   头文件集合   |         集合了非平台企业客服功能头文件         |
|          QYSDK          |   SDK 主入口   | 提供初始化/注册/注销/界面及配置对象获取等方法  |
| QYSessionViewController | 聊天界面控制器 | 聊天主界面，同时提供各类参数设置及部分功能接口 |
|    QYCustomUIConfig     |   UI 配置类    |                  样式相关设置                  |
|  QYCustomActionConfig   |   事件配置类   |                  事件相关设置                  |
|  QYConversationManager  |   会话管理类   |     负责获取会话列表及消息未读数并监听变化     |
|        QYSource         |   窗口来源类   |    会话窗口来源，包含标题、URL 及自定义信息    |
|       QYUserInfo        |   用户信息类   |           用户信息，包含ID及详细信息           |
|       QYStaffInfo       |   客服信息类   |      人工客服信息，可替换人工客服部分信息      |
|      QYMessageInfo      |     消息类     |          包含消息类型、时间及文本信息          |
|      QYSessionInfo      |   会话详情类   | 会话列表中会话详情，包含会话状态、未读数等信息 |
|     QYCommodityInfo     |   商品信息类   |            包含商品标题、描述等信息            |
|      QYPushMessage      |   推送消息类   |            包含消息类型、头像等信息            |
|        QYAction         |   通用事件类   |   定义部分通用事件回调，例如请求客服相关事件   |
|      QYEvaluation       |   评价数据类   |       定义满意度评价数据、选项数据及结果       |

自定义消息相关：

|            类/协议            |         描述         |             说明             |
| :---------------------------: | :------------------: | :--------------------------: |
|          QYCustomSDK          | 自定义消息头文件集合 |  集合了自定义消息功能头文件  |
| QYCustomSessionViewController |  聊天界面控制器分类  | 提供自定义消息专用属性及接口 |
|    QYCustomMessageProtocol    |    自定义消息协议    |    事件委托/视图点击协议     |
|        QYCustomMessage        |    自定义消息基类    |  承载消息数据，可继承并扩展  |
|         QYCustomModel         |      数据源基类      | 消息列表数据源，可继承并扩展 |
|      QYCustomContentView      |     消息视图基类     |  消息对应视图，可继承并扩展  |
|         QYCustomEvent         |      消息事件类      |        消息内点击事件        |

平台企业相关：

|          类/协议           |        描述        |                说明                |
| :------------------------: | :----------------: | :--------------------------------: |
|          QYPOPSDK          | 平台企业头文件集合 |    集合了平台企业相关功能头文件    |
| QYPOPSessionViewController | 聊天界面控制器分类 |     提供平台企业专用属性及接口     |
|  QYPOPConversationManager  |   会话管理类分类   | 提供平台企业会话管理专用接口及协议 |
|      QYPOPMessageInfo      |     消息类分类     |     提供平台企业专用属性及接口     |
|      QYPOPSessionInfo      |   会话详情类分类   |     提供平台企业专用属性及接口     |

#### 其它说明

* 为保证系统兼容性，请使用 V3.11.0 以上版本。
* 为保证 SDK 在 iOS13 上效果，请尽量使用 V5.3.0 以上版本；SDK 已针对暗黑模式下的部分显示问题、推送 DeviceToken 解析方式、页面 modalPresentationStyle 做了更新和适配。
* SDK 支持 Bitcode。
* 由于 SDK 是静态库，且为了方便开发者使用，我们将 armv7、arm64、i386、x86_64 平台的静态库合并成一个 Fat Library，导致整个 SDK 比较大。但实际编译后大约只会增加 App **4-5M** 大小。
* 在需要使用 SDK 的地方 `import "QYSDK.h"`。

### 初始化SDK

在使用 SDK 任何方法前，都应先调用初始化方法。正常业务情况下，初始化方法有且只应调用一次。推荐在 App 启动时进行初始化操作：

```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ...
    [[QYSDK sharedSDK] registerAppId:AppKey appName:App名称];
    ...
}
```
1. AppKey 可在 **管理端-应用-在线系统-设置-在线接入-APP-2.App Key** 找到，请确保填写完整及正确，无空格，否则可能导致功能异常。
2. AppName 对应管理端添加 App 时填写的 App名称。如需使用访客分流等功能，请及时在管理端添加 App，并填写正确的 bundleID 用于区分不同 App；如需使用推送功能，请选择相应环境上传对应推送证书，请自行确保证书有效性。
3. 一般在`application: didFinishLaunchingWithOptions:`方法中调用初始化方法，如需在其他地方调用，请确保时机在启动客服功能前，且应预留一段初始化时间；尽量保证在整个软件运行期间仅调用一次。

### 集成聊天组件

通过`[QYSDK sharedSDK]`单例的`sessionViewController`方法可获取聊天界面控制器实例：

```objectivec
[[QYSDK sharedSDK] sessionViewController];
```

1. 获取界面实例后，必须嵌入至导航栏控制器`UINavigationController`中，便可获得完整聊天窗口及所有功能。
2. `QYSessionViewController`会使用到导航栏`navigationItem`的标题文字属性`title`、标题视图属性`titleView`、右侧按钮属性`rightBarButtonItems`，若使用自定义导航栏，请确保以上属性能正常设置，否则会影响部分功能。
3. 每次调用`[QYSDK sharedSDK]`单例的`sessionViewController`方法，都会新建一个聊天页面，请确保`QYSessionViewController`实例同一时刻全局唯一，且退出后该界面实例能够正常释放，尽量避免循环引用导致的内存泄漏，否则会引发一系列不可预知问题。

#### 方式一

如果调用代码所在的视图控制器在`UINavigationController`中，可 **push** 进入聊天界面：


```objectivec
QYSource *source = [[QYSource alloc] init];
source.title = @"七鱼客服";
source.urlString = @"https://qiyukf.com/";

QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
sessionViewController.sessionTitle = @"七鱼客服";
sessionViewController.source = source;
sessionViewController.hidesBottomBarWhenPushed = YES;
[self.navigationController pushViewController:sessionViewController animated:YES];
```

#### 方式二

如果调用代码所在的视图控制器不在`UINavigationController`中，可 **present** 进入聊天界面：

```objectivec
QYSource *source = [[QYSource alloc] init];
source.title = @"七鱼客服";
source.urlString = @"https://qiyukf.com/";

QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
sessionViewController.sessionTitle = @"七鱼客服";
sessionViewController.source = source;
UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sessionViewController];
[self presentViewController:nav animated:YES completion:nil];
```
一般来说，present 方式需要在左上角加返回按钮：

```objectivec
UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
sessionViewController.navigationItem.leftBarButtonItem = leftItem;
```

`onBack:`的样例：

```objectivec
- (void)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
```

请根据情况选择合适的方式进入聊天界面。

#### 常见问题
1. 进入访客聊天界面马上 crash
   - 检查 App **工程配置-Build Phases-copy Bundle Resources** 里是否添加 QYResource.bundle；一般来讲，导入时会自动添加，如果没有，必须加上。

2. 一直显示正在连接客服
   - 可能是 AppKey 填写错误，请确保完全正确，勿带空格。
   - 可能是 App 引入或 App 使用的第三方 SDK 引入 OpenSSL 版本不兼容，导致底层数据加解密抛异常；关于 OpenSSL 版本问题请具体情况具体分析。

3. 导航栏可以自定义吗
   - 部分自定义。聊天界面会占用导航栏`navigationItem`的标题文字属性`title`、标题视图属性`titleView`、右侧按钮属性`rightBarButtonItems`；`navigationItem`的其它部分，比如`leftBarButtonItems`等，可以根据需要做自定义。

4. 聊天界面可以自定义吗
   - 部分样式及事件自定义。 具体可参考`QYCustomUIConfig`等配置类，Demo 源码中也有相关样例代码。

5. 键盘出现异常

   - 检查 App 中是否用到了会影响全局的键盘处理，如果是这种情况，需要对`QYSessionViewController`做屏蔽。典型的比如第三方键盘库`IQKeyboardManager`，如果用的是 V4.0.4 以前的版本（不包括 V4.0.4 ），请添加以下屏蔽代码：

     ```objectivec
     [[IQKeyboardManager sharedManager] disableDistanceHandlingInViewControllerClass:[QYSessionViewController class]];
     ```
     如果用的是 V4.0.4 或之后的版本，请添加以下屏蔽代码：

     ```objectivec
     [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[QYSessionViewController class]];
     ```

6. 如何强制竖屏

   - 如果您的 App 是横屏的，但希望聊天界面竖屏，可以在`sessionViewController`所在的`UINavigationController`中实现以下方法，返回`UIInterfaceOrientationMaskPortrait`即可：

     ```objectivec
     - (UIInterfaceOrientationMask)supportedInterfaceOrientations {
         return UIInterfaceOrientationMaskPortrait;
     }
     ```

7. 怎么知道聊天界面控制器被 pop 了

   - 请参考`UINavigationControllerDelegate`中提供的转场函数：

     ```objectivec
     - (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;
     ```

## CRM对接

网易七鱼系统可在访客匿名状态下使用，同时提供对接企业 CRM 系统能力。轻量对接是指企业产品客户端（或网站）在获取到用户账号信息之后，将访客信息作为参数传递给网易七鱼系统，数据将展现在客服工作界面的当前会话和历史会话的 **用户资料** 标签下。

### 上报用户信息

`QYUserInfo`类用于承载用户信息，提供如下属性：

| 属性   | 类型     | 必须 | 说明                                   |
| ------ | -------- | ---- | -------------------------------------- |
| userId | NSString | 是   | 用户唯一性标识                         |
| data   | NSString | 是   | 数组 JSON 字符串形式，展示在客服端信息 |

其中`data`属性采用数组的 JSON 字符串形式描述用户详细信息，数组中每个元素代表一个数据项，数据项以`<key, value>`对形式为基础，增加了额外字段以控制显示样式，具体可参考 [网易七鱼企业信息对接开发指南](../crm/qiyu_crm_interface.html) 。

获取`[QYSDK sharedSDK]`单例后，调用如下接口上传用户信息：

```objectivec
/**
 *  设置个人信息。用户帐号登录成功之后，调用此函数
 *  注意：此方法尽量在账号登录成功后调用，而不应仅在进入客服界面时调用；否则可能会造成客服连接状态不稳定
 *
 *  @param userInfo 个人信息
 */
- (void)setUserInfo:(QYUserInfo *)userInfo;

/**
 *  设置个人信息，带authToken校验。用户帐号登录成功之后，调用此函数
 *
 *  @param userInfo 个人信息
 *  @param block authToken校验结果的回调
 */
- (void)setUserInfo:(QYUserInfo *)userInfo authTokenVerificationResultBlock:(QYCompletionWithResultBlock)block;
```

其中`setUserInfo: authTokenVerificationResultBlock:` 方法回调 AuthToken 校验结果，AuthToken 可通过`[QYSDK sharedSDK]`单例的如下接口设置：

```objectivec
/**
 *  设置authToken
 */
- (void)setAuthToken:(NSString *)authToken;
```

### 注销用户

App 退出账号时须调用 SDK 的注销操作。由`[QYSDK sharedSDK]`单例提供接口：

```objectivec
[[QYSDK sharedSDK] logout:^(BOOL success) {}];
```

该接口仅在用户退出账号或是账号过期等情况下调用，应避免频繁调用造成反复创建账号。

### 常见问题

1. 因`setUserInfo:`调用时机导致的客服连接状态不稳定
   - `setUserInfo:`标准使用方法为 App 账号登录成功后，将拿到的账号信息构建成`QYUserInfo`对象进行上报。由于数据上报需要时间，加上不同的`userId`可能会导致通信底层账号切换，故当此方法调用时机与连接客服时机较近时，可能会导致无法连接客服问题，请及时调整接口调用时机。

## 消息推送

### APNs推送

#### 配置证书

详细的证书制作及上传请参考文档：[制作推送证书并在管理后台配置](./iOS_apns.html "target=_blank") 。

#### 注册推送服务

需在 App 启动时注册推送服务：

```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ...
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
    ...
}
```

注意 iOS10 及以上系统推送相关 API 变化较大，可分系统做注册处理。

获取到设备的 DeviceToken 后，传给 SDK：

```objectivec
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    ...
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
    ...
}
```

#### 常见问题

1. 无法正常推送

   - 检查管理端 App接入 中是否配置过推送证书 p12 文件，此证书是否就是此 App bundleID 关联的推送证书。

   - 检查初始化时填的 AppName 是否和管理端 添加一个App 时填写的 App名称 一致。

   - 检查证书的线上、测试环境是否跟管理后台配置的相同。请注意，若您想同时在 Debug 包和 Release 包中均接收推送消息，应添加两个 App，分别填入不同的名称并上传线上环境和测试环境的证书，同时在注册 AppKey 的地方这样写代码：

     ```objectivec
     #if DEBUG
         [[QYSDK sharedSDK] registerAppId:Appkey appName:Debug包App名称];
     #else
         [[QYSDK sharedSDK] registerAppId:Appkey appName:Release包App名称];
     #endif
     ```

   - 检查 provision profile 是否包含了推送证书。
   - 检查推送证书中是否有 p12 文件。
   - 检查代码调试是否可以获取到 DeviceToken。
   - 使用第三方推送工具（例如 Pusher ）检查是否可以正常推送，如果不能，说明可能是证书本身的问题。

2. 可以同时使用第三方推送工具吗

   - 可以同时使用第三方推送工具和 SDK 的消息推送，两者可以共存，不会有任何冲突。

3. 能否区分出哪些推送消息是来自七鱼的

   - 所有来自七鱼的推送消息中`payload`都带有`nim:1`，以此可判断是否为七鱼的推送消息。

### 七鱼系统推送

七鱼系统推送与苹果的 APNs 推送无关。开发者可以主动要求服务器推送指定ID的消息，调用`[QYSDK sharedSDK]`单例接口：

```objectivec
/**
 *  获取推送消息
 *
 *  @param messageId 消息id
 */
- (void)getPushMessage:(NSString *)messageId;
```

同时，需注册推送消息通知回调：

```objectivec
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

收到服务器返回的消息后，进行界面展示；无论是主动获取的消息还是管理后台主动推送的消息，均采用统一接口回调。

## 自定义样式

iOS SDK 提供聊天界面部分样式自定义，通过`[QYSDK sharedSDK]`单例的`customUIConfig`方法获取`QYCustomUIConfig`自定义UI配置类，该类为单例模式。

### 属性列表

提供如下属性：

| 属性                              | 类型        | 默认       | 说明                       |
| --------------------------------- | ----------- | ---------- | -------------------------- |
| sessionBackground                 | UIImageView | nil-纯灰底 | 消息 tableview 的背景图片  |
| themeColor                        | UIColor     | 七鱼蓝     | 聊天页面主题色             |
| rightItemStyleGrayOrWhite         | BOOL        | YES-灰色   | 导航栏右侧按钮风格         |
| showCloseSessionEntry             | BOOL        | NO-隐藏    | 导航栏右侧退出会话按钮     |
| showHeadImage                     | BOOL        | YES-显示   | 消息流头像                 |
| showTopHeadImage                  | BOOL        | NO-隐藏    | 导航栏客服头像             |
| customerHeadImage                 | UIImage     | 默认头像   | 访客头像图片               |
| customerHeadImageUrl              | NSString    | nil        | 访客头像URL                |
| customerMessageBubbleNormalImage  | UIImage     | 默认气泡   | 访客消息气泡图片           |
| customerMessageBubblePressedImage | UIImage     | 默认气泡   | 访客消息气泡图片-按下      |
| customMessageTextColor            | UIColor     | 白色       | 访客文本消息字体颜色       |
| customMessageHyperLinkColor       | UIColor     | 白色       | 访客文本消息链接字体颜色   |
| customMessageTextFontSize         | CGFloat     | 16         | 访客文本消息字体大小       |
| serviceHeadImage                  | UIImage     | 默认头像   | 客服头像图片               |
| serviceHeadImageUrl               | NSString    | nil        | 客服头像URL                |
| serviceMessageBubbleNormalImage   | UIImage     | 默认气泡   | 客服消息气泡图片           |
| serviceMessageBubblePressedImage  | UIImage     | 默认气泡   | 客服消息气泡图片-按下      |
| serviceMessageTextColor           | UIColor     | 深灰色     | 客服文本消息字体颜色       |
| serviceMessageHyperLinkColor      | UIColor     | 七鱼蓝     | 客服文本消息链接字体颜色   |
| serviceMessageTextFontSize        | CGFloat     | 16         | 客服文本消息字体大小       |
| tipMessageTextColor               | UIColor     | 白色       | 提示文本消息字体颜色       |
| tipMessageTextFontSize            | CGFloat     | 12         | 提示文本消息字体大小       |
| bypassDisplayMode                 | NSInteger   | 底部       | 访客分流展示模式           |
| sessionMessageSpacing             | CGFloat     | 0          | 消息竖直方向间距           |
| headMessageSpacing                | CGFloat     | 4          | 头像与消息气泡间距         |
| messageButtonTextColor            | UIColor     | 白色       | 消息内强提示按钮文字颜色   |
| messageButtonBackColor            | UIColor     | 七鱼蓝     | 消息内强提示按钮底色       |
| actionButtonTextColor             | UIColor     | 灰色       | 输入框上方操作按钮文字颜色 |
| actionButtonBorderColor           | UIColor     | 灰色       | 输入框上方操作按钮边框颜色 |
| inputTextColor                    | UIColor     | 深灰色     | 输入框字体颜色             |
| inputTextFontSize                 | CGFloat     | 14         | 输入框字体大小             |
| inputTextPlaceholder              | NSString    | 默认文案   | 输入框占位文案             |
| showAudioEntry                    | BOOL        | YES-显示   | 输入栏语音按钮-人工        |
| showAudioEntryInRobotMode         | BOOL        | YES-显示   | 输入栏语音按钮-机器人      |
| showEmoticonEntry                 | BOOL        | YES-显示   | 输入栏表情按钮             |
| showImageEntry                    | BOOL        | YES-显示   | 输入栏相机按钮             |
| imagePickerColor                  | UIColor     | 七鱼蓝     | 照片/视频选择页面主题颜色  |
| autoShowKeyboard                  | BOOL        | YES-弹出   | 自动弹出键盘               |
| bottomMargin                      | CGFloat     | 0          | 聊天页面距离界面底部间距   |
| showShopEntrance                  | BOOL        | NO-隐藏    | 导航栏右侧商铺入口按钮     |
| showSessionListEntrance           | BOOL        | NO-隐藏    | 会话列表入口按钮           |
| sessionListEntranceImage          | UIImage     | nil        | 会话列表入口图片           |
| sessionListEntrancePosition       | BOOL        | YES-右上角 | 会话列表入口位置           |
| sessionTipTextColor               | UIColor     | 橘色       | 会话窗口上方提示条字体颜色 |
| sessionTipTextFontSize            | CGFloat     | 14         | 会话窗口上方提示条字体大小 |
| sessionTipBackgroundColor         | UIColor     | 黄色       | 会话窗口上方提示条背景颜色 |
| customInputItems                  | NSArray     | nil-无     | 输入栏更多按钮展开项       |

### 接口列表

提供如下接口：

| 接口                                       | 说明                                           |
| ------------------------------------------ | ---------------------------------------------- |
| restoreToDefault                           | 恢复默认设置                                   |
| setMessagesLoadImages: duration: forState: | 消息下拉刷新loading图片设置，区分不同state状态 |

### 配置更多按钮

V4.4.0 版本后，聊天界面输入栏 **相机** 按钮可替换为 **更多** 按钮，点击按钮显示半屏页面，放置自定义按钮；按钮数组通过`QYCustomUIConfig`的`customInputItems`属性配置，数组元素为`QYCustomInputItem`对象，该类提供如下配置项：

| 属性          | 类型                   | 必须 | 说明                  |
| ------------- | ---------------------- | ---- | --------------------- |
| normalImage   | UIImage                | 否   | 按钮图片（64pt）      |
| selectedImage | UIImage                | 否   | 按钮图片-按下（64pt） |
| text          | NSString               | 否   | 按钮标题              |
| block         | QYCustomInputItemBlock | 否   | 点击事件回调          |

为达到最佳效果，建议按钮图片宽高均为64pt。目前SDK对外开放了发送**文本**、**图片**、**视频**、**商品**、**订单**等能力，可自由选择使用。配置`customInputItems`样例代码：

```objectivec
/**
 * 相册/拍摄功能可直接调用UIImagePickerController，也可自定义界面，选择照片后调用接口发送图片消息即可
 */
QYCustomInputItem *photoItem = [[QYCustomInputItem alloc] init];
photoItem.normalImage = [UIImage imageNamed:@"icon_photo_normal"];
photoItem.selectedImage = [UIImage imageNamed:@"icon_photo_pressed"];
photoItem.text = @"相册";
photoItem.block = ^{ };

QYCustomInputItem *cameraItem = [[QYCustomInputItem alloc] init];
cameraItem.normalImage = [UIImage imageNamed:@"icon_camera_normal"];
cameraItem.selectedImage = [UIImage imageNamed:@"icon_camera_pressed"];
cameraItem.text = @"拍摄";
cameraItem.block = ^{ };

[[QYSDK sharedSDK] customUIConfig].customInputItems = @[photoItem, cameraItem];
```

### 配置消息加载动效

V5.0.0 版本后，SDK 支持自定义历史消息下拉加载动效，需提供不同状态下图片数组，目前下拉加载状态有三种：空闲/即将加载/加载中，可提供不同动效图片组来实现不同状态加载动效。

```objectivec
/**
 *  消息下拉加载状态
 */
typedef NS_ENUM(NSInteger, QYMessagesLoadState) {
    QYMessagesLoadStateIdle,
    QYMessagesLoadStateWillLoad,
    QYMessagesLoadStateLoading,
};
```

使用样例：

```objectivec
[[[QYSDK sharedSDK] customUIConfig] setMessagesLoadImages:@[idleImg]
                                                 duration:0
                                                 forState:QYMessagesLoadStateIdle];
[[[QYSDK sharedSDK] customUIConfig] setMessagesLoadImages:@[willImg]
                                                 duration:0
                                                 forState:QYMessagesLoadStateWillLoad];
NSArray *loadingArray = @[loadingImg_1, loadingImg_2, loadingImg_3, loadingImg_4];
[[[QYSDK sharedSDK] customUIConfig] setMessagesLoadImages:loadingArray
                                                 duration:0.2
                                                 forState:QYMessagesLoadStateLoading];
```

### 管理端样式设置

V5.2.0 版本后，新增后台样式设置功能，位于 **管理端-应用-在线系统-设置-访客端-样式设置-APP端** ，可根据企业需要配置。如需使用该功能，应首先开启 **后台样式设置** 开关，注意此开关变更非实时生效，接口24小时请求一次。

在可配置的样式中，**主题色**、**客服头像位置**、**输入框暗文**、**语音/表情按钮显示** 跟随总开关配置，24小时生效；其他的 **导航栏右侧按钮**、**企业客服头像**、**输入框快捷入口**、**+扩展按钮** 配置可跟随会话实时生效。

开启 **后台样式设置** 后，应注意**后台设置优先级高于代码设置优先级**；即开启后，代码层面的属性`themeColor`、`customerHeadImage`、`customerMessageBubbleNormalImage`、`customerMessageBubblePressedImage`、`messageButtonBackColor`、`imagePickerColor`、`showHeadImage`、`showTopHeadImage`、`inputTextPlaceholder`、`showAudioEntry`、`showAudioEntryInRobotMode`、`showEmoticonEntry`、`actionButtonBorderColor`均设置无效，**导航栏右侧按钮**、**输入框快捷入口**、**+扩展按钮** 全部以管理端配置为准。

### 更换图片素材

七鱼 iOS SDK 支持所有图片素材的替换。开发者需要新建资源文件`QYCustomResource.bundle`，在其中放置与 `QYResource.bundle`同名的图片素材，即可实现替换。为保证最佳效果，应替换同等尺寸图片。

## 功能配置

七鱼客服系统主要功能配置由主页面控制器`QYSessionViewController`提供，可配置机器人客服、人工客服、消息加载等功能，同时对外开放了部分能力。

### 会话来源

针对不同的会话场景，可在进入聊天页面时设置不同的会话来源信息，与客服建立联系后，客服可在会话窗口右侧 **访问信息-会话页** 查看来源信息。样例如下：

```objectivec
QYSource *source = [[QYSource alloc] init];
source.title = @"七鱼客服";
source.urlString = @"https://qiyukf.com/";
sessionViewController.source = source;
```

请注意，代码中的`sessionViewController`均指代由`[QYSDK sharedSDK]`单例的`sessionViewController`方法新建的聊天界面控制器实例。

会话来源`QYSource`类提供了如下属性：

| 属性       | 类型     | 必须 | 说明           |
| ---------- | -------- | ---- | -------------- |
| title      | NSString | 否   | 来源标题       |
| urlString  | NSString | 否   | 来源链接       |
| customInfo | NSString | 否   | 来源自定义信息 |

### 机器人客服

#### 指定机器人

若企业开通了机器人，且不止一个，可在聊天页面入口匹配不同机器人，提高服务效率。通过配置`sessionViewController`的`robotId`属性指定机器人，样例如下：

```objectivec
sessionViewController.robotId = 123456;
```

指定ID后，进入聊天页面时，会直接以此ID去请求对应的机器人客服。

机器人客服ID查询：**管理端-应用-机器人-在线机器人**

#### 指定常见问题

用户进入机器人会话时，可以收到设置的一组常见问题，不同聊天入口可配置不同常见问题模板，提高咨询效率。通过配置`sessionViewController`的`commonQuestionTemplateId`属性指定问题模板，样例如下：

```objectivec
sessionViewController.commonQuestionTemplateId = 123456;
```

指定ID后，进入聊天页面联系客服时会带上问题模板ID参数，服务端下发对应的常见问题消息。

常见问题模板ID查询：**管理端-应用-机器人-在线机器人-设置-常见问题-设置常见问题模板**

#### 指定欢迎语

用户进入机器人会话时，可收到欢迎语；V5.5.0 版本后，不同聊天入口可配置不同欢迎语模板，以适应更多场景。通过配置`sessionViewController`的`robotWelcomeTemplateId`属性指定欢迎语模板，样例如下：

```objectivec
sessionViewController.robotWelcomeTemplateId = 123456;
```

指定ID后，进入聊天页面联系客服时会带上欢迎语模板ID参数，服务端下发对应的欢迎语消息。

机器人欢迎语模板ID查询：**管理端-应用-机器人-在线机器人-设置-基础设置-引导语设置-欢迎语-手机端-设置**

### 人工客服

#### 指定客服

若企业有多个咨询入口，为提高咨询效率，可在不同咨询入口设置对应的人工客服接待。通过配置`sessionViewController`的`staffId`属性指定人工客服，样例如下：

```objectivec
sessionViewController.staffId = 123456;
```

指定ID后，进入聊天页面时，会直接以此ID去请求对应的人工客服。

人工客服ID查询：**管理端-应用-在线系统-设置-会话流程-会话分配-ID查询-客服及客服组ID查询**

指定客服ID后，进入聊天页面时会默认跳过机器人客服直接连接人工客服；如果希望先连接机器人客服，转人工时再连接指定的人工客服，可通过配置如下属性：

```objectivec
sessionViewController.openRobotInShuntMode = YES;
```

默认为NO。

#### 指定客服组

若企业有多个咨询入口，为提高咨询效率，可在不同咨询入口设置对应的人工客服组接待。通过配置`sessionViewController`的`groupId`属性指定客服组，样例如下：

```objectivec
sessionViewController.groupId = 123456;
```

指定ID后，进入聊天页面时，会直接以此ID去请求对应的客服组，服务组会随机分配客服组中可用客服接待。

客服组ID查询：**管理端-应用-在线系统-设置-会话流程-会话分配-ID查询-客服及客服组ID查询**

指定客服组ID后，进入聊天页面时会默认跳过机器人客服直接连接客服组内人工客服；如果希望先连接机器人客服，转人工时再连接指定的客服组，可通过配置如下属性：

```objectivec
sessionViewController.openRobotInShuntMode = YES;
```

默认为NO。

#### 指定客服信息

V4.6.0 版本之后，新增自定义人工客服信息功能，配置完成后该入口人工客服的昵称、头像、接入语等均会被设置的信息替换。样例如下：

```objectivec
QYStaffInfo *staffInfo = [[QYStaffInfo alloc] init];
staffInfo.staffId = @"123456";
staffInfo.nickName = @"七鱼客服";
staffInfo.iconURL = @"客服头像链接";
staffInfo.accessTip = @"七鱼客服为您服务";
staffInfo.infoDesc = @"系统提示：当前用户选择了七鱼客服";
sessionViewController.staffInfo = staffInfo;
```

客服信息`QYStaffInfo`类提供了如下属性：

| 属性      | 类型     | 必须 | 说明                 |
| --------- | -------- | ---- | -------------------- |
| staffId   | NSString | 是   | 客服ID，限制20字符   |
| nickName  | NSString | 否   | 客服昵称，限制20字符 |
| iconURL   | NSString | 否   | 客服头像URL          |
| accessTip | NSString | 否   | 接入提示，限制50字符 |
| infoDesc  | NSString | 否   | 客服信息描述         |

请注意，必须配置`staffId`信息，且应保证标识唯一性，用以区分不同客服信息。昵称、头像、接入提示若没有配置则按原逻辑显示。客服信息描述字段`infoDesc`用于接入人工客服后隐式向客服发送消息的文本，访客端无感知。

#### 主动请求客服

V4.4.0 版本之后，新增主动请求人工客服接口：

```objectivec
/**
 *  请求人工客服
 */
- (void)requestHumanStaff;
```

该接口仅在当前无会话或机器人模式下才能主动请求人工客服，否则无效。 

#### 主动切换客服

V4.6.0 版本之后，新增主动切换人工客服接口：

```objectivec
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

切换客服逻辑为自动结束当前会话，并使用设置的 `staffId`或`groupId`去请求新的人工客服；在结束当前会话时，消息流中会展示提示消息 **您退出了咨询**，此文案可通过设置接口中的`closetip`来替换。 

#### 主动结束会话

V5.2.0 版本之后，新增主动结束会话/退出排队接口：

```objectivec
/**
 *  退出会话/退出排队
 *  @param popViewController 是否退出聊天界面，设置为YES，无论退出是否成功均退出聊天界面
 *  @param completion 退出完成回调
 */
- (void)closeSession:(BOOL)popViewController completion:(QYCompletion)completion;
```

结束逻辑为判断当前会话状态，若处在会话中，则退出当前会话；若处在排队流程中，则效果相当于点击 **取消排队** 按钮，退出排队。

### 访客信息

#### 访客等级

`sessionViewController`提供访客 **VIP** 等级设置：

```objectivec
sessionViewController.vipLevel = 1;
```

默认为非VIP。 

### 商品卡片

#### 商品定义

访客进入不同咨询入口可带入该入口对应的商品信息，以商品卡片消息的形式自动或主动发送，提供多个配置字段并支持点击跳转链接，方便客服直观了解访客咨询内容。商品信息类`QYCommodityInfo`提供如下属性：

| 属性             | 类型     | 必须 | 说明                                      |
| ---------------- | -------- | ---- | ----------------------------------------- |
| show             | BOOL     | 否   | 是否在访客端隐藏，默认隐藏                |
| isCustom         | BOOL     | 否   | 是否自定义-只显示图片，默认否             |
| sendByUser       | BOOL     | 否   | 是否由访客手动发送，默认否                |
| title            | NSString | 否   | 商品标题，限制100字符                     |
| desc             | NSString | 否   | 商品描述，限制300字符                     |
| pictureUrlString | NSString | 否   | 商品图片，限制1000字符                    |
| urlString        | NSString | 否   | 跳转链接，限制1000字符                    |
| note             | NSString | 否   | 备注信息-可用于价格/订单号等，限制100字符 |
| tagsArray        | NSArray  | 否   | 商品卡片标签按钮，限制3个                 |
| tagsString       | NSString | 否   | 商品卡片标签按钮，限制3个，二选一         |
| actionText       | NSString | 否   | 访客手动发送按钮文案                      |
| actionTextColor  | UIColor  | 否   | 访客手动发送按钮文案颜色                  |
| ext              | NSString | 否   | 附加信息，透传数据                        |

需要注意的是，默认访客端隐藏商品卡片；商品卡片展现形式分为两种，默认所有字段均展示，若isCustom设置为YES，则仅展示商品图片；卡片下方可携带标签按钮，但按钮仅在客服端显示，访客端无需显示。

样例如下：

```objectivec
QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
commodityInfo.show = YES;
commodityInfo.title = @"网易七鱼";
commodityInfo.desc = @"网易七鱼是网易旗下一款专注于解决企业与客户沟通的客服系统产品。";
commodityInfo.pictureUrlString = @"http://qiyukf.com/main/res/img/index/barcode.png";
commodityInfo.urlString = @"http://qiyukf.com/";
commodityInfo.note = @"￥10000";

sessionViewController.commodityInfo = commodityInfo;
```

商品卡片点击事件可自定义，具体请查阅文档 **自定义事件** 相关说明。

#### 发送规则

- 若入口设置了商品信息，进入后需等待人工客服连接，成功后自动发送商品卡片消息；若企业开启机器人，默认不发送给机器人客服，转人工客服后再发送，该逻辑可通过配置`sessionViewController`的`autoSendInRobot`属性修改为机器人可接收商品卡片消息。
- 若设置了商品信息，同时开启了机器人客服及`autoSendInRobot`属性，则进入聊天页面连接上机器人客服后，自动发送商品卡片；之后转人工客服连接成功后，会再次发送商品卡片给人工。
- 会话未结束退出咨询页面后再次进入，会判断商品卡片是否重复，若关键信息重复则不再继续发送，若信息有变化会再次发送。
- 会话未结束，访客App重启，进入同一咨询入口会重复发送一次商品卡片。

#### 自定义商品卡片

客服端可使用 **iframe** 数据向访客端发送商品卡片，此数据为 JSON 格式，由一连串`key-value`组成。若开发者认为 SDK 提供的商品卡片样式不符合预期，则可使用自定义商品卡片功能；在 iframe 数据中新增如下两个字段即可： 

| 属性                | 类型     | 说明                 |
| ------------------- | -------- | -------------------- |
| isOpenCustomProduct | BOOL     | 是否为自定义商品卡片 |
| productCustomField  | NSString | 自定义商品卡片数据   |

当`isOpenCustomProduct`字段配置为`true`时，访客端收到此 iframe 数据后，会通过 block 回调透传`productCustomField`字段内容即自定义卡片数据，该 block 定义在`QYSessionViewController`中：

```objectivec
/** 以下为自定义卡片消息相关接口 **/

/**
 *  自定义卡片消息回调
 *
 *  @param jsonString 自定义卡片消息数据
 */
typedef void (^QYCustomMessageDataBlock)(NSString *jsonString);

/**
 *  自定义卡片消息事件，回调时机为收到该类消息时刻
 */
@property (nonatomic, copy) QYCustomMessageDataBlock customMessageDataBlock;
```

SDK 会忽略此条消息并完全将数据交由外部进行处理，开发者可在收到回调后，使用 **高级功能-自定义消息** 来插入一条本地自定义消息，将提前定义好的 JSON 数据构建为消息对象`QYCustomMessage`子类，并构建对应的数据模型`QYCustomModel`子类、视图`QYCustomContentView`子类。样例如下：

```objectivec
__weak typeof(self) weakSelf = self;
sessionViewController.customMessageDataBlock = ^(NSString *jsonString) {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([object isKindOfClass:[NSDictionary class]]) {
            QYCustomTicketMessage *message = [QYCustomTicketMessage objectByDict:object];
            [weakSelf.sessionViewController addCustomMessage:message
                                                needSaveData:YES
                                              needReloadView:YES
                                                  completion:^(NSError *error) {
                if (error) {
                    NSLog(@"addCustomMessage error !!!");
                }
            }];
        }
    }
};
```

### 会话消息

七鱼客服系统 iOS SDK 默认持久化所有账户的聊天消息至本地数据库，进入聊天页面时从数据库中读取历史消息并显示出来，并非网络拉取。

#### 消息加载规则

默认消息加载规则为**20条**，即进入聊天页面，从数据库中读取最近的20条历史消息进行展示，若不满20条，则全部显示。访客可手动下拉加载更多历史消息，每次加载20条数据。注意20条不仅是普通消息，系统类型消息也包含在内，例如时间消息、接入提示消息等。此加载规则可修改，由`sessionViewController`提供属性：

```objectivec
/**
 *  每页消息加载的最大数量，默认为20条
 */
@property (nonatomic, assign) NSInteger messagePageLimit; 
```

#### 历史消息收起

进入聊天页面后，无论是重新连接客服还是继续上次会话，从数据库读取的历史消息默认全部展示。设置历史消息收起后，进入聊天页面若需重新连接客服，则不会读取和显示历史消息，访客主动下拉加载历史消息后，消息流中新增 **以上为历史消息** 用以区分新旧消息。通过配置`sessionViewController`属性可收起历史消息：

```objectivec
/**
 *  是否收起历史消息，默认为NO；若设置为YES，进入会话界面时若需创建新会话，则收起历史消息
 */
@property (nonatomic, assign) BOOL hideHistoryMessages;
```

同时可自定义提示文案：

```objectivec
/**
 *  历史消息提示文案，默认为“——以上为历史消息——”；仅在hideHistoryMessages为YES，首次下拉历史消息时展示
 */
@property (nonatomic, copy) NSString *historyMessagesTip;
```

#### 漫游消息拉取

七鱼客服系统支持账号信息打通，对于企业通过`setUserInfo:`接口传入的`userId`，服务端会合并不同访客端产生的消息记录。iOS SDK 默认不从服务端拉取漫游消息，仅读取本地数据库持久化数据。若开启漫游消息拉取功能，则在企业调用`setUserInfo:`时会联网请求该`userId`账户对应的漫游历史消息，并与本地数据库进行对比过滤重复数据。漫游功能独立于聊天页面，在`QYCustomActionConfig`单例中配置：

```objectivec
/**
 *  账号登录后是否拉取漫游消息
 */
@property (nonatomic, assign) BOOL pullRoamMessage;
```

默认关闭。 

#### 发送能力

七鱼 iOS SDK 对外提供一些标准能力，针对消息发送开放了文本、图片、视频、文件、商品、订单六种消息类型，企业可调用这些标准能力直接发送对应消息。

##### 文本消息

可直接调用接口发送文本消息，传入字符串：

```objectivec
/**
 *  发送文本消息
 */
- (void)sendText:(NSString *)text; 
```

##### 图片消息

可直接调用接口发送图片消息，传入`UIImage`对象：

```objectivec
/**
 *  发送图片消息
 */
- (void)sendPicture:(UIImage *)picture; 
```

##### 视频消息

V5.2.0 版本之后，可直接调用接口发送视频消息，传入视频存储地址：

```objectivec
/**
 *  发送视频消息
 */
- (void)sendVideo:(NSString *)filePath;
```

同时，七鱼 iOS SDK 还提供**拍摄视频**功能，允许调用内部视频录制界面，注意该界面依赖于客服聊天界面，不可完全脱离此界面调用：

```objectivec
/**
 *  拍摄视频完成回调
 *  @param filePath 视频存储路径
 */
typedef void (^QYVideoCompletion)(NSString *filePath);

/**
 *  拍摄视频
 */
- (void)shootVideoWithCompletion:(QYVideoCompletion)completion;
```

接口提供视频拍摄完成回调，返回视频存储地址，可使用上述`sendVideo:`方法发送此视频给客服，或进行其他特殊化处理。

##### 文件消息

V5.6.0 版本之后，新增发送文件类型消息，需传入文件名称及本地存储路径：

```objectivec
/**
 *  发送文件消息
 */
- (void)sendFileName:(NSString *)fileName filePath:(NSString *)filePath;
```

同时，七鱼 iOS SDK 提供**选择系统文件**功能，使用了`UIDocumentPickerViewController`控制器，并已指定部分常见文件类型，如仍未满足需求，可通过`allowedUTIs`参数补充文件类型：

```objectivec
/**
 *  选择文件完成回调
 *  @param filePath 文件存储路径
 */
typedef void (^QYFileCompletion)(NSString *fileName, NSString *filePath);

/**
 *  选择系统文件，调用系统控件UIDocumentPickerViewController，注意文件功能目前仅支持iOS11以上系统
 *  @param allowedUTIs 需增加支持的文件类型，已有部分默认类型，传nil时采用默认类型组；具体可参照UIDocumentPickerViewController的allowedUTIs参数
 *  @param completion 选择完成回调
 */
- (void)selectFileWithDocumentTypes:(NSArray <NSString *>*)allowedUTIs completion:(QYFileCompletion)completion;
```

调用接口会在客服界面调起系统文件选择页面，选择文件或点击取消后提供完成回调，返回文件名称`fileName`及拷贝至 Documents 目录下的文件路径`filePath`，可调用前面的`sendFileName: filePath:`方法发送文件消息给客服。

请注意，系统文件选择功能目前只支持 **iOS11 及以上系统**，因 iOS11 以下系统只能访问 iCloud 文件，App 需开启 iCloud Documents 功能。

##### 商品消息

与上面进入聊天界面自动发送商品卡片不同，您也可以在任意时刻调用接口主动发送商品消息，传入`QYCommodityInfo`对象：

```objectivec
/**
 *  发送商品信息展示
 */
- (void)sendCommodityInfo:(QYCommodityInfo *)commodityInfo; 
```

##### 订单消息

订单对象`QYSelectedCommodityInfo`提供更多属性字段方便信息展示，包括订单状态`p_status`、价格`p_price`、数量`p_count`、库存`p_stock`等等，接口如下：

```objectivec
/**
 *  发送订单列表中选中的商品信息
 */
- (void)sendSelectedCommodityInfo:(QYSelectedCommodityInfo *)commodityInfo; 
```

### 满意度评价

#### 自定义评价界面

V5.0.0 版本之后，七鱼 iOS SDK 对外提供自定义满意度评价界面，方便客户实现带有企业特色的评价界面。要完成自定义评价功能，首先需修改 **管理端-应用-在线系统-设置-会话流程-满意度评价-样式设置-评价样式** 选项为 **新页面**，此处填入的页面链接对移动端无效。

修改完成后，SDK 会将满意度评价事件以 block 形式抛出，并提供相关满意度数据，随管理端配置更新：

```objectivec
/**
 *  满意度评价事件回调
 *
 *  @param data 评价数据，包括评价模式、选项及标签、上次评价结果等数据，据此构建评价界面
 */
typedef void (^QYEvaluationBlock)(QYEvaluactionData *data);

/**
 *  满意度评价事件
 */
@property (nonatomic, copy) QYEvaluationBlock evaluationBlock;
```

满意度评价数据`QYEvaluactionData`类提供了如下属性：

| 属性             | 类型                | 说明                                             |
| ---------------- | ------------------- | ------------------------------------------------ |
| sessionId        | long long           | 评价会话ID，提交评价结果时需透传                 |
| mode             | NSUInteger          | 评价模式，支持二/三/四/五级模式，管理端配置      |
| optionList       | NSArray             | 选项数据，数组元素为`QYEvaluationOptionData`对象 |
| resolvedEnabled  | BOOL                | 是否向访客收集 “您的问题是否解决”                |
| resolvedRequired | BOOL                | “您的问题是否解决”是否必填                       |
| lastResult       | QYEvaluactionResult | 上次评价结果                                     |

其中，满意度选项数据`QYEvaluationOptionData`类提供如下属性：

| 属性           | 类型       | 说明                                           |
| -------------- | ---------- | ---------------------------------------------- |
| option         | NSUInteger | 选项类型，非常满意/满意/一般/不满意/非常不满意 |
| name           | NSString   | 选项名称                                       |
| score          | NSInteger  | 选项分值                                       |
| tagList        | NSArray    | 标签，每个选项限制10个                         |
| tagRequired    | BOOL       | 标签是否必填                                   |
| remarkRequired | BOOL       | 备注是否必填                                   |

同时提供上次评价结果`QYEvaluactionResult`对象，该对象提供如下属性：

| 属性          | 类型                   | 说明                               |
| ------------- | ---------------------- | ---------------------------------- |
| sessionId     | long long              | 评价会话ID，不可为空               |
| selectOption  | QYEvaluationOptionData | 选中的选项，不可为空               |
| selectTags    | NSArray                | 选中的标签，若标签必填，则不可为空 |
| remarkString  | NSString               | 评价备注，若备注必填，则不可为空   |
| resolveStatus | NSInteger              | 问题是否解决，若必填，则不可为None |

获取到评价数据后，可根据数据配置构建不同模式的评价界面，然后使用`sessionViewController`弹出。

#### 发送评价结果

当用户评价完成后，需将评价结果回传给 SDK，由 SDK 传递数据给后台并进行后续的评价反馈动作，发送结果接口如下：

```objectivec
/**
 *  满意度评价结果返回值
 */
typedef NS_ENUM(NSInteger, QYEvaluationState) {
    QYEvaluationStateSuccessFirst = 1,  //成功-首次评价
    QYEvaluationStateSuccessRevise,     //成功-修改评价
    QYEvaluationStateFailParamError,    //失败-发送参数错误
    QYEvaluationStateFailNetError,      //失败-网络错误
    QYEvaluationStateFailNetTimeout,    //失败-网络超时
    QYEvaluationStateFailTimeout,       //失败-评价超时
    QYEvaluationStateFailUnknown,       //失败-未知原因不可评价
};

/**
 *  评价结果回调
 *
 *  @param state 结果
 */
typedef void (^QYEvaluationCompletion)(QYEvaluationState state);

/**
 *  发送满意度评价结果
 */
- (void)sendEvaluationResult:(QYEvaluactionResult *)result completion:(QYEvaluationCompletion)completion;
```

接口提供评价成功/失败的结果回调，若评价成功，需收起评价界面，若评价失败，可提示用户失败原因。

### 其他

#### 输入栏快捷入口

 七鱼客服聊天界面提供输入栏上方快捷入口设置，区分机器人与人工两种模式。机器人模式下，快捷入口需在企业机器人相关配置页面进行按钮及事件的配置，不同节点可配置不同快捷入口，配置成功后快捷入口自动显示在输入栏上方，且根据配置自动更新，无需代码配置。

人工模式下，快捷入口按钮有两种配置方案，一种通过 **管理端-应用-在线系统-设置-访客端-样式设置-App端-输入框上方快捷入口** 配置按钮，并设置相应事件，注意此功能在 V5.2.0 版本后提供；在后台样式设置关闭情况下，可通过代码配置人工快捷入口。

快捷入口按钮`QYButtonInfo`类提供了如下属性：

| 属性       | 类型                 | 必须 | 说明                                            |
| ---------- | -------------------- | ---- | ----------------------------------------------- |
| buttonId   | id                   | 是   | 快捷入口ID，未限制类型                          |
| title      | NSString             | 否   | 快捷入口标题                                    |
| userData   | id                   | 否   | 透传数据，未限制类型                            |
| actionType | NSUInteger, Readonly | —    | 按钮响应事件传递信息，1-文本/2-链接或自定义行为 |
| index      | NSUInteger, Readonly | —    | 响应按钮位置                                    |

添加按钮的示例代码：

```objectivec
QYButtonInfo *button_1 = [[QYButtonInfo alloc] init];
button_1.buttonId = [NSNumber numberWithLongLong:1001];
button_1.title = @"按钮标题1";

QYButtonInfo *button_2 = [[QYButtonInfo alloc] init];
button_2.buttonId = [NSNumber numberWithLongLong:1002];
button_2.title = @"按钮标题2";

sessionViewController.buttonInfoArray = @[button_1, button_2];
```

#### 顶部悬停视图

V4.7.0 版本中，获取到 `sessionViewController`后，可自定义聊天界面顶部区域，支持外部注册入视图，可配置视图高度和边距；此视图悬停在聊天界面导航栏下方、消息列表上方，不随消息流滚动。注册接口为：

```objectivec
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

```objectivec
/**
 *  销毁聊天界面顶部悬停视图
 */
- (void)destroyTopHoverViewWithAnmation:(BOOL)animated duration:(NSTimeInterval)duration;
```

#### 自助提工单能力

V5.7.0 版本之后，新增人工模式下自助提工单能力，调用此接口效果与后台样式设置中的**创建工单**按钮点击效果一致，根据传入的**工单模板ID**请求工单数据并弹出工单页面，访客填写完成后，点击提交按钮发送工单结果数据，同时消息流会新增一条访客消息：**信息已提交**。接口如下：

```objectivec
/**
 *  弹出工单页面自助提工单
 *  @param templateID 工单模板ID
 */
- (void)presentWorkOrderViewControllerWithTemplateID:(long long)templateID;
```

## 会话管理

七鱼 iOS SDK 提供会话项相关信息，支持多会话，具体见 **平台电商** 相关说明。对于非平台企业，会话项一般只有一项，会话相关管理类`QYConversationManager`单例通过如下方法获取：

```objectivec
[[QYSDK sharedSDK] conversationManager];
```

可获取会话消息未读数、清除未读数、获取会话列表、监听会话项变化等。

### 消息未读数

可通过如下接口主动获取消息的未读数量，用于显示未读红点：

```objectivec
/**
 *  所有的未读数
 *
 *  @return 未读数
 */
- (NSInteger)allUnreadCount;
```

如需收到未读消息数量变化通知，通过如下接口设置委托：

```objectivec
/**
 *  设置会话委托
 *
 *  @param delegate 会话委托
 */
- (void)setDelegate:(id<QYConversationManagerDelegate>)delegate;
```

并实现该委托中如下方法即可监听数量变化：

```objectivec
/**
 *  会话未读数变化
 *
 *  @param count 未读数
 */
- (void)onUnreadCountChanged:(NSInteger)count;
```

该未读数为所有会话项的总未读数，如需分开需获取会话列表。如需清空消息未读数量，请调用如下接口：

```objectivec
/**
 *  清空未读数
 *
 */
- (void)clearUnreadCount;
```

### 会话列表

可通过如下接口主动获取会话列表，用于构建会话列表页面：

```objectivec
/**
 *  获取所有会话的列表；非平台电商用户，只有一个会话项，平台电商用户，有多个会话项
 *
 *  @return 包含SessionInfo的数组
 */
- (NSArray<QYSessionInfo *> *)getSessionList;
```

如需收到会话列表变化通知，实现委托中如下方法即可：

```objectivec
/**
 *  会话列表变化；非平台电商用户，只有一个会话项，平台电商用户，有多个会话项
 */
- (void)onSessionListChanged:(NSArray<QYSessionInfo *> *)sessionList;
```

会话列表数据以数组形式提供，每个数组元素为`QYSessionInfo`对象，提供如下属性：

| 属性                 | 类型           | 说明                                 |
| -------------------- | -------------- | ------------------------------------ |
| lastMessageText      | NSString       | 会话最后一条消息文本                 |
| lastMessageType      | NSInteger      | 消息类型：文本/图片/语音/视频/自定义 |
| unreadCount          | NSInteger      | 会话未读数                           |
| status               | NSInteger      | 会话状态：无/排队中/会话中           |
| lastMessageTimeStamp | NSTimeInterval | 会话最后一条消息时间戳               |
| hasTrashWords        | BOOL           | 是否存在垃圾词汇                     |

### 监听消息接收

如需实时监听消息接收情况，实现协议`QYConversationManagerDelegate`中的如下方法：

```objectivec
/**
 *  接收消息
 */
- (void)onReceiveMessage:(QYMessageInfo *)message;
```

接口提供接收到的最新消息对象`QYMessageInfo`类，该类提供如下属性：

| 属性      | 类型           | 说明                                 |
| --------- | -------------- | ------------------------------------ |
| text      | NSString       | 消息文本                             |
| type      | NSInteger      | 消息类型：文本/图片/语音/视频/自定义 |
| timeStamp | NSTimeInterval | 消息时间戳                           |

## 自定义事件

iOS SDK 提供部分功能事件自定义，通过`[QYSDK sharedSDK]`单例的`customActionConfig`方法获取`QYCustomActionConfig`自定义事件配置类，该类为单例模式。

### 属性列表

`QYCustomActionConfig`主要以回调形式实现事件自定义，提供较多block属性设置：

| 属性                   | 类型                           | 说明                                   |
| ---------------------- | ------------------------------ | -------------------------------------- |
| actionBlock            | QYActionBlock                  | 部分通用动作事件，目前主要用于客服相关 |
| linkClickBlock         | QYLinkClickBlock               | 所有消息中的链接回调                   |
| botClick               | QYBotClickBlock                | 机器人部分模板消息点击事件             |
| pushMessageClick       | QYLinkClickBlock               | 七鱼推送消息点击事件                   |
| showBotCustomInfoBlock | QYShowBotCustomInfoBlock       | 机器人自定义信息回调                   |
| commodityActionBlock   | QYSelectedCommodityActionBlock | 订单卡片按钮点击事件                   |
| extraClickBlock        | QYExtraViewClickBlock          | 消息扩展视图点击事件                   |
| notificationClickBlock | QYSystemNotificationClickBlock | 系统消息点击                           |
| eventClickBlock        | QYEventBlock                   | 消息内部分点击事件数据透传             |
| customButtonClickBlock | QYCustomButtonBlock            | 自定义事件按钮点击事件                 |
| pullRoamMessage        | BOOL                           | 账号登录后是否拉取漫游消息             |

### 接口列表

提供如下接口：

| 接口                                    | 说明                                           |
| --------------------------------------- | ---------------------------------------------- |
| setDeactivateAudioSessionAfterComplete: | 设置录制或者播放语音完成以后是否自动deactivate |
| showQuitWaiting:                        | 显示退出排队提示                               |

### 请求客服事件

V4.6.0 版本后，SDK 完善了客服相关事件的对外接口，可以拦截所有请求客服前和请求客服后的事件，需要设置`QYCustomActionConfig`中的`actionBlock`属性，该`block`返回一个`QYAction`对象，此对象定义如下：

```objectivec
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

```objectivec
/**
 *  动作类型
 */
typedef NS_ENUM(NSInteger, QYActionType) {
    QYActionTypeNone = 0,
    QYActionTypeRequestStaffBefore,     //请求客服前
    QYActionTypeRequestStaffAfter,      //请求客服后
};
```

`QYRequestStaffBeforeBlock`为请求客服前回调的`block`，该事件给出了当前请求客服是何种场景，开发者可针对不同场景做定制化处理，其定义如下：

```objectivec
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

`QYRequestStaffAfterBlock`为请求客服后回调的`block`，其中`info`为新会话的相关信息，包括客服ID、昵称、头像等，`block`定义如下：

```objectivec
/**
 *  请求客服后回调
 *
 *  @param info 会话相关信息
 *  @param error 错误信息
 */
typedef void (^QYRequestStaffAfterBlock)(NSDictionary *info, NSError *error);
```

以下为客服相关事件处理的示例代码：

```objectivec
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

注：在 V4.4.0 版本中，仅可拦截请求客服前事件；若要拦截，请设置`QYCustomActionConfig`中的`requestStaffBlock`，处理完成后，请主动调用该`block`中的`completion`回调，并设置`needed`参数，YES 表示继续请求客服，NO 表示中断请求客服。

## 行为轨迹

### 页面行为轨迹

V4.0.0 版本后，SDK 支持记录用户在 App 内的访问轨迹并上报。使用该功能，需要企业开通 **访问轨迹** 功能。访问轨迹接口定义在 `QYSDK.h`中：

```objectivec
/**
 *  访问轨迹
 *  @param title 标题
 *  @param enterOrOut 进入还是退出
 */
- (void)trackHistory:(NSString *)title enterOrOut:(BOOL)enterOrOut key:(NSString *)key;
```

接口调用示例：

```objectivec
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

### 自定义行为轨迹

V4.4.0 版本后，SDK 支持记录用户在 App 内的行为轨迹并上报。使用该功能，需要企业开通 **行为轨迹** 功能。自定义行为轨迹建立在页面行为轨迹之上。

自定义行为轨迹主要用于记录用户行为，例如购买了某件商品，可设置`title`参数为“购买xxx商品”，并在`description`参数中以`key-value`形式设置详细的商品信息，客服可查看此类信息，用于分析用户行为。行为轨迹接口定义在`QYSDK.h`中：

```objectivec
/**
 *  行为轨迹
 *  @param title 标题
 *  @param description 具体信息，以key-value表示信息对，例如key为“商品价格”，value为“999”
 */
- (void)trackHistory:(NSString *)title description:(NSDictionary *)description key:(NSString *)key;
```

## 高级功能

### 自定义消息

七鱼 iOS SDK 的 **自定义消息** 功能主要用于在聊天列表中任意**追加**、**插入**、**更新**、**删除**自定义消息，支持自定义消息数据存储及更新，支持注入自定义视图并修改布局配置，以 **Message — Model — View** 形式形成消息到视图的对应关系，开发原则为数据驱动视图，所有视图的更新都依赖于数据的更新。

功能对外接口位于 **QIYU_iOS_SDK/ExportHeaders/Custom** 中，相关类库说明请参考 **接入说明-类库说明** 章节，这里不再赘述。

#### 用法说明

自定义消息模块针对`QYSessionViewController`扩展了分类`QYCustomSessionViewController`，主要用于扩展自定义消息相关接口，避免放在原来的头文件中太过混乱。提供以下接口：

##### 注册映射关系（必须）

```objectivec
/**
 *  注册message-model-contentView的映射关系（必须）
 *  @discussion 若要使用自定义消息，必须调用此方法设置映射关系！
 *  @param messageClass     消息类
 *  @param modelClass       消息对应的数据模型类
 *  @param contentViewClass 消息对应的视图
 */
- (void)registerCustomMessageClass:(Class)messageClass
                        modelClass:(Class)modelClass
                  contentViewClass:(Class)contentViewClass;
```

需要在创建`QYSessionViewController`对象时调用该接口注册 **自定义消息 Message-自定义数据源 Model-自定义视图 ContentView** 的映射关系，这样 SDK 才能在遇到自定义 Message 时取出其对应的 Model 和 ContentView 类去创建相应的对象。

##### 设置/移除消息事件代理

```objectivec
/**
 *  设置消息事件委托对象
 *  @param delegate 被委托对象
 */
- (void)addCustomMessageDelegate:(id<QYCustomMessageDelegate>)delegate;

/**
 *  清除消息事件委托对象
 *  @param delegate 被清除的委托对象
 */
- (void)removeCustomMessageDelegate:(id<QYCustomMessageDelegate>)delegate;
```

可将任意对象设置为消息事件代理，用来接收消息在追加、插入、更新、删除等操作时抛出的某些事件，目前有如下几类时机抛出：

```objectivec
@protocol QYCustomMessageDelegate <NSObject>

@optional
/**
 *  追加消息的回调，此时消息已持久化（若需），还未刷新界面
 */
- (void)onAddMessageBeforeReload:(QYCustomMessage *)message;

/**
 *  插入消息的回调，此时消息已持久化（若需），还未刷新界面
 */
- (void)onInsertMessageBeforeReload:(QYCustomMessage *)message;

/**
 *  更新消息的回调，此时消息已持久化（若需），还未刷新界面
 */
- (void)onUpdateMessageBeforeReload:(QYCustomMessage *)message;

/**
 *  删除消息的回调，此时消息已持久化（若需），还未刷新界面
 */
- (void)onDeleteMessageBeforeReload:(QYCustomMessage *)message;

@end
```

##### 设置/移除视图事件代理

```objectivec
/**
 *  设置消息视图委托对象
 *  @param delegate 被委托对象
 */
- (void)addCustomContentViewDelegate:(id<QYCustomContentViewDelegate>)delegate;

/**
 *  清除消息视图委托对象
 *  @param delegate 被清除的委托对象
 */
- (void)removeCustomContentViewDelegate:(id<QYCustomContentViewDelegate>)delegate;
```

可将任意对象设置为消息视图事件代理，用来接收并处理点击头像事件、长按 cell 事件、contentView 上自定义控件抛出的各类事件：

```objectivec
@protocol QYCustomContentViewDelegate <NSObject>

@optional
/**
 *  自定义事件，通过QYCustomContentView的delegate去调用onCatchEvent:事件
 *  若事件涉及到更新消息及视图则尽量使用onCatchEvent:抛出，若未涉及消息及视图更新，可直接响应事件，无需使用该方法抛出
 */
- (void)onCatchEvent:(QYCustomEvent *)event;

/**
 *  头像点击事件
 */
- (void)onTapAvatar:(QYCustomEvent *)event;

/**
 *  消息体长按事件
 */
- (void)onLongPressCell:(QYCustomEvent *)event;

@end
```

##### 追加自定义消息

```objectivec
/**
 *  从尾部追加消息
 *  @param message    消息对象
 *  @param save       是否需要持久化消息数据
 *  @param reload     是否需要刷新界面
 *  @param completion 消息持久化结果回调
 */
- (void)addCustomMessage:(QYCustomMessage *)message
            needSaveData:(BOOL)save
          needReloadView:(BOOL)reload
              completion:(QYCustomMessageCompletion)completion;
```

通过此接口追加一条自定义消息，传入`QYCustomMessage`或其子类对象，并告知是否需要将数据持久化至数据库、是否需要立即刷新界面，该接口会给出结果回调，并抛出部分错误信息：

```objectivec
/**
 *  错误码
 */
typedef NS_ENUM(NSInteger, QYCustomMessageErrorCode) {
    QYCustomMessageErrorCodeUnknown         = 0,    //未知错误
    QYCustomMessageErrorCodeInvalidParam    = 1,    //错误参数
    QYCustomMessageErrorCodeInvalidMessage  = 2,    //无效消息体
    QYCustomMessageErrorCodeSQLFailed       = 3,    //SQL语句执行失败
};

/**
 *  消息持久化结果block
 *  @param error 错误信息
 */
typedef void(^QYCustomMessageCompletion)(NSError *error);
```

调用此接口时会自动调用`QYCustomMessageCoding`协议中的序列化/反序列化方法去 encode/decode 数据，自动调用`QYCustomModelLayoutDataSource`协议中的各个布局相关方法获得布局参数，最终自动调用`initCustomContentView`创建自定义视图，并通过`refreshData:`方法刷新视图。

##### 插入消息

```objectivec
/**
 *  从头部插入消息
 *  @discussion 插入消息不支持持久化数据
 *  @param message  消息对象
 */
- (void)insertCustomMessage:(QYCustomMessage *)message;

/**
 *  从中间插入消息
 *  @discussion 插入消息不支持持久化数据
 *  @param message  消息对象
 *  @param index    插入位置
 */
- (void)insertCustomMessage:(QYCustomMessage *)message index:(NSInteger)index;
```

在消息列表的某个位置插入一条消息，需注意，因底层设计原因，目前不支持插入消息的数据持久化，故插入消息接口只能实现在 table 的数据源 DataSource 中临时插入消息并刷新界面，退出聊天界面再次进入后消息消失。

##### 更新消息

```objectivec
/**
 *  刷新消息
 *  @param message  消息对象
 *  @param save     是否需要持久化消息数据
 *  @param reload   是否需要刷新界面
 *  @param completion 消息持久化结果回调
 */
- (void)updateCustomMessage:(QYCustomMessage *)message
               needSaveData:(BOOL)save
             needReloadView:(BOOL)reload
                 completion:(QYCustomMessageCompletion)completion;
```

更新数据库 Database 或是数据源 DataSource 中的某条消息，一般在调用该接口前，会先从数据库/数据源中取出该条消息（利用消息ID取出），更新部分消息属性，然后再调用接口更新，同样会自动触发 Model 和 ContentView 的部分方法，并给出回调结果。

##### 删除消息

```objectivec
/**
 *  删除消息
 *  @param message  消息对象
 *  @param save     删除记录是否同步至数据库
 *  @param reload   是否需要刷新界面
 */
- (void)deleteCustomMessage:(QYCustomMessage *)message
               needSaveData:(BOOL)save
             needReloadView:(BOOL)reload;
```

删除数据库 Database 或是数据源 DataSource 中的某条消息。

##### 获取消息

```objectivec
/**
 *  从数据库中取出消息
 *  @param messageId 消息的唯一ID
 *  @return 取出的消息体
 */
- (QYCustomMessage *)fetchCustomMessageFromDatabaseForMessageId:(NSString *)messageId;

/**
 *  从当前table的dataSource中取出消息
 *  @param messageId 消息的唯一ID
 *  @return 取出的消息体
 */
- (QYCustomMessage *)fetchCustomMessageFromDataSourceForMessageId:(NSString *)messageId;
```

从数据库 Database 或是数据源 DataSource 中获取某条消息，获取消息传入的唯一参数为消息ID，消息ID的生成必须是自定义消息创建后，通过调用 “ 追加add/插入insert ” 接口后才可同步获取。

#### 用法示例

使用自定义消息功能可在任意时刻向消息流中追加自定义的文本、图片、卡片等任意类型消息，可配合拦截请求客服事件实现定制欢迎消息功能，如开发者有需求，具体用法示例可咨询相关技术支持。

## 其他

### 读取日志

为方便追踪问题，七鱼 iOS SDK 会记录一些关键信息日志在本地文件，可通过调用`QYSDK.h`的如下接口获取日志文件路径：

```objectivec
/**
 *  获取七鱼日志文件路径
 *
 *  @return 日志文件路径
 */
- (NSString *)qiyuLogPath; 
```

### 清理文件缓存

七鱼 iOS SDK 提供资源文件清理功能，主要包括接收及发送的图片、视频、文件等大体积缓存，通过调用`QYSDK.h`如下接口清理：

```objectivec
/**
 *  清理缓存回调
 */
typedef void(^QYCleanCacheCompletion)(NSError *error);

/**
 *  清理接收文件缓存
 *  @param completion 清理缓存完成回调
 */
- (void)cleanResourceCacheWithBlock:(QYCleanCacheCompletion)completion;
```

### 清理账号信息

V5.1.0 版本后，提供清理账号信息功能，可清理全部或者除当前账号以外的冗余账号信息，通过调用`QYSDK.h`如下接口清理：

```objectivec
/**
 *  清理账号信息
 *  @discussion 清理全部账号信息会登出当前账号，并新建匿名账号，请在调用完成后使用setUserInfo:接口恢复为有名账号；请在合理时机调用本接口
 *  @param cleanAll 是否清理当前所有账号信息，NO表示清理历史无用账号，YES表示清理全部
 *  @param completion 清理缓存完成回调
 */
- (void)cleanAccountInfoForAll:(BOOL)cleanAll completion:(QYCleanCacheCompletion)completion;
```

## 平台电商

七鱼 iOS SDK 支持平台电商功能，即可实现同时与主商户/多个子商户对话。相关头文件定义在 **QIYU_iOS_SDK/ExportHeaders/POP** 目录中，在需要使用的地方`import "QYPOPSDK.h"`。

### 指定商家

平台电商版本针对`QYSessionViewController`扩展了分类`QYPOPSessionViewController`，增加了`shopId`配置项，可通过设置连接指定商家的客服：

```objectivec
sessionViewController.shopId = 123456;
```

### 会话列表

平台电商版本会话列表未读数/会话项获取、监听变化等功能与非平台版本相同，主要有以下区别：

#### 删除会话项

因平台电商可同时有多个会话项，故支持删除某一会话，使用`QYPOPConversationManager`中如下接口：

```objectivec
/**
 *  删除会话列表中的会话
 *
 *  @param shopId 商铺ID
 *  @param isDelete 是否删除消息记录，YES删除，NO不删除
 */
- (void)deleteRecentSessionByShopId:(NSString *)shopId deleteMessages:(BOOL)isDelete;
```

通过指定shopId删除对应商户会话项。

#### 会话信息扩展

平台电商版本针对`QYSessionInfo`扩展了分类`QYPOPSessionInfo`，增加了三个属性如下：

| 属性                 | 类型     | 说明     |
| -------------------- | -------- | -------- |
| shopId               | NSString | 商户ID   |
| avatarImageUrlString | NSString | 商户logo |
| sessionName          | NSString | 会话名称 |

#### 消息信息扩展

平台电商版本针对`QYMessageInfo`扩展了分类`QYPOPMessageInfo`，增加了三个属性如下：

| 属性                 | 类型     | 说明     |
| -------------------- | -------- | -------- |
| shopId               | NSString | 商户ID   |
| avatarImageUrlString | NSString | 商户logo |
| sender               | NSString | 发送者   |

## Demo源码

如果您看完此文档后，还有任何集成方面的疑问，可以参考 iOS SDK Demo 源码：[QIYU_iOS_SDK_Demo_Source](https://github.com/qiyukf/QIYU_iOS_SDK_Demo_Source.git)。源码充分展示了 iOS SDK 的能力，并且为集成 iOS SDK 提供了样例代码。

## 更新说明

#### V5.7.0（2020-01-16）

1. 人工模式支持访客自助提单
2. 机器人气泡节点列表消息底部按钮支持跳转链接
3. 机器人抽屉及气泡列表分组支持子标题展示
4. 机器人转人工类型统计方案优化
5. 修复部分已知bug

#### V5.6.0（2019-12-26）

1. 新增选择并发送系统文件功能
2. 机器人对话节点回复按钮样式优化
3. 机器人答案引导转人工支持设置分流组
4. 修复部分已知bug

#### V5.5.0（2019-12-12）

1. 商品卡片消息支持自定义
2. 留言模板按客服组展示
3. 机器人欢迎语支持模板配置
4. 新增商品卡片消息复制功能配置项
5. 客服界面部分加载优化
6. 修复部分已知bug

#### V5.4.0（2019-11-19）

1. 导航栏右侧按钮支持管理端配置
2. 会话/排队状态下入口参数变化增加弹窗提示
3. 富文本支持呼叫及复制电话号码功能
4. 跨会话禁用一触即达流程内按钮
5. 输入栏快捷入口增加点击频率限制
6. 优化部分警告信息
7. 修复部分已知bug

#### V5.3.1（2019-10-21）

1. 优化输入栏快捷入口样式
2. 修复已知bug

#### V5.3.0（2019-09-23）

1. 新增富文本视频功能
2. 结束会话接口逻辑变更并增加回调
3. 优化商品卡片发送逻辑
4. iOS13 适配：推送 DeviceToken 解析方法变更
5. iOS13 适配：页面 modalPresentationStyle 适配

#### V5.2.0（2019-08-22）

1. 新增对外能力：结束会话/发送视频/拍摄视频
2. 新增UI设置：主题色
3. 支持管理端设置：部分样式/快捷入口/+扩展按钮
4. 机器人模式支持访客自助提单
5. 优化满意度评价功能体验
6. 修复部分已知问题

#### V5.1.0（2019-07-25）

1. 聊天页面样式全面升级
2. 满意度功能升级：新增气泡样式/四级满意度/问题解决选择
3. 新增清理账号信息接口
4. 修复部分已知问题

#### V5.0.0（2019-07-04）

1. 机器人新增抽屉列表/气泡列表/横滑卡片/气泡节点模板消息
2. 机器人一触即达对话节点支持按钮交互
3. 引导语自定义及样式调整
4. 支持自定义评价界面
5. 支持自定义下拉加载loading动效
6. 客服头像支持导航栏显示
7. 消息气泡样式优化
8. 修复部分已知问题

#### V4.12.0（2019-05-16）

1. 新增相册视频发送功能
2. 留言表单新增附件上传功能
3. 优化图片选择器，支持预览及原图等功能
4. 新增客服超时未回复安抚语功能
5. 优化部分接口请求量
6. 优化部分接口编码，增加兼容性
7. 修复部分线上问题

#### V4.11.0（2019-04-16）

1. 留言功能新增表单样式
2. 新增客服正在输入提示功能
3. 优化图片浏览体验
4. 统一消息字体，优化UI相关配置
5. 增加客服手动结束会话提示语
6. 修复部分已知问题

#### V4.10.0（2019-03-19）

1. 优化访客分流逻辑
2. 优化输入栏+按钮功能，提供发送文本消息接口
3. 支持切换账户后拉取未读历史消息
4. 修复部分已知问题

#### V4.9.0（2019-02-14）

1. 新增消息阅读状态显示功能
2. 新增自定义表情功能
3. 满意度评价入口支持隐藏及回合数设置
4. 优化账号登录及登出逻辑
5. 修复部分已知问题

#### V4.8.0（2019-01-03）

1. 新增机器人答案差评转人工功能
2. 部分bot卡片支持链接跳转
3. 修复部分已知问题

#### V4.7.1（2018-12-18）

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

