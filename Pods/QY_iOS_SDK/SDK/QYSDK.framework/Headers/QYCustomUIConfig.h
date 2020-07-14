//
//  QYCustomUIConfig.h
//  QYSDK
//
//  Created by Netease on 12/21/15.
//  Copyright (c) 2017 Netease. All rights reserved.
//

/**
 *  工具栏自定义配置项：QYCustomInputItem
 */

/**
 *  输入框下方“更多”配置项点击回调
 */
typedef void (^QYCustomInputItemBlock)(void);

/**
 *  输入框下方“更多”配置项
 *  注：为达到最佳效果，配置项图片最佳尺寸为64ptx64pt
 */
@interface QYCustomInputItem : NSObject

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) QYCustomInputItemBlock block;

@end


/**
 *  自定义UI配置类：QYCustomUIConfig，单例模式
 *  如果想要替换图片素材，可以自己创建一个QYCustomResource.bundle，在其中放置与QYResource.bundle同名的图片素材，即可实现替换。
 *  SDK会优先使用QYCustomResource.bundle中的图片素材，若QYCustomResource.bundle中没有，才会使用QYResource.bundle中的图片素材。
 */

/**
 *  访客分流展示模式
 */
typedef NS_ENUM(NSInteger, QYBypassDisplayMode) {
    QYBypassDisplayModeNone,
    QYBypassDisplayModeCenter,
    QYBypassDisplayModeBottom
};

/**
 *  消息下拉加载状态
 */
typedef NS_ENUM(NSInteger, QYMessagesLoadState) {
    QYMessagesLoadStateIdle,
    QYMessagesLoadStateWillLoad,
    QYMessagesLoadStateLoading,
};


@interface QYCustomUIConfig : NSObject

+ (instancetype)sharedInstance;


/**
 *  恢复默认设置
 */
- (void)restoreToDefault;


//聊天背景设置

/**
 *  消息tableview的背景图片
 */
@property (nonatomic, strong) UIImageView *sessionBackground;


//主题色设置

/**
 *  聊天页面主题色，包括访客气泡填充色、按钮填充色、默认头像填充色、“+”按钮填充色等；默认蓝色
 *  注意：设置主题色会修改部分属性，例如访客默认头像、访客消息气泡等，后续再次修改此类属性会覆盖主题色设置
 */
@property (nonatomic, strong) UIColor *themeColor;


//导航栏相关设置（人工/评价按钮可后台关闭显示）

/**
 *  导航栏右侧按钮风格，默认灰色风格，NO为白色风格
 */
@property (nonatomic, assign) BOOL rightItemStyleGrayOrWhite;

/**
 *  导航栏右侧退出会话按钮是否显示，默认为NO
 */
@property (nonatomic, assign) BOOL showCloseSessionEntry;

/**
 *  是否显示消息流头像
 */
@property (nonatomic, assign) BOOL showHeadImage;

/**
 *  是否显示导航栏客服头像
 */
@property (nonatomic, assign) BOOL showTopHeadImage;


//访客相关设置

/**
 *  访客头像
 */
@property (nonatomic, strong) UIImage *customerHeadImage;
@property (nonatomic, copy) NSString *customerHeadImageUrl;

/**
 *  访客消息气泡normal图片
 */
@property (nonatomic, strong) UIImage *customerMessageBubbleNormalImage;

/**
 *  访客消息气泡pressed图片
 */
@property (nonatomic, strong) UIImage *customerMessageBubblePressedImage;

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


//客服相关设置

/**
 *  客服头像
 */
@property (nonatomic, strong) UIImage *serviceHeadImage;
@property (nonatomic, copy) NSString *serviceHeadImageUrl;

/**
 *  客服消息气泡normal图片
 */
@property (nonatomic, strong) UIImage *serviceMessageBubbleNormalImage;

/**
 *  客服消息气泡pressed图片
 */
@property (nonatomic, strong) UIImage *serviceMessageBubblePressedImage;

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


//提示消息相关设置（例：***为你服务）

/**
 *  提示文本消息字体颜色；提示文本消息有很多种，比如“***为你服务”就是一种
 */
@property (nonatomic, strong) UIColor *tipMessageTextColor;

/**
 *  提示文本消息字体大小；提示文本消息有很多种，比如“***为你服务”就是一种
 */
@property (nonatomic, assign) CGFloat tipMessageTextFontSize;


//消息相关设置

/**
 *  访客分流展示模式
 */
@property (nonatomic, assign) QYBypassDisplayMode bypassDisplayMode;

/**
 *  消息竖直方向间距
 */
@property (nonatomic, assign) CGFloat sessionMessageSpacing;

/**
 *  头像与消息气泡间距，默认为4pt
 */
@property (nonatomic, assign) CGFloat headMessageSpacing;

/**
 *  消息内强提示按钮文字颜色，例如"立即评价"按钮，默认白色
 */
@property (nonatomic, strong) UIColor *messageButtonTextColor;

/**
 *  消息内强提示按钮底色，例如"立即评价"按钮，默认蓝色
 */
@property (nonatomic, strong) UIColor *messageButtonBackColor;


//输入栏上方操作按钮设置

/**
 *  输入框上方操作按钮文字颜色
 */
@property (nonatomic, strong) UIColor *actionButtonTextColor;

/**
 *  输入框上方操作按钮边框颜色
 */
@property (nonatomic, strong) UIColor *actionButtonBorderColor;


//输入栏设置

/**
 *  输入框字体颜色
 */
@property (nonatomic, strong) UIColor *inputTextColor;

/**
 *  输入框字体大小
 */
@property (nonatomic, assign) CGFloat inputTextFontSize;

/**
 *  输入框占位文案
 */
@property (nonatomic, copy) NSString *inputTextPlaceholder;

/**
 *  输入栏语音按钮，人工模式下是否显示，默认为YES
 */
@property (nonatomic, assign) BOOL showAudioEntry;

/**
 *  输入栏语音按钮，机器人模式下是否显示，默认为YES
 */
@property (nonatomic, assign) BOOL showAudioEntryInRobotMode;

/**
 *  输入栏表情按钮是否显示，默认为YES
 */
@property (nonatomic, assign) BOOL showEmoticonEntry;

/**
 *  输入栏相机按钮是否显示，默认为YES
 */
@property (nonatomic, assign) BOOL showImageEntry;

/**
 * 照片/视频选择页面主题颜色，默认为蓝色
 */
@property (nonatomic, strong) UIColor *imagePickerColor;

/**
 *  进入聊天界面是否自动弹出键盘，默认为YES
 */
@property (nonatomic, assign) BOOL autoShowKeyboard;

/**
 *  表示聊天组件离界面底部的间距，默认是0；比较典型的是底部有tabbar，这时候设置为tabbar的高度即可
 */
@property (nonatomic, assign) CGFloat bottomMargin;


//平台电商相关设置

/**
 *  导航栏右侧商铺入口按钮是否显示，默认为NO
 */
@property (nonatomic, assign) BOOL showShopEntrance;

/**
 *  聊天内容区域的按钮（对于平台电商来说，这里可以考虑放置“会话列表入口“）显示，默认不显示
 */
@property (nonatomic, assign) BOOL showSessionListEntrance;

/**
 *  会话列表入口icon
 */
@property (nonatomic, strong) UIImage *sessionListEntranceImage;

/**
 *  聊天内容区域的按钮（对于平台电商来说，这里可以考虑放置“会话列表入口“）在聊天页面的位置，YES代表在右上角，NO代表在左上角，默认在右上角
 */
@property (nonatomic, assign) BOOL sessionListEntrancePosition;


//会话窗口上方提示条相关设置

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
 *  输入框下方“完全自定义”配置项
 */
@property (nonatomic, strong) NSArray<QYCustomInputItem *> *customInputItems;

/**
 *  消息下拉刷新loading图片设置，区分不同state状态
 */
- (void)setMessagesLoadImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(QYMessagesLoadState)state;

/**
 *  注册自定义商品卡片消息的model及contentView，配置其UI显示
 *  @discussion 若要使用自定义商品卡片功能，需调用此方法设置映射关系，注意应在卡片消息渲染前设置
 *  @param modelClass       QYCustomCommodityInfo类型消息对应的数据模型类，QYCustomModel子类
 *  @param contentViewClass QYCustomCommodityInfo类型消息对应的视图，QYCustomContentView子类
 */
- (void)registerCustomCommodityInfoModelClass:(Class)modelClass contentViewClass:(Class)contentViewClass;


//因访客端体验升级，以下属性在v5.1.0版本废弃
/**
 *  导航栏右侧按钮文案颜色,默认是灰色,优先级高于rightItemStyleGrayOrWhite
 */
//@property (nonatomic, strong) UIColor *rightItemTextColor;

/**
 *  人工按钮文案
 */
//@property (nonatomic, copy) NSString *humanButtonText;

/**
 *  聊天窗口右上角按钮（对于平台电商来说，这里可以考虑放“商铺入口”）文本
 */
//@property (nonatomic, copy) NSString *shopEntranceText;

/**
 *  聊天窗口右上角按钮（对于平台电商来说，这里可以考虑放“商铺入口”）icon
 */
//@property (nonatomic, strong) UIImage *shopEntranceImage;

@end



