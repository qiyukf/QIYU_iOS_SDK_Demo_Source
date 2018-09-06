# 网易七鱼 iOS SDK 开发指南

## 简介

网易七鱼 iOS SDK 是客服系统访客端的解决方案，既包含了客服聊天逻辑管理，也提供了聊天界面，开发者可方便的将客服功能集成到自己的 APP 中。iOS SDK 支持 iOS 7 以上版本，同时支持 iPhone、iPad，同时支持竖屏和横屏。

## 将SDK导入工程（必须）

### 手动集成

* 下载 QY SDK，得到3个 .a 文件、 QYResouce 文件夹和 ExportHeaders 文件夹，将他们导入工程
* 添加 QY SDK 依赖库

	* UIKit.framework
	* CoreText.framework
	* MobileCoreService.framework
	* SystemConfiguration.framework
	* AVFoundation.framwork
	* CoreTelephony.framework
	* CoreMedia.framework
	* AudioToolbox.framework
	* libz.tbd
	* libstdc++.6.0.9.tbd
	* libsqlite3.0.tbd
	* libxml2.tbd
	* AssetsLibrary.framework

* 在 Build Settings -> Other Linker Flags 中添加 -ObjC 

### CocoaPods集成

在 Podfile 文件中加入 

```objc
	pod    'QIYU_iOS_SDK',    '~> x.x.x'
```
"x.x.x" 代表版本号，比如想要使用 3.0.0 版本，就写

```objc
	pod    'QIYU_iOS_SDK',    '~> 3.0.0'
```

如果无法安装 SDK 最新版本，运行以下命令更新本地的 CocoaPods 仓库列表

```objc
	pod repo update
```

### 解决符号重复的冲突

从 v3.1.0 开始，没有 QIYU_iOS_SDK_Exclude_Libcrypto、QIYU_iOS_SDK_Exclude_NIM 版本了，统一使用 QIYU_iOS_SDK，此SDK中将各个第三方库独立出来了，总共3个.a：libQYSDK.a、libcrypto.a、libevent.a。

1. 如果您同时使用了网易云信 iOS SDK，请只导入 libQYSDK.a，不要导入其他2个 .a 文件。
2. 如果您同时使用了 OpenSSL 库，或者您集成的其它静态库使用了 OpenSSL 库（比如支付宝 SDK），请只导入 libQYSDK.a、libevent.a，不要导入 libcrypto.a。
3. 如果是其他情况的冲突，请根据实际情况有选择的导入 libevent.a、libcrypto.a

### https相关

* v3.1.3 版本开始，SDK已经全面支持https，但是聊天消息中可能存在链接，点击链接会用UIWebView打开，链接地址有可能是http的，为了能够正常打开，需要增加配置项。在Info.plist中加入以下内容：

```objc
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        <key>NSAllowsArbitraryLoadsInWebContent</key>
        <true/>
    </dict>
```

加了这些配置项，在 iOS9 下，会放开所有 http 请求，在 iOS10 下，因为 iOS10 规定，如果有 NSAllowsArbitraryLoadsInWebContent，就会忽略 NSAllowsArbitraryLoads，所以效果是只允许 UIWebView 中使用 http。

### iOS10权限设置

在Info.plist中加入以下内容：

```objc
    <key>NSPhotoLibraryUsageDescription</key>
    <string>需要照片权限</string>
    <key>NSCameraUsageDescription</key>
    <string>需要相机权限</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>需要麦克风权限</string>
```

如果不加，会crash。

### iOS11权限设置

在Info.plist中加入以下内容：

```objc
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>App需要您的同意,才能添加照片到相册</string>
```

如果不加，会crash。请注意，iOS11需要的是 NSPhotoLibraryAddUsageDescription，跟iOS10需要的 NSPhotoLibraryUsageDescription 不一样的。

### iOS11兼容性

请使用 3.11.0 以上的版本。

### 其它说明

* 在需要使用 SDK 的地方 import "QYSDK.h"。
* 由于 SDK 是静态库，且为了方便开发者使用，我们将 armv7 arm64 i386 x86_64 平台的静态库合并成一个 Fat Library ，导致整个 SDK 比较大。但实际编译后大约只会增加 app 4-5M 大小。

### 可能遇到的问题1
1. 无法用 CocoaPods 下载到最新的 SDK。有可能是使用了淘宝源，尝试使用默认源。

## 初始化SDK（必须）

```objc
	- (BOOL)application:(UIApplication *)application
							didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		......

	    [[QYSDK sharedSDK] registerAppId:AppKey appName:App名称];

	    ......

	    return YES;
	}
```
1. AppKey可以在“管理后台” -> “设置” -> “App接入” -> “2. App Key” 找到。
appName 对应管理后台添加一个 app 时填写的 “App 名称”。如果管理后台还没有添加一个 app，请及时添加。如果 appName 跟管理后台 app 的 “App 名称” 不一致，会导致无法正常收到苹果的消息推送。
2. 一般在“application: didFinishLaunchingWithOptions:”这个方法里面调用“registerAppId: appName:”方法，如果在其他时刻调用，在调用之前，就等于没有在使用七鱼的服务。在整个软件运行期间必须只调用一次，如果调用多次，将会有严重的不可预测的问题。

## 集成聊天组件（必须）

```objc
	[[QYSDK sharedSDK] sessionViewController];
```

应用层获取此 sessionViewController 之后，必须嵌入到 UINavigationcontroller 中，就可以获得聊天窗口的UI以及所有功能。 sessionViewController 只会使用到导航栏的 self.navigationItem.title 和 self.navigationItem.rightBarButtonItem 。 self.navigationItem.title 放置标题栏； self.navigationItem.rightBarButtonItem 放置"人工客服"、“评价”入口。必须注意， 不能在 sessionViewController 外层套其他 viewController 之后再嵌入到 UINavigationcontroller。

如果调用代码所在的viewController在UINavigationcontroller中，可以如下方式集成（第一种集成方式）：

```objc
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"七鱼金融";
    source.urlString = @"https://8.163.com/";
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"七鱼金融";
    sessionViewController.source = source;
    sessionViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sessionViewController animated:YES];
```

如果调用代码所在的viewController不在UINavigationcontroller中，可如下方式集成（第二种集成方式）：

```objc
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"七鱼金融";
    source.urlString = @"https://8.163.com/";
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"七鱼金融";
    sessionViewController.source = source;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sessionViewController];
    [self presentViewController:nav animated:YES completion:nil];
```
一般来说，第二种方式会需要在左上角加一个返回按钮，在 “initWithRootViewController:sessionViewController” 之前加上：

```objc
    sessionViewController.navigationItem.leftBarButtonItem =
    			[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
```

“onBack” 的样例：

```objc
- (void)onBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
```

如果您的代码要求所有viewController继承某个公共基类，并且公共基类对UINavigationController统一做了某些处理；或者对UINavigationController做了自己的扩展，并且这会导致集成之后有某些问题；或者其他原因导致使用第一种方式集成会有问题；这些情况下，建议您使用第二种方式集成。

### 可能遇到的问题2
1. 进入访客聊天界面马上crash。
	* 检查app工程配置－> Build Phases -> copy Bundle Resources 里面有没有QYResource.bundle；如果没有，必须加上。

2. 一直显示正在连接客服
	* 可能是AppKey填写错误
	
3. 能否同时创建多个sessionViewController
	* 不能，需要保持全局唯一。每次调用 [[QYSDK sharedSDK] sessionViewController]; 会得到一个全新的 QYSessionViewController 对象，开发者需要保证此对象全局唯一。

4. 怎么知道sessionViewController被pop了
	* 请参考 UINavigationControllerDelegate 中这个函数：

 ```objc
 -(nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;
 ```

5. sessionViewController的导航栏可以自定义吗
	* 部分自定义。 sessionViewController 会占用 self.navigationItem.title 和 self.navigationItem.rightBarButtonItem；navigationItem的其它部分，比如leftBarButtonItem等，您可以根据需要做任何自定义。

6. 聊天界面可以自定义吗
	* 部分自定义。 具体可参考 QYCustomUIConfig 类，Demo源码中也有相关样例代码。

7. 评价按钮为什么不能点
	* 请求到客服之后，评价按钮才能点。如果客服不在线或者排队中，是不能点的。
	
8. 键盘有异常
	* 检查下app中是否用到了会影响全局的键盘处理，如果是这种情况，需要对 QYSessionViewController 做屏蔽处理。典型的比如第三方键盘库IQKeyboardManager,如果用的是 IQKeyboardManager v4.0.4 以前的版本（不包括 v4.0.4），加入以下屏蔽代码：

```objc
	[[IQKeyboardManager sharedManager] disableDistanceHandlingInViewControllerClass:[QYSessionViewController class]];
```
如果用的是 IQKeyboardManager v4.0.4 或以后的版本，加入以下屏蔽代码：

```objc
[[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[KFSessionViewController class]];
```

9. 如何强制竖屏
	* 如果您的app是横屏的，但是希望聊天界面是竖屏的，可以使用以下代码实现
	* 用的是第二种集成方式。一般来说，第二种方式会需要在左上角加一个返回按钮，这方面内容请看第二种集成方式的介绍
	
```objc
	@interface PortraitNavigationController : UINavigationController
	@end
	
	@implementation PortraitNavigationController
	
	- (UIInterfaceOrientationMask)supportedInterfaceOrientations
	{
	    return UIInterfaceOrientationMaskPortrait;
	}
	
	@end

    QYSource *source = [[QYSource alloc] init];
    source.title =  @"七鱼金融";
    source.urlString = @"https://8.163.com/";
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"七鱼金融";
    sessionViewController.source = source;
    PortraitNavigationController *nav = [[PortraitNavigationController alloc] initWithRootViewController:sessionViewController];
    [self presentViewController:nav animated:YES completion:nil];
```

## 注销（必须）

```objc
	[[QYSDK sharedSDK] logout:^(){}];
```

应用层退出自己的账号时需要调用 SDK 的注销操作。

## 完成各种设置（可选）

### 消息未读数处理

```objc
	[[QYSDK sharedSDK] conversationManager];
```

返回的是一个QYConversationManager；可通过这个类获得消息未读数以及设置Delegate,通过此Delegate可以监听未读数变化。

### 获取会话列表

```objc
	[[QYSDK sharedSDK] conversationManager] getSessionList];
```
返回结果是 QYSessionInfo 数组，QYSessionInfo 内容如下：

```objc
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
	
	@end
```

### 监听列表项变化

```objc
	[[QYSDK sharedSDK] conversationManager setDelegate: ];
```

通过 “setDelegate” 接口设置 delegate，delegate中有一个 “onSessionListChanged” 方法，可以监听列表项变化。

### 接收消息

```objc
	[[QYSDK sharedSDK] conversationManager setDelegate: ];
```

通过 “setDelegate” 接口设置 delegate，delegate中有一个 “onReceiveMessage” 方法，可以接收消息。

### APNS推送
* [制作推送证书并在管理后台配置](./iOS_apns.html "target=_blank")
* 初始化

```objc
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		......

		//传入正确的App名称
	   [[QYSDK sharedSDK] registerAppId:AppKey appName:App名称];

		//注册 APNS
		if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
			UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
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

* 把 APNS Token 传给 SDK

```objc
	- (void)application:(UIApplication *)app
					didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
	{
		......

	    [[QYSDK sharedSDK] updateApnsToken:deviceToken];

	    ......
	}
```
#### 可能遇到的问题3
1. 无法正常推送
 * 检查管理后台应用中是否配置过推送证书 p12 文件，此证书是否就是此 app bundle ID 关联的推送证书
 * 检查证书的线上、测试环境是否跟管理后台配置的相同
 * 检查初始化时填的 appName 是否和管理后台“添加一个App”时填写的“App名称”一致
 * 检查 provision profile 是否包含了推送证书
 * 检查推送证书中是否有 p12 文件
 * 检查代码调试是否可以获取到 devicetoken
 * 检查第三方推送工具是否可以正常推送，如果不能，说明是证书本身的问题

2. 可以同时使用第三方推送工具吗
 * 可以同时使用第三方推送工具和 SDK 的消息推送，两者可以共存，不会有任何冲突。

3. 能否区分出哪些推送消息是来自七鱼的
 * 所有来自七鱼的推送消息的payload中都带有"nim:1"，通过这个可以判断出是七鱼的推送消息。

### 自定义商品信息
获取到 sessionViewController 之后，可以指定自定义商品信息。带着商品信息进入聊天界面，分为两种情况：如果当前还没请求到客服， 是不会发送商品信息的，等请求到客服之后会自动发；如果当前已经请求到客服了，会立刻发送商品信息。示例如下：

```objc
	QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
    commodityInfo.title = @"网易七鱼";
    commodityInfo.desc = @"网易七鱼是网易旗下一款专注于解决企业与客户沟通的客服系统产品。";
    commodityInfo.pictureUrlString = @"http://qiyukf.com/main/res/img/index/barcode.png";
    commodityInfo.urlString = @"http://qiyukf.com/";
    commodityInfo.note = @"￥10000";
    commodityInfo.show = YES; //访客端是否要在消息中显示商品信息，YES代表显示,NO代表不显示

	sessionViewController.commodityInfo = commodityInfo;
```

QYCommodityInfo 相关内容如下：

```objc
    /**
     *  自定义商品信息按钮信息
     */
    @interface QYCommodityTag : NSObject

    @property (nonatomic, copy) NSString *label;
    @property (nonatomic, copy) NSString *url;
    @property (nonatomic, copy) NSString *focusIframe;
    @property (nonatomic, copy) NSString *data;

    @end


    /**
     *  商品详情信息展示
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
     *  发送时是否要在用户端隐藏，YES为显示，NO为隐藏，默认为不显示
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
     *  是否自定义，YES代表是，NO代表否，默认NO。自定义的话，只有pictureUrlString、urlString有效，只显示一张图片 (v4.4.0)
     */
    @property (nonatomic, assign) BOOL isCustom;

    /**
     *  是否由访客手动发送，YES代表是，NO代表否 (v4.4.0)
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

#### 主动发送商品信息

```objc
    [sessionViewController sendCommodityInfo:commodityInfo];
```

#### 可能遇到的问题4
1. 商品链接的点击处理可自定义，请参看此文档关于 QYCustomActionConfig 的相关说明。

### 自定义聊天组件UI效果

获取自定义UI类对象

```objc
	[[QYSDK sharedSDK] customUIConfig];
```
QYCustomUIConfig是负责自定义UI的类，必须在集成聊天组件之前完成配置项设置。相关内容如下：

```objc
    /**
     *  访客分流展示模式
     */
    typedef NS_ENUM(NSInteger, QYBypassDisplayMode) {
        QYBypassDisplayModeNone,
        QYBypassDisplayModeCenter,
        QYBypassDisplayModeBottom
    };

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

    /**
     *  自定义UI配置类；如果想要替换图片素材，可以自己创建一个QYCustomResource.bundle，在其中放置跟QYResource.bundle中同名的图片素材，即可实现替换。
     *  SDK会优先使用QYCustomResource.bundle中的图片素材，当QYCustomResource.bundle中没有的时候，才会使用QYResource.bundle中的图片素材
     */
    @interface QYCustomUIConfig : NSObject

    + (instancetype)sharedInstance;

    /**
     *  恢复成默认设置
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
     *  以下配置项在V4.4.0版本前，只有平台电商版本有；V4.4.0以后，平台电商/非平台电商均有这些配置项
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

#### “照相机”替换为“更多”按钮

在V4.4.0版本中，聊天界面输入区域“照相机”按钮可配置成“更多”按钮，点击“更多”按钮可展开显示用户配置的选项。示例如下：

```objc
	QYCustomInputItem *photoItem = [[QYCustomInputItem alloc] init];
    photoItem.normalImage = [UIImage imageNamed:@"icon_media_photo_normal"];
    photoItem.selectedImage = [UIImage imageNamed:@"icon_media_photo_nomal_pressed"];
    photoItem.text = @"相册";
	photoItem.block = ^{ };
	
	QYCustomInputItem *cameraItem = [[QYCustomInputItem alloc] init];
    cameraItem.normalImage = [UIImage imageNamed:@"icon_media_camera_normal"];
    cameraItem.selectedImage = [UIImage imageNamed:@"icon_media_camera_pressed"];
    cameraItem.text = @"拍摄";
    cameraItem.block = ^{ };
	    
	QYCustomInputItem *janKenItem = [[QYCustomInputItem alloc] init];
    janKenItem.normalImage = [UIImage imageNamed:@"icon_media_jankenpon_normal"];
    janKenItem.selectedImage = [UIImage imageNamed:@"icon_media_jankenpon_pressed"];
    janKenItem.text = @"石头剪刀布";
	janKenItem.block = ^{ };

	QYCustomInputItem *fileTransItem = [[QYCustomInputItem alloc] init];
    fileTransItem.normalImage = [UIImage imageNamed:@"icon_media_file_trans_normal"];
    fileTransItem.selectedImage = [UIImage imageNamed:@"icon_media_file_trans_pressed"];
    fileTransItem.text = @"文件传输";
	fileTransItem.block = ^{ };

	QYCustomInputItem *tipItem = [[QYCustomInputItem alloc] init];
    tipItem.normalImage = [UIImage imageNamed:@"icon_media_tip_normal"];
    tipItem.selectedImage = [UIImage imageNamed:@"icon_media_tip_pressed"];
    tipItem.text = @"提示消息";
	tipItem.block = ^{ };
	    
	NSArray *items = @[photoItem, cameraItem, janKenItem, fileTransItem, tipItem];
	[[QYSDK sharedSDK] customUIConfig].customInputItems = items;
```

#### 更换图片素材

QYCustomUIConfig只是负责替换部分皮肤相关内容，不包含所有的图片素材的替换。iOS SDK支持所有图片素材替换，只需要新建QYCustomResource.bundle，在其中放置跟QYResource.bundle中同名的图片素材，即可替换QYResource.bundle中的对应素材。为了效果好，应该放置同等尺寸的图片。

### 自定义聊天组件事件处理

获取自定义事件处理类对象

```objc
	[[QYSDK sharedSDK] customActionConfig];
```
QYCustomActionConfig是负责自定义事件处理的类。相关内容如下：

```objc
    /**
     *  退出排队结果类型
     */
    typedef NS_ENUM(NSInteger, QuitWaitingType) {
        QuitWaitingTypeNone,     //当前不是在排队状态
        QuitWaitingTypeContinue, //继续排队
        QuitWaitingTypeQuit,     //退出排队
        QuitWaitingTypeCancel,   //取消操作
    };

    /**
     *  请求客服场景
     */
    typedef NS_ENUM(NSInteger, QYRequestStaffScene) {
        QYRequestStaffSceneNone,               //无需关心的请求客服场景
        QYRequestStaffSceneInit,               //进入会话页面，初次请求客服
        QYRequestStaffSceneRobotUnable,        //机器人模式下告知无法解答，点击按钮请求人工客服
        QYRequestStaffSceneNavHumanButton,     //机器人模式下，点击右上角人工按钮
        QYRequestStaffSceneActiveRequest,      //主动请求人工客服
    };

    /**
     *  提供了所有自定义行为的接口;每个接口对应一个自定义行为的处理，如果设置了，则使用设置的处理，如果不设置，则采用默认处理
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
     *  请求客服-回传结果
     */
    typedef void (^QYRequestStaffCompletion)(BOOL needed);

    /**
     *  请求客服前回调
     *
     *  @param scene 请求客服场景
     *  @param completion 处理完成后的回调，若需继续请求客服，则调用completion(YES)；若需停止请求，调用completion(NO)
     */
    typedef void (^QYRequestStaffBlock)(QYRequestStaffScene scene, QYRequestStaffCompletion completion);

    /**
     *  自定义行为配置类
     */
    @interface QYCustomActionConfig : NSObject

    + (instancetype)sharedInstance;

    /**
     *  所有消息中的链接（自定义商品消息、文本消息、机器人答案消息）的回调处理
     */
    @property (nonatomic, copy) QYLinkClickBlock linkClickBlock;

    /**
     *  bot相关点击
     */
    @property (nonatomic, copy) QYBotClickBlock botClick;

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
     *  请求客服前调用
     */
    @property (nonatomic, copy) QYRequestStaffBlock requestStaffBlock;

    @end
```

#### 请求客服事件拦截

在V4.4.0版本中，可以拦截所有请求客服事件，并给出当前请求客服是何种场景，开发者可针对不同场景做定制化处理。若要拦截，请设置QYCustomActionConfig中的requestStaffBlock，处理完成后，请主动调用该block中的completion回调，并设置needed参数，YES表示继续请求客服，NO表示中止请求客服。

### 指定客服ID或客服组ID

在获取 sessionViewController 之后，可以指定客服 ID 或客服组 ID

```objc
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.groupId = groupId;
    sessionViewController.staffId = staffId;
```

指定之后，进入聊天界面时，会直接以此 ID 去请求到对应的客服或者客服组。在 管理后台 -> 设置 -> 高级设置 -> 访客分配 -> ID 查询 中可查询到客服 ID 或客服组 ID 。

### 多机器人接入

在获取 sessionViewController 之后，可以指定机器人 ID

```objc
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.robotId = robotId;
```

指定之后，进入聊天界面时，会直接以此 ID 去请求到对应的机器人。在 管理后台 -> 设置 -> 机器人 -> 机器人列表 -> 机器人ID 中可查询到机器人 ID。

### 指定常见问题模版ID

在获取 sessionViewController 之后，可以指定常见问题模版ID

```objc
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.commonQuestionTemplateId = commonQuestionTemplateId;
```

指定之后，进入聊天界面时，会直接以此 ID 去请求到对应的常见问题模版。在 管理后台 -> 设置 -> 机器人 -> 常见问题设置 中可查询到常见问题模版ID。

### 访客分流是否开启机器人 

在获取 sessionViewController 之后，可以指定访客分流是否开启机器人，默认不开启。如果开启机器人，则选择客服或者客服分组之后，先进入机器人模式。

```objc
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.openRobotInShuntMode = openRobotInShuntMode;
```

### 机器人自动发送商品卡片

在V4.4.0版本中，获取到sessionViewController后，可设置机器人模式下是否开启自动发送商品卡片功能，默认不开启。若开启，则设置商品信息后，机器人模式下也可直接发送商品卡片。

```objc
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.autoSendInRobot = autoSendInRobot;
```

### 请求人工客服

在V4.4.0版本中，获取到sessionViewController后，提供直接请求人工客服功能：

```objc
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    [sessionViewController requestHumanStaff];
```

### 设置vip等级 

在获取 sessionViewController 之后，可以设置访客的vip等级，默认是非vip。vip等级分两种，一种是从非vip和vip1~vip10，vip对应的数值是1～10；另一种是非vip和vip，vip对应的数值是11。

```objc
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.vipLevel = 1;
```

### CRM上报

```objc
    QYUserInfo *userInfo = [[QYUserInfo alloc] init];
    userInfo.userId = @"userId";
	NSMutableArray *array = [NSMutableArray new];
    NSMutableDictionary *dictRealName = [NSMutableDictionary new];
    [dictRealName setObject:@"real_name" forKey:@"key"];
    [dictRealName setObject:@"边晨" forKey:@"value"];
    [array addObject:dictRealName];
    NSMutableDictionary *dictMobilePhone = [NSMutableDictionary new];
    [dictMobilePhone setObject:@"mobile_phone" forKey:@"key"];
    [dictMobilePhone setObject:@"13805713536" forKey:@"value"];
    [dictMobilePhone setObject:@(NO) forKey:@"hidden"];
    [array addObject:dictMobilePhone];
    NSMutableDictionary *dictEmail = [NSMutableDictionary new];
    [dictEmail setObject:@"email" forKey:@"key"];
    [dictEmail setObject:@"bianchen@163.com" forKey:@"value"];
    [array addObject:dictEmail];
    NSMutableDictionary *dictAuthentication = [NSMutableDictionary new];
    [dictAuthentication setObject:@"0" forKey:@"index"];
    [dictAuthentication setObject:@"authentication" forKey:@"key"];
    [dictAuthentication setObject:@"实名认证" forKey:@"label"];
    [dictAuthentication setObject:@"已认证" forKey:@"value"];
    [array addObject:dictAuthentication];
    NSMutableDictionary *dictBankcard = [NSMutableDictionary new];
    [dictBankcard setObject:@"1" forKey:@"index"];
    [dictBankcard setObject:@"bankcard" forKey:@"key"];
    [dictBankcard setObject:@"绑定银行卡" forKey:@"label"];
    [dictBankcard setObject:@"622202******01116068" forKey:@"value"];
    [array addObject:dictBankcard];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                   options:0
                                                     error:nil];
    if (data) {
        userInfo.data = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    }

	[[QYSDK sharedSDK] setUserInfo:userInfo];
```
userInfo: 字段“id”表示用户id，字段“data”表示用户信息，具体请看官网CRM相关文档:
<a>http://qiyukf.com/newdoc/html/qiyu_crm_interface.html</a>

### 七鱼系统推送消息

七鱼系统推送消息（与苹果的APNS推送无关）

可以主动要求服务器返回指定的消息

```objc

/**
 *  获取推送消息
 *
 *  @param messageId 消息id
 */
- (void)getPushMessage:(NSString *)messageId;

```

可以接收服务器返回的消息，以进行界面展示；不管是主动获取的消息还是管理后台主动推送的消息，都通过此接口获取。

```objc

/**
 *  注册推送消息通知回调
 *
 *  @param messageId 消息id
 */
- (void)RegisterPushMessageNotification:(QYPushMessageBlock)block;

```

### 清理文件缓存

文件消息接收并下载后可以通过此接口清理已下载到本地的文件。

```objc
/**
 清理接收文件缓存
 @param completeBlock 清理缓存完成block
 */
- (void)cleanResourceCacheWithBlock:(QYCleanResourceCacheCompleteBlock)completeBlock;
```

### 监听聊天窗口事件

设置 QYSessionViewDelegate：

```objc
	[[QYSDK sharedSDK] sessionViewController].delegate = ;
```
QYSessionViewDelegate 中可以获取“点击商铺入口按钮回调” 和 “点击聊天窗口右边或左边会话列表按钮回调”

### 设置输入区域上方工具栏

在V3.13.0版本中，支持设置输入区域上方工具栏：

#### 添加按钮

```objc
	NSMutableArray *buttonInfoArray = [NSMutableArray new];
    QYButtonInfo *buttonInfo = [QYButtonInfo new];
    buttonInfo.title = buttonText;
    [buttonInfoArray addObject:buttonInfo];

    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
	sessionViewController.buttonInfoArray = buttonInfoArray;
```

#### 设置按钮点击事件的处理

```objc
    sessionViewController.buttonClickBlock = ^(QYButtonInfo *action) {};
```

### APP访问轨迹与行为轨迹

#### 访问轨迹

在V4.0.0版本中，SDK支持记录用户在APP内的访问轨迹并上报。使用该功能，需要企业开通“访问轨迹”功能。访问轨迹接口定义在QYSDK.h中：

```objc
	/**
	 *  访问轨迹
	 *  @param title 标题
	 *  @param enterOrOut 进入还是退出
	 */
	- (void)trackHistory:(NSString *)title enterOrOut:(BOOL)enterOrOut key:(NSString *)key; 
```

接口调用示例：

```objc
	@interface QYMainViewController ()
	
	@property (nonatomic, copy) NSString *key;
	
	@end


	@implementation QYMainViewController
	
	- (void)viewDidAppear:(BOOL)animated
	{
	    [super viewDidAppear:animated];
	    if (_key == nil) {
    	    self.key = [[NSUUID UUID] UUIDString];
		    [[QYSDK sharedSDK] trackHistory:@"七鱼金融" enterOrOut:YES key:self.key];
	    }
	}
	
	- (void)viewDidDisappear:(BOOL)animated
	{
	    [super viewDidDisappear:animated];
	    if (_key != nil)  {
		    [[QYSDK sharedSDK] trackHistory:@"七鱼金融" enterOrOut:NO key:self.key];
    	    self.key = nil;
	    }
	}
	
	@end
```

#### 行为轨迹

在V4.4.0版本中，SDK支持记录用户在APP内的行为轨迹并上报。使用该功能，需要企业开通“行为轨迹”功能。行为轨迹是建立在访问轨迹之上的，如果需要使用行为轨迹，请先开启访问轨迹。

行为轨迹主要用于记录用户行为，例如购买了某件商品，可设置title参数为“购买xxx商品”，并在description参数中以key-value形式设置详细的商品信息，客服可查看此类信息，用于分析用户行为。行为轨迹接口定义在QYSDK.h中：

```objc
/**
 *  行为轨迹
 *  @param title 标题
 *  @param description 具体信息，以key-value表示信息对，例如key为“商品价格”，value为“999”
 */
- (void)trackHistory:(NSString *)title description:(NSDictionary *)description key:(NSString *)key;
```

## 平台电商版本

平台电商版本相关头文件全部在 "QIYU_iOS_SDK/POP" 目录下。在需要使用 SDK 的地方 import "QYPOPSDK.h"。

### 删除会话项

```objc
	[[QYSDK sharedSDK] conversationManager] deleteRecent****SessionByShopId:@"shopId" deleteMessages:YES];
```

### 进入聊天窗口，请求特定商家

```objc
	[[QYSDK sharedSDK] sessionViewController];
```

应用层获取此 sessionViewController 之后，可以设置 "shopId":

```objc
    sessionViewController.shopId = @"shopId";
```

## 参考DEMO源码

如果您看完此文档后，还有任何集成方面的疑问，可以参考下 iOS SDK Demo 源码: https://github.com/qiyukf/QIYU_iOS_SDK_Demo_Source.git 。源码充分的展示了 iOS SDK 的能力，并且为集成 iOS SDK 提供了样例代码。

## 更新说明

#### V4.4.0（2018-09-06）

1. 自定义商品信息新增“自定义图片”、“手动发送”功能
2. “聊天界面右上角按钮自定义功能”之前仅平台电商版本支持，现修改为平台电商、非平台电商版本均支持
3. 聊天界面输入区域“照相机”按钮可配置为“更多”按钮，点击“更多”按钮可展开显示用户配置的选项
4. 根据用户输入的消息与企业知识库进行匹配，匹配到的结果显示在输入框上方工具栏
5. bot支持自定义商品消息，可实现定制化
6. 新增拦截请求客服事件的功能
7. 新增机器人自动发送商品卡片的功能
8. bot商品卡片底部新增自定义按钮
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
3. 新增APP访问轨迹
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

   注意事项：增加了对 libxml2.tbd 的依赖