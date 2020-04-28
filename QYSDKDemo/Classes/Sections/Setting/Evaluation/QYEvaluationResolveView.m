//
//  QYEvaluationResolveView.m
//  YSFDemo
//
//  Created by liaosipei on 2019/7/19.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "QYEvaluationResolveView.h"
#import "QYMacro.h"


@interface QYEvaluationResolveView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *resolvedButton;
@property (nonatomic, strong) UIButton *unsolvedButton;

@end


@implementation QYEvaluationResolveView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:14.0f];
        _label.textColor = YSFQYTextGrayColor;
        _label.text = @"您的问题";
        [self addSubview:_label];
        
        _resolvedButton = [self makeButtonWithTitle:@"已解决"];
        [_resolvedButton addTarget:self action:@selector(onResolvedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_resolvedButton];
        
        _unsolvedButton = [self makeButtonWithTitle:@"未解决"];
        [_unsolvedButton addTarget:self action:@selector(onUnsolvedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_unsolvedButton];
        
        [self updateButtonStatus:NO button:_resolvedButton];
        [self updateButtonStatus:NO button:_unsolvedButton];
    }
    return self;
}

- (void)setStatus:(QYEvaluationResolveStatus)status {
    _status = status;
    if (status == QYEvaluationResolveStatusNone) {
        [self updateButtonStatus:NO button:_resolvedButton];
        [self updateButtonStatus:NO button:_unsolvedButton];
    } else if (status == QYEvaluationResolveStatusResolved) {
        [self updateButtonStatus:YES button:_resolvedButton];
        [self updateButtonStatus:NO button:_unsolvedButton];
    } else if (status == QYEvaluationResolveStatusUnsolved) {
        [self updateButtonStatus:NO button:_resolvedButton];
        [self updateButtonStatus:YES button:_unsolvedButton];
    }
}

- (void)updateButtonStatus:(BOOL)selected button:(UIButton *)button {
    button.selected = selected;
    if (button.selected) {
        button.backgroundColor = [YSFQYBlueColor colorWithAlphaComponent:0.05];
        button.layer.borderColor = YSFQYBlueColor.CGColor;
        [button setTitleColor:YSFQYBlueColor forState:UIControlStateNormal];
    } else {
        button.backgroundColor = YSFColorFromRGB(0xf2f3f5);
        button.layer.borderColor = button.backgroundColor.CGColor;
        [button setTitleColor:YSFQYButtonTitleDisableColor forState:UIControlStateNormal];
    }
}

- (UIButton *)makeButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 2.0f;
    btn.layer.borderWidth = (1. / [UIScreen mainScreen].scale);
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    return btn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = CGRectMake(0, 0, QYEvaluationResolveButtonWidth, QYEvaluationResolveHeight);
    self.resolvedButton.frame = CGRectMake(CGRectGetMaxX(self.label.frame) + QYEvaluationResolveSpace,
                                           0,
                                           QYEvaluationResolveButtonWidth,
                                           QYEvaluationResolveHeight);
    self.unsolvedButton.frame = CGRectMake(CGRectGetMaxX(self.resolvedButton.frame) + QYEvaluationResolveSpace,
                                           0,
                                           QYEvaluationResolveButtonWidth,
                                           QYEvaluationResolveHeight);
}

#pragma mark - Action
- (void)onResolvedButton:(id)sender {
    if (self.status == QYEvaluationResolveStatusResolved) {
        self.status = QYEvaluationResolveStatusNone;
    } else {
        self.status = QYEvaluationResolveStatusResolved;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectResolveButton:)]) {
        [self.delegate didSelectResolveButton:self.status];
    }
}

- (void)onUnsolvedButton:(id)sender {
    if (self.status == QYEvaluationResolveStatusUnsolved) {
        self.status = QYEvaluationResolveStatusNone;
    } else {
        self.status = QYEvaluationResolveStatusUnsolved;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectResolveButton:)]) {
        [self.delegate didSelectResolveButton:self.status];
    }
}

@end
