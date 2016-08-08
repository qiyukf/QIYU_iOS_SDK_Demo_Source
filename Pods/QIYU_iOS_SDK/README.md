# 网易七鱼 iOS SDK 开发指南

## 简介

网易七鱼 iOS SDK 是客服系统访客端的解决方案，既包含了客服聊天逻辑管理，也提供了聊天界面，开发者可方便的将客服功能集成到自己的 APP 中。iOS SDK 支持 iOS 7 以上版本，同时支持iPhone、iPad。在iOS 9.2 以上版本中支持 IPv6，能正常通过苹果审核。

## 前期准备

### 手动集成

* 下载 QY SDK，得到一个 .a 文件、 QYResouce 文件夹和 ExportHeaders 文件夹，将他们导入工程
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

* 在 Build Settings -> Other Linker Flags 中添加 -ObjC 

### CocoaPods集成

在 Podfile 文件中加入 

```
	pod    'QIYU_iOS_SDK',    '~> 2.6.0' 
```

### 解决符号重复的冲突

如果您集成之后，遇到了符号重复的冲突，您可能同时使用了网易云信 iOS SDK，如果是这种情况，请通过 CocoaPods 集成，在 Podfile 文件中加入

```
	pod    'QIYU_iOS_SDK_Exclude_NIM',    '~> 2.6.0' 
```

或者，您可能同时使用了 OpenSSL 库，如果是这种情况，请通过 CocoaPods 集成，在 Podfile 文件中加入

```
	pod    'QIYU_iOS_SDK_Exclude_Libcrypto',    '~> 2.6.0' 
```

### 其他

* 在Info.plist中加入以下内容：

```
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
	</dict>
```

由于SDK与服务器之间有部分请求使用的是http，如果不加此代码，将无法进行http请求。

* 在需要使用 SDK 的地方 import "QYSDK.h"。QYSDK 类是整个SDK的唯一主入口，是一个单例。各个函数简介：
 
```
	初始化：
		- (void)registerAppId:(NSString *)appKey appName:(NSString *)appName;
		
	集成访客端聊天组件：
		- (QYSessionViewController *)sessionViewController;
		
	自定义访客端聊天组件UI效果：
		- (QYCustomUIConfig *)customUIConfig;
		
	消息未读数处理：
		- (id<YSFConversationManager>)conversationManager;
		
	APNS推送：
		- (void)updateApnsToken:(NSData *)token;
		
	注销：
		- (void)logout:(QYCompletionBlock)completion;
			 	
	CRM：
		- (void)setUserInfo:(QYUserInfo *)userInfo;
```
 
**由于 SDK 是静态库，且为了方便开发者使用，我们将 armv7 i386 x86_64 arm64 平台的静态库合并成一个 Fat Library ，导致整个 SDK 比较大。但实际编译后大约只会增加 app 4-5M 大小**

## 使用详解

### 初始化

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
AppKey可以在“管理后台” -> “设置” -> “App接入” -> “2. App Key” 找到。
appName(就是SDK 1.0.0版本的cerName,参数名变了) 对应管理后台添加一个 app 时填写的 App 名称。

### 集成访客端聊天组件

```objc
	[[QYSDK sharedSDK] sessionViewController];
```

应用层获取此 sessionViewController 之后，必须嵌入到 UINavigationcontroller 中，就可以获得聊天窗口的UI以及所有功能。 sessionViewController 只会使用到导航栏的 self.navigationItem.title 和 self.navigationItem.rightBarButtonItem 。 self.navigationItem.title 放置标题栏； self.navigationItem.rightBarButtonItem 放置"人工客服"、“评价”入口。必须注意， 不能在 sessionViewController 外层套其他 viewController 之后再嵌入到 UINavigationcontroller。

如果调用代码所在的viewController在UINavigationcontroller中，可以如下方式集成（第一种集成方式）：

```objc
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"七鱼金融";
    source.urlString = @"https://8.163.com/";
    QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
    commodityInfo.title = @"网易七鱼";
    commodityInfo.desc = @"网易七鱼是网易旗下一款专注于解决企业与客户沟通的客服系统产品。";
    commodityInfo.pictureUrlString = @"http://qiyukf.com/main/res/img/index/barcode.png";
    commodityInfo.urlString = @"http://qiyukf.com/";
    commodityInfo.note = @"￥10000";
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"七鱼金融";
    sessionViewController.source = source;
    sessionViewController.commodityInfo = commodityInfo;
    sessionViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sessionViewController animated:YES];
```

如果调用代码所在的viewController不在UINavigationcontroller中，可如下方式集成（第二种集成方式）：

```objc
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"七鱼金融";
    source.urlString = @"https://8.163.com/";
    QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
    commodityInfo.title = @"网易七鱼";
    commodityInfo.desc = @"网易七鱼是网易旗下一款专注于解决企业与客户沟通的客服系统产品。";
    commodityInfo.pictureUrlString = @"http://qiyukf.com/main/res/img/index/barcode.png";
    commodityInfo.urlString = @"http://qiyukf.com/";
    commodityInfo.note = @"￥10000";
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"七鱼金融";
    sessionViewController.source = source;
    sessionViewController.commodityInfo = commodityInfo;
    sessionViewController.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = 
    			[[UINavigationController alloc] initWithRootViewController:sessionViewController];
        [self presentViewController:nav animated:YES completion:nil];
    [self presentViewController:nav animated:YES completion:nil];
```
一般来说，第二种方式会需要在左上角加一个返回按钮，在 “initWithRootViewController:sessionViewController” 之前加上：

```objc
    sessionViewController.navigationItem.leftBarButtonItem = 
    			[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered 
    								target:self action:@selector(onBack:)];
```

“onBack” 的样例：

```objc
- (void)onBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
```
    								
如果您的代码要求所有viewController继承某个公共基类，并且公共基类对UINavigationController统一做了某些处理；或者对UINavigationController做了自己的扩展，并且这会导致集成之后有某些问题；或者其他原因导致使用第一种方式集成会有问题；这些情况下，建议您使用第二种方式集成。

### 自定义商品信息
获取到 sessionViewController 之后，可以指定自定义商品信息。指定之后，在请求到客服时会自动发送一条商品信息的消息，客服端可看到此消息。

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

### 自定义访客端聊天组件UI效果

获取自定义UI类对象

```objc
	[[QYSDK sharedSDK] customUIConfig];
```
QYCustomUIConfig是负责自定义UI的类；目前主要是定义聊天界面中的字体颜色、大小、头像等。相关设置必须在集成访客端聊天组件之前进行。调整UI样例代码：

```objc
	/**
	 *  访客文本消息字体颜色
	 */
    [[QYSDK sharedSDK] customUIConfig].customMessageTextColor = [UIColor blackColor];
    /**
	 *  客服文本消息字体颜色
	 */
    [[QYSDK sharedSDK] customUIConfig].serviceMessageTextColor = [UIColor blackColor];
	/**
	 *  消息tableview的背景图片
	 */
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"session_bg"]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [[QYSDK sharedSDK] customUIConfig].sessionBackground = imageView;
	/**
	 *  访客头像
	 */
    [[QYSDK sharedSDK] customUIConfig].customerHeadImage = [UIImage imageNamed:@"customer_head"];
    /**
	 *  客服头像
	 */
    [[QYSDK sharedSDK] customUIConfig].serviceHeadImage = [UIImage imageNamed:@"service_head"];
    /**
	 *  访客消息气泡normal图片
	 */
    [[QYSDK sharedSDK] customUIConfig].customerMessageBubbleNormalImage = 
										[[UIImage imageNamed:@"icon_sender_node"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(15,15,30,30)
                                 resizingMode:UIImageResizingModeStretch];
    /**
	 *  访客消息气泡pressed图片
	 */
    [[QYSDK sharedSDK] customUIConfig].customerMessageBubblePressedImage = 
    									[[UIImage imageNamed:@"icon_sender_node"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(15,15,30,30)
                                  resizingMode:UIImageResizingModeStretch];
	/**
	 *  客服消息气泡normal图片
	 */
    [[QYSDK sharedSDK] customUIConfig].serviceMessageBubbleNormalImage = 
    									[[UIImage imageNamed:@"icon_receiver_node"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(15,30,30,15)
                                  resizingMode:UIImageResizingModeStretch];
    /**
	 *  客服消息气泡pressed图片
	 */
    [[QYSDK sharedSDK] customUIConfig].serviceMessageBubblePressedImage = 
    									[[UIImage imageNamed:@"icon_receiver_node"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(15,30,30,15)
                                  resizingMode:UIImageResizingModeStretch];
    /**
	 *  默认是YES,默认rightBarButtonItem内容是黑色，设置为NO，可以修改为白色
	 */
    [[QYSDK sharedSDK] customUIConfig].rightBarButtonItemColorBlackOrWhite = NO;
    /**
	 *  默认是YES,默认显示发送语音入口，设置为NO，可以修改为隐藏
	 */
    [QYCustomUIConfig sharedInstance].showAudioEntry = YSE;
    /**
	 *  默认是YES,默认显示发送表情入口，设置为NO，可以修改为隐藏
	 */
    [QYCustomUIConfig sharedInstance].showEmoticonEntry = YES;
	/**
	 *  默认是YES,默认进入聊天界面，是文本输入模式的话，会弹出键盘，设置为NO，可以修改为不弹出
	 */
    [QYCustomUIConfig sharedInstance].autoShowKeyboard = YES;
```

### 自定义访客端聊天组件事件处理

获取自定义事件处理类对象

```objc
	[[QYSDK sharedSDK] customActionConfig];
```
QYCustomActionConfig是负责自定义事件处理的类；目前支持自定义点击事件。

```objc

/**
 *  提供了所有自定义行为的接口;每个接口对应一个自定义行为的处理，
 *  如果设置了，则使用设置的处理，如果不设置，则采用默认处理
 */

typedef void (^QYLinkClickBlock)(NSString *linkAddress);

@interface QYCustomActionConfig : NSObject

+ (instancetype)sharedInstance;

/**
 *  所有消息中的链接（自定义商品消息、文本消息、机器人答案消息）的回调处理
 */
@property (nonatomic, copy) QYLinkClickBlock linkClickBlock;

@end

```

### 更换图片素材

QYCustomUIConfig只是负责替换部分皮肤相关内容，不包含所有的图片素材的替换。iOS SDK支持所有图片素材替换，只需要新建QYCustomResource.bundle，在其中放置跟QYResource.bundle中同名的图片素材，即可替换QYResource.bundle中的对应素材。为了效果好，应该放置同等尺寸的图片。

### 消息未读数处理

```objc
	[[QYSDK sharedSDK] conversationManager];
```

返回的是一个协议QYConversationManager；可通过此协议获得消息未读数以及设置Delegate,通过此Delegate可以监听未读数变化。

### APNS推送
* [制作推送证书并在管理后台配置](./iOS_apns.html "target=_blank")
* 初始化

```objc
	- (BOOL)application:(UIApplication *)application 
										didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
	{    
		......
		
		//传入正确的App名称
	   [[QYSDK sharedSDK] registerAppId:AppKey appName:App名称];
	    
		//注册 APNS
		if ([[UIApplication sharedApplication] 
									respondsToSelector:@selector(registerForRemoteNotifications)])
		{
			UIUserNotificationType types = UIRemoteNotificationTypeBadge 
									| UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
			UIUserNotificationSettings *settings = 
								[UIUserNotificationSettings settingsForTypes:types categories:nil];
			[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
			[[UIApplication sharedApplication] registerForRemoteNotifications];
		}
		else
		{
			UIRemoteNotificationType types = UIRemoteNotificationTypeAlert 
								| UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge;
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

### 注销

```objc
	[[QYSDK sharedSDK] logout:^(){}];
```

应用层退出自己的账号时需要调用 SDK 的注销操作，该操作会通知服务器进行 APNS 推送信息的解绑操作，避免用户已退出但推送依然发送到当前设备的情况发生。

### 指定客服Id或客服组Id

在获取 sessionViewController 之后，可以指定客服 Id 或客服组 Id

```objc
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.groupId = _groupId;
    sessionViewController.staffId = _staffId;
```

指定之后，进入聊天界面时，会直接以此 id 去请求到对应的客服或者客服组。在 管理后台 -> 设置 -> 访客分配 -> ID 查询 中可查询到客服 Id 或客服组 Id 。

### CRM

```objc
	[[QYSDK sharedSDK] setUserInfo:userInfo];
```
userInfo: 字段“id”表示用户id，字段“data”表示用户信息，具体请看官网CRM相关文档:
<a>http://qiyukf.com/newdoc/html/qiyu_crm_interface.html</a>

## FAQ
如果集成过程中遇到任何问题，可查看 [FAQ](./iOS_FAQ.html "target=_blank")

## 补充说明

如果您看完此文档后，还有任何集成方面的疑问，可以参考下 iOS SDK Demo 源码: https://github.com/qiyukf/QIYU_iOS_SDK_Demo_Source.git 。源码充分的展示了 iOS SDK 的能力，并且为集成 iOS SDK 提供了样例代码。




