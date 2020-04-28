//
//  QYCustomTicketContentView.m
//  YSFDemo
//
//  Created by liaosipei on 2019/11/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "QYCustomTicketContentView.h"
#import "QYCustomTicketMessage.h"
#import "QYCustomTicketModel.h"
#import <QYSDK/QYCustomSDK.h>

NSString * const QYCustomEventTapTicketButton = @"QYCustomEventTapTicketButton";

@interface QYCustomTicketContentView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) NSMutableArray *tagViews;
@property (nonatomic, strong) UIButton *button;

@end


@implementation QYCustomTicketContentView
- (instancetype)initCustomContentView {
    self = [super initCustomContentView];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)refreshData:(QYCustomModel *)model {
    [super refreshData:model];
    if (![model isKindOfClass:[QYCustomTicketModel class]]) {
        return;
    }
    
    QYCustomTicketModel *ticModel = (QYCustomTicketModel *)model;
    QYCustomTicketMessage *ticMessage = (QYCustomTicketMessage *)ticModel.message;
    
    self.titleLabel.text = ticMessage.title;
    self.priceLabel.text = ticMessage.price;
    self.descLabel.text = ticMessage.desc;
    [self.button setTitle:ticMessage.buttonTitle forState:UIControlStateNormal];
    
    if ([self.tagViews count]) {
        [self.tagViews removeAllObjects];
    } else {
        self.tagViews = [NSMutableArray array];
    }
    if ([ticMessage.tagArray count]) {
        for (NSString *tagString in ticMessage.tagArray) {
            if (tagString.length) {
                UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                tagBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                tagBtn.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
                tagBtn.layer.cornerRadius = 2.0f;
                tagBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
                [tagBtn setTitle:tagString forState:UIControlStateNormal];
                [tagBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [self.contentView addSubview:tagBtn];
                [self.tagViews addObject:tagBtn];
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat imgSize = 40;
    CGFloat space = 15;
    
    self.contentView.frame = CGRectMake(space, 8, width - 2 * space, height - 16);
    self.iconView.frame = CGRectMake(space, space + 8, imgSize, imgSize);
    self.titleLabel.frame = CGRectMake(imgSize + 2 * space, space, CGRectGetWidth(self.contentView.frame) - 3 * space - imgSize, 18);
    self.priceLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                       CGRectGetMaxY(self.titleLabel.frame) + 4,
                                       CGRectGetWidth(self.contentView.frame) - 3 * space - imgSize,
                                       18);
    self.descLabel.frame = CGRectMake(CGRectGetMinX(self.priceLabel.frame),
                                      CGRectGetMaxY(self.priceLabel.frame) + 4,
                                      CGRectGetWidth(self.contentView.frame) - 3 * space - imgSize,
                                      18);
    self.button.frame = CGRectMake((CGRectGetWidth(self.contentView.frame) - 100) / 2, CGRectGetHeight(self.contentView.frame) - space - 30, 100, 30);
    
    CGFloat offset_X = CGRectGetMinX(self.descLabel.frame);
    for (NSInteger i = 0; i < [self.tagViews count]; i++) {
        UIButton *tagBtn = [self.tagViews objectAtIndex:i];
        [tagBtn sizeToFit];
        tagBtn.frame = CGRectMake(offset_X, CGRectGetMaxY(self.descLabel.frame) + 4, CGRectGetWidth(tagBtn.frame) + 4, 18);
        offset_X = CGRectGetMaxX(tagBtn.frame) + 5;
        if (offset_X > CGRectGetWidth(self.contentView.frame)) {
            tagBtn.frame = CGRectZero;
        }
    }
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
        _contentView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        _contentView.layer.cornerRadius = 5.0f;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconView.image = [UIImage imageNamed:@"service_head"];
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [UIFont systemFontOfSize:14.0f];
        _priceLabel.textColor = [UIColor orangeColor];
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.font = [UIFont systemFontOfSize:14.0f];
        _descLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_descLabel];
    }
    return _descLabel;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.layer.borderColor = [UIColor orangeColor].CGColor;
        _button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        _button.layer.cornerRadius = 2.0f;
        _button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
    }
    return _button;
}

#pragma mark - action
- (void)onClickButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        QYCustomEvent *event = [[QYCustomEvent alloc] init];
        event.eventName = QYCustomEventTapTicketButton;
        event.message = self.model.message;
        [self.delegate onCatchEvent:event];
    }
}

@end
