//
//  QYCustomTextContentView.m
//  YSFDemo
//
//  Created by liaosipei on 2018/11/27.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "QYCustomTextContentView.h"
#import "QYCustomKeyDefine.h"
#import "QYCustomTextMessage.h"
#import "QYCustomTextModel.h"
#import <QYSDK/QYCustomSDK.h>

@interface QYCustomTextContentView ()

@property (nonatomic, strong) UILabel *textLabel;

@end


@implementation QYCustomTextContentView
- (instancetype)initCustomContentView {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.numberOfLines = 0;
        _textLabel.font = [UIFont systemFontOfSize:16.0f];
        _textLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)refreshData:(QYCustomModel *)model {
    [super refreshData:model];
    if (![model isKindOfClass:[QYCustomTextModel class]]) {
        return;
    }
    QYCustomTextModel *textModel = (QYCustomTextModel *)model;
    QYCustomTextMessage *textMessage = (QYCustomTextMessage *)textModel.message;
    
    _textLabel.text = textMessage.text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}

@end
