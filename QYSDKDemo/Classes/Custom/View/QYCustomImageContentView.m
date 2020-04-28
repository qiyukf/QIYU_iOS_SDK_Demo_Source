//
//  QYCustomImageContentView.m
//  YSFDemo
//
//  Created by liaosipei on 2018/11/28.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "QYCustomImageContentView.h"
#import "QYCustomKeyDefine.h"
#import "QYCustomImageMessage.h"
#import "QYCustomImageModel.h"
#import <QYSDK/QYCustomSDK.h>

NSString * const QYCustomEventTapImageButton = @"QYCustomEventTapImageButton";


@interface QYCustomImageContentView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation QYCustomImageContentView
- (instancetype)initCustomContentView {
    self = [super initCustomContentView];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"apple_logo"];
        [self addSubview:_imageView];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        _button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self
                    action:@selector(onTapButton:)
          forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return self;
}

- (void)refreshData:(QYCustomModel *)model {
    [super refreshData:model];
    if (![model isKindOfClass:[QYCustomImageModel class]]) {
        return;
    }
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat imgSize = 60;
    CGFloat space = 10;
    
    QYCustomImageModel *imgModel = (QYCustomImageModel *)model;
    QYCustomImageMessage *imgMessage = (QYCustomImageMessage *)imgModel.message;
    
    if (imgMessage.showImage) {
        _imageView.hidden = NO;
        _imageView.frame = CGRectMake((width - imgSize) / 2, space, imgSize, imgSize);
        
        [_button setTitle:@"hide" forState:UIControlStateNormal];
        _button.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame) + space, width, height - imgSize - 2 * space);
    } else {
        _imageView.hidden = YES;
        
        [_button setTitle:@"show" forState:UIControlStateNormal];
        _button.frame = CGRectMake(0, height / 2, width, height / 2);
    }
}

- (void)onTapButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        QYCustomEvent *event = [[QYCustomEvent alloc] init];
        event.eventName = QYCustomEventTapImageButton;
        event.message = self.model.message;
        [self.delegate onCatchEvent:event];
    }
}

@end
