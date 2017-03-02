//
//  YSFAttributedLabel.h
//  YSFAttributedLabel
//
//  Created by amao on 13-9-1.
//  Copyright (c) 2013年 www.xiangwangfeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "YSFAttributedLabelDefines.h"
#import "NSMutableAttributedString+YSFVendor.h"

@class YSFAttributedLabelURL;

@interface YSFAttributedLabel : UIView
@property (nonatomic,weak)    id<YSFAttributedLabelDelegate> delegate;
@property (nonatomic,strong)    UIFont *font;                   //字体
@property (nonatomic,strong)    UIColor *textColor;             //文字颜色
@property (nonatomic,strong)    UIColor *highlightColor;        //链接点击时背景高亮色
@property (nonatomic,strong)    UIColor *linkColor;             //链接色
@property (nonatomic,assign)    BOOL    underLineForLink;       //链接是否带下划线
@property (nonatomic,assign)    BOOL    autoDetectLinks;        //自动检测
@property (nonatomic,assign)    BOOL    autoDetectNumber;
@property (nonatomic,assign)    NSInteger   numberOfLines;      //行数
@property (nonatomic,assign)    CTTextAlignment textAlignment;  //文字排版样式
@property (nonatomic,assign)    CTLineBreakMode lineBreakMode;  //LineBreakMode
@property (nonatomic,assign)    CGFloat lineSpacing;            //行间距
@property (nonatomic,assign)    CGFloat paragraphSpacing;       //段间距
@property (nonatomic,strong)    NSMutableAttributedString *attributedString;


//普通文本
- (void)setText:(NSString *)text;
- (void)appendText: (NSString *)text;

//属性文本
- (void)setAttributedText:(NSAttributedString *)attributedText;
- (void)appendAttributedText: (NSAttributedString *)attributedText;

//图片
- (void)appendImage: (UIImage *)image;
- (void)appendImage: (UIImage *)image
            maxSize: (CGSize)maxSize;
- (void)appendImage: (UIImage *)image
            maxSize: (CGSize)maxSize
             margin: (UIEdgeInsets)margin;
- (void)appendImage: (UIImage *)image
            maxSize: (CGSize)maxSize
             margin: (UIEdgeInsets)margin
          alignment: (YSFImageAlignment)alignment;

//UI控件
- (void)appendView: (UIView *)view;
- (void)appendView: (UIView *)view
            margin: (UIEdgeInsets)margin;
- (void)appendView: (UIView *)view
            margin: (UIEdgeInsets)margin
         alignment: (YSFImageAlignment)alignment;


//添加自定义链接
- (void)addCustomLink: (id)linkData
             forRange: (NSRange)range;

- (void)addCustomLink: (id)linkData
             forRange: (NSRange)range
            linkColor: (UIColor *)color;

//大小
- (CGSize)sizeThatFits:(CGSize)size;

//设置全局的自定义Link检测Block(详见YSFAttributedLabelURL)
+ (void)setCustomDetectMethod:(YSFCustomDetectLinkBlock)block;

- (void)appendHTMLText:(NSString *)htmlText;


@end
