//
//  QYEvaluationViewController.m
//  YSFDemo
//
//  Created by liaosipei on 2019/6/11.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "QYEvaluationViewController.h"
#import "UIView+YSF.h"
#import "UIView+YSFToast.h"
#import "UIControl+QYBlocksKit.h"
#import "QYEvaluationResolveView.h"
#import "QYMacro.h"
#import <QYSDK/QYSessionViewController.h>


static CGFloat kEvaluationContentPortraitHeight = 377;
static CGFloat kEvaluationContentLandscapeHeight = 220;
static CGFloat kEvaluationButtonTitleInset_Top = 70;
static CGFloat kEvaluationButtonTitleInset_Left = -40;
static CGFloat kEvaluationTitleHeight = 40;
static CGFloat kEvaluationCloseSize = 40;
static CGFloat kEvaluationSatisButtonTop = 20;
static CGFloat kEvaluationSatisButtonWidth = 60;
static CGFloat kEvaluationTagViewMargin = 16;
static CGFloat kEvaluationTagViewTop = 90;
static CGFloat kEvaluationTagButtonMargin = 10;
static CGFloat kEvaluationTagButtonGap = 10;
static CGFloat kEvaluationSubmiteHeight = 70;
static CGFloat kEvaluationSubmiteButtonHeight = 42;

static CGFloat kEvaluationTextViewHeight = 62;
static CGFloat kEvaluationTextViewDefaultTop = 110;


typedef NS_ENUM(NSInteger, QYEvaluationSubmitType) {
    QYEvaluationSubmitTypeEnable = 0,  //提交，可点击
    QYEvaluationSubmitTypeUnable,      //提交，不可点击
    QYEvaluationSubmitTypeSubmitting,  //提交中，不可点击
};


@interface QYEvaluationViewController () <UIAlertViewDelegate, UITextViewDelegate, QYEvaluationResolveViewDelegate>

@property (nonatomic, strong) QYEvaluactionData *evaluationData;    //评价数据
@property (nonatomic, weak) QYSessionViewController *sessionViewController;
//@property (nonatomic, copy) evaluationCallback evaluationCallback;  //结果回调

@property (nonatomic, strong) UIView *contentView;          //内容区域
@property (nonatomic, strong) UIView *topLineView1;         //分割线
@property (nonatomic, strong) UILabel *titleLabel;          //标题
@property (nonatomic, strong) UIButton *closeButton;        //关闭按钮
@property (nonatomic, strong) UIView *topLineView2;         //分割线
@property (nonatomic, strong) UIScrollView *scrollView;     //滚动区域
@property (nonatomic, strong) NSMutableArray *satisButtons; //满意度按钮集合
@property (nonatomic, strong) NSMutableArray *tagViews;     //标签视图集合
@property (nonatomic, strong) UITextView *textView;         //备注输入区域
@property (nonatomic, strong) UILabel *placeholderLabel;    //备注默认
@property (nonatomic, strong) UIView *bottomLineView;       //分割线
@property (nonatomic, strong) UIButton *submitButton;       //提交按钮
@property (nonatomic, strong) QYEvaluationResolveView *resolveView;  //问题解决

@property (nonatomic, strong) UIButton *selectedButton;      //选中按钮
@property (nonatomic, strong) UIView *selectedTagView;       //选中标签视图
@property (nonatomic, strong) QYEvaluationOptionData *selectOption; //选中tag数据

@property (nonatomic, assign) CGRect kbFrame;

@end


@implementation QYEvaluationViewController
- (void)dealloc {
    
}

- (instancetype)initWithEvaluationData:(QYEvaluactionData *)evaluationData sessionVC:(QYSessionViewController *)sessionVC {
    self = [super init];
    if (self) {
        _evaluationData = evaluationData;
        _sessionViewController = sessionVC;
        _kbFrame = CGRectZero;
        
        _satisButtons = [NSMutableArray array];
        _tagViews = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    __weak typeof(self) weakSelf = self;
    self.view.backgroundColor = QYColorFromRGBA(0x000000, 0.5);
    CGFloat lineWidth = (1. / [UIScreen mainScreen].scale);
    //contentView
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.ysf_frameWidth = self.view.ysf_frameWidth;
    _contentView.ysf_frameHeight = kEvaluationContentPortraitHeight;
    _contentView.ysf_frameBottom = self.view.ysf_frameBottom;
    [self.view addSubview:_contentView];
    //topLineView1
    _topLineView1 = [[UIView alloc] init];
    _topLineView1.backgroundColor = QYColorFromRGB(0xdcdcdc);
    //titleLabel
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = QYColorFromRGB(0xf1f1f1);
    _titleLabel.text = @"自定义评价界面";
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = QYRGB(0x222222);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_titleLabel];
    //closeButton
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[self getImageInBundle:@"icon_evaluation_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_closeButton];
    //topLineView2
    _topLineView2 = [[UIView alloc] init];
    _topLineView2.backgroundColor = QYColorFromRGB(0xdcdcdc);
    //scrollView
    _scrollView = [[UIScrollView alloc] init];
    [_contentView addSubview:_scrollView];
    //satisButtons & tagViews
    if (_evaluationData.optionList.count) {
        for (QYEvaluationOptionData *optionData in _evaluationData.optionList) {
            //1.根据tag数据创建相应的满意度按钮，并放入satisButtons数组
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = optionData.option;
            UIImage *image = [self getButtonNormalImageForTagType:optionData.option];
            [button setImage:image forState:UIControlStateNormal];
            [button setImage:image forState:UIControlStateHighlighted];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 11, 0, 0);
            [button setTitle:optionData.name forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.titleEdgeInsets = UIEdgeInsetsMake(kEvaluationButtonTitleInset_Top, kEvaluationButtonTitleInset_Left, 0, 0);
            button.titleLabel.layer.cornerRadius = 4.0;
            button.titleLabel.layer.masksToBounds = YES;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button sizeToFit];
            [button ysf_addEventHandler:^(id sender) {
                [weakSelf onSelect:sender];
            } forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
            //add button to array
            [_satisButtons addObject:button];
            //2.根据tag数据中的tagList创建相应的标签按钮并add到tagView上，最终将tagView放入tagViews数组
            UIView *tagView = [[UIView alloc] initWithFrame:CGRectZero];
            tagView.tag = optionData.option;
            for (NSString *tagString in optionData.tagList) {
                UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [tagButton setTitle:tagString forState:UIControlStateNormal];
                [tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [tagButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                tagButton.layer.cornerRadius = 10.0;
                tagButton.layer.borderWidth = lineWidth;
                tagButton.layer.borderColor = QYRGB(0xcccccc).CGColor;
                tagButton.titleLabel.font = [UIFont systemFontOfSize:12];
                tagButton.titleEdgeInsets = UIEdgeInsetsMake(0, kEvaluationTagButtonMargin, 0, kEvaluationTagButtonMargin);
                tagButton.titleLabel.layer.masksToBounds = YES;
                __weak typeof(tagButton) weakTagButton = tagButton;
                [tagButton ysf_addEventHandler:^(id sender) {
                    weakTagButton.selected = !weakTagButton.selected;
                    if (weakTagButton.selected) {
                        weakTagButton.backgroundColor = QYColorFromRGB(0x999999);
                    } else {
                        weakTagButton.backgroundColor = [UIColor clearColor];
                    }
                    if (weakSelf.evaluationData.lastResult) {
                        [weakSelf updateSubmitButtonEnable:QYEvaluationSubmitTypeEnable];
                    }
                } forControlEvents:UIControlEventTouchUpInside];
                [tagView addSubview:tagButton];
            }
            tagView.hidden = YES;
            [_scrollView addSubview:tagView];
            //add tagView to array
            [_tagViews addObject:tagView];
        }
    }
    //textView
    _textView = [[UITextView alloc] init];
    _textView.delegate = self;
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont systemFontOfSize:13.0];
    _textView.layer.borderColor = QYColorFromRGB(0xdcdcdc).CGColor;
    _textView.layer.borderWidth = lineWidth;
    _textView.layer.cornerRadius = 3.0;
    [_scrollView addSubview:_textView];
    //placeholderLabel
    _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    _placeholderLabel.text = @"评价备注";
    _placeholderLabel.font = [UIFont systemFontOfSize:13.0];
    [_textView addSubview:_placeholderLabel];
    //resolveView
    _resolveView = [[QYEvaluationResolveView alloc] init];
    _resolveView.status = QYEvaluationResolveStatusNone;
    _resolveView.delegate = self;
    [_scrollView addSubview:_resolveView];
    //bottomLineView
    _bottomLineView = [[UIView alloc] init];
    _bottomLineView.backgroundColor = QYColorFromRGB(0xdcdcdc);
    //submitButton
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    _submitButton.layer.cornerRadius = 3.0;
    [_submitButton addTarget:self action:@selector(onSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_submitButton];
    [self updateSubmitButtonEnable:QYEvaluationSubmitTypeUnable];
    
    [_contentView addSubview:_topLineView1];
    [_contentView addSubview:_topLineView2];
    [_contentView addSubview:_bottomLineView];
    
    [self updateLastResult];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat lineWidth = (1. / [UIScreen mainScreen].scale);
    //contentView
    BOOL isLandscape = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);
    _contentView.ysf_frameWidth = self.view.ysf_frameWidth;
    _contentView.ysf_frameBottom = self.view.ysf_frameBottom;
    _contentView.ysf_frameHeight = isLandscape ? kEvaluationContentLandscapeHeight : kEvaluationContentPortraitHeight;
    if (!CGRectEqualToRect(_kbFrame, CGRectZero) && _kbFrame.origin.y < CGRectGetHeight(self.view.bounds) && CGRectGetHeight(_kbFrame)) {
        CGRect contentFrame = _contentView.frame;
        contentFrame.origin.y = _kbFrame.origin.y - contentFrame.size.height;
        if (contentFrame.origin.y < QYStatusBarHeight) {
            contentFrame.origin.y = QYStatusBarHeight;
            contentFrame.size.height = CGRectGetHeight([UIScreen mainScreen].bounds) - QYStatusBarHeight - _kbFrame.size.height;
        }
        _contentView.frame = contentFrame;
    }
    //topLineView1
    _topLineView1.ysf_frameWidth = _contentView.ysf_frameWidth;
    _topLineView1.ysf_frameHeight = lineWidth;
    //titleLabel
    _titleLabel.ysf_frameWidth = _contentView.ysf_frameWidth;
    _titleLabel.ysf_frameHeight = kEvaluationTitleHeight;
    //closeButton
    _closeButton.ysf_frameWidth = kEvaluationCloseSize;
    _closeButton.ysf_frameHeight = kEvaluationCloseSize;
    _closeButton.ysf_frameRight = _contentView.ysf_frameWidth;
    //topLineView2
    _topLineView2.ysf_frameWidth = _contentView.ysf_frameWidth;
    _topLineView2.ysf_frameHeight = lineWidth;
    _topLineView2.ysf_frameTop = _titleLabel.ysf_frameBottom;
    //scrollView
    _scrollView.ysf_frameWidth = _contentView.ysf_frameWidth;
    _scrollView.ysf_frameTop = _titleLabel.ysf_frameBottom;
    _scrollView.ysf_frameHeight = CGRectGetHeight(_contentView.frame) - CGRectGetHeight(_titleLabel.frame) - kEvaluationSubmiteHeight;
    //item space
    CGFloat space = 0;
    NSUInteger count = _evaluationData.optionList.count;
    if (count > 0) {
        space = (_contentView.ysf_frameWidth - kEvaluationSatisButtonWidth * count) / (count + 1);
    }
    //satisButtons
    CGFloat satisButtonBottom = 0;
    for (NSInteger index = 0; index < _satisButtons.count; index++) {
        UIButton *button = [_satisButtons objectAtIndex:index];
        button.ysf_frameTop = kEvaluationSatisButtonTop;
        button.ysf_frameWidth = kEvaluationSatisButtonWidth;
        button.ysf_frameLeft = roundf(space * (index + 1) + kEvaluationSatisButtonWidth * index);
        satisButtonBottom = button.ysf_frameBottom;
    }
    //tagViews
    for (UIView *tagView in _tagViews) {
        tagView.ysf_frameWidth = _contentView.ysf_frameWidth - 2 * kEvaluationTagViewMargin;
        tagView.ysf_frameCenterX = _contentView.ysf_frameCenterX;
        tagView.ysf_frameTop = kEvaluationTagViewTop;
        tagView.ysf_frameHeight = 30;
        
        CGFloat tagButtonRight = 0;
        CGFloat tagButtonBottom = 0;
        CGFloat totalHeight = 0;
        for (UIButton *tagButton in tagView.subviews) {
            [tagButton sizeToFit];
            tagButton.ysf_frameWidth += 2 * kEvaluationTagButtonMargin;
            tagButton.ysf_frameLeft = tagButtonRight + kEvaluationTagButtonGap;
            tagButton.ysf_frameTop = tagButtonBottom + kEvaluationTagButtonGap;
            if (tagButton.ysf_frameRight > tagView.ysf_frameWidth) {
                tagButtonRight = 0;
                tagButtonBottom = tagButtonBottom + tagButton.ysf_frameHeight + kEvaluationTagButtonGap;
                tagButton.ysf_frameLeft = tagButtonRight + kEvaluationTagButtonGap;
                tagButton.ysf_frameTop = tagButtonBottom + kEvaluationTagButtonGap;
            }
            tagButtonRight = tagButton.ysf_frameRight;
            totalHeight = tagButton.ysf_frameBottom;
        }
        tagView.ysf_frameHeight = totalHeight;
    }
    
    CGFloat content_H = 0;
    //textView
    _textView.ysf_frameWidth = _contentView.ysf_frameWidth - 2 * kEvaluationTagViewMargin;
    _textView.ysf_frameCenterX = _contentView.ysf_frameCenterX;
    _textView.ysf_frameHeight = kEvaluationTextViewHeight;
    if (_selectedTagView) {
        _textView.ysf_frameTop = _selectedTagView.ysf_frameBottom + 20;
    } else {
        _textView.ysf_frameTop = kEvaluationTextViewDefaultTop;
    }
    content_H = _textView.ysf_frameBottom + 10;
    //resolveView
    if (_evaluationData.resolvedEnabled) {
        _resolveView.ysf_frameTop = _textView.ysf_frameBottom + 16;
        _resolveView.ysf_frameLeft = _textView.ysf_frameLeft;
        _resolveView.ysf_frameWidth = _textView.ysf_frameWidth;
        _resolveView.ysf_frameHeight = QYEvaluationResolveHeight;
        _resolveView.hidden = NO;
        content_H = _resolveView.ysf_frameBottom + 16;
    } else {
        _resolveView.hidden = YES;
    }
    //scrollView contentSize
    _scrollView.contentSize = CGSizeMake(_contentView.ysf_frameWidth, content_H);
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    //bottomLineView
    _bottomLineView.ysf_frameWidth = _contentView.ysf_frameWidth;
    _bottomLineView.ysf_frameHeight = lineWidth;
    _bottomLineView.ysf_frameTop = _scrollView.ysf_frameBottom;
    //submitButton
    _submitButton.ysf_frameWidth = _contentView.ysf_frameWidth - 2 * kEvaluationTagViewMargin;
    _submitButton.ysf_frameCenterX = _contentView.ysf_frameCenterX;
    _submitButton.ysf_frameHeight = kEvaluationSubmiteButtonHeight;
    _submitButton.ysf_frameTop = _scrollView.ysf_frameBottom + (kEvaluationSubmiteHeight - kEvaluationSubmiteButtonHeight) / 2;
}

#pragma mark - action
- (void)onSelect:(id)sender {
    [self.view endEditing:YES];
    //clean
    _selectedButton.selected = NO;
    _selectedButton.titleLabel.backgroundColor = [UIColor clearColor];
    _selectedTagView.hidden = YES;
    //selectedButton
    UIButton *button = (UIButton *)sender;
    _selectedButton = button;
    _selectedButton.selected = YES;
    _selectedButton.titleLabel.backgroundColor = QYColorFromRGB(0x999999);
    //selectedButton animation
    CGAffineTransform oldTransForm =  button.imageView.transform;
    CGAffineTransform transform = CGAffineTransformScale(oldTransForm, 1.2, 1.2);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        button.imageView.transform = transform;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1 delay:0.05 options:UIViewAnimationOptionCurveLinear animations:^{
            button.imageView.transform = oldTransForm;
        } completion:nil];
    }];
    //selectedTagView
    for (UIView *tagView in _tagViews) {
        if (tagView.tag == button.tag) {
            _selectedTagView = tagView;
        }
    }
    _selectedTagView.hidden = NO;
    [_contentView bringSubviewToFront:_selectedTagView];
    
    for (QYEvaluationOptionData *optionData in _evaluationData.optionList) {
        if (_selectedButton.tag == optionData.option) {
            _selectOption = optionData;
        }
    }
    //submiteButton
    [self updateSubmitButtonEnable:QYEvaluationSubmitTypeEnable];
    
    [self.view setNeedsLayout];
}

- (void)onSubmit:(id)sender {
    if (!_selectOption) {
        return;
    }
    NSArray *selectedTags = [self getSelectedTags];
    if (_selectOption.tagRequired && (!selectedTags || selectedTags.count == 0)) {
        [self showToast:@"请选择标签"];
        return;
    }
    if (_selectOption.remarkRequired && _textView.text.length == 0) {
        [self showToast:@"请填写评价备注"];
        return;
    }
    if (self.evaluationData.resolvedEnabled
        && self.evaluationData.resolvedRequired
        && _resolveView.status == QYEvaluationResolveStatusNone) {
        [self showToast:@"请选择本次问题是否解决"];
        return;
    }
    if (self.sessionViewController) {
        [self updateSubmitButtonEnable:QYEvaluationSubmitTypeSubmitting];
        
        QYEvaluactionResult *result = [[QYEvaluactionResult alloc] init];
        result.sessionId = _evaluationData.sessionId;
        result.selectOption = _selectOption;
        result.selectTags = selectedTags;
        result.remarkString = _textView.text;
        result.resolveStatus = _resolveView.status;
        __weak typeof(self) weakSelf = self;
        [self.sessionViewController sendEvaluationResult:result completion:^(QYEvaluationState state) {
            [weakSelf updateSubmitButtonEnable:QYEvaluationSubmitTypeEnable];
            if (state == QYEvaluationStateFailParamError) {
                [weakSelf showToast:@"提交参数有误"];
            } else if (state == QYEvaluationStateFailNetError) {
                [weakSelf showToast:@"网络连接失败，请稍后再试"];
            } else if (state == QYEvaluationStateFailNetTimeout) {
                [weakSelf showToast:@"网络连接超时，请稍后再试"];
            } else if (state == QYEvaluationStateFailTimeout) {
                [weakSelf showToast:@"评价已超时，无法进行评价"];
            } else if (state == QYEvaluationStateFailUnknown) {
                [weakSelf showToast:@"评价失败"];
            } else if (state == QYEvaluationStateSuccessFirst
                       || state == QYEvaluationStateSuccessRevise) {
                [weakSelf closeViewController];
            }
        }];
    }
}

- (NSArray *)getSelectedTags {
    if (!_selectOption || !_selectedTagView) {
        return nil;
    }
    NSMutableArray *selectedTags = [NSMutableArray array];
    for (UIButton *tagButton in _selectedTagView.subviews) {
        if (tagButton.selected) {
            if (tagButton.titleLabel.text) {
                [selectedTags addObject:tagButton.titleLabel.text];
            }
        }
    }
    return selectedTags;
}

- (void)updateSubmitButtonEnable:(QYEvaluationSubmitType)type {
    if (type == QYEvaluationSubmitTypeEnable) {
        self.view.userInteractionEnabled = YES;
        _submitButton.enabled = YES;
        [_submitButton setTitle:@"提 交" forState:UIControlStateNormal];
        _submitButton.backgroundColor = QYBlueColor;
    } else if (type == QYEvaluationSubmitTypeUnable) {
        self.view.userInteractionEnabled = YES;
        _submitButton.enabled = NO;
        [_submitButton setTitle:@"提 交" forState:UIControlStateNormal];
        _submitButton.backgroundColor = [QYBlueColor colorWithAlphaComponent:0.6];
    } else if (type == QYEvaluationSubmitTypeSubmitting) {
        self.view.userInteractionEnabled = NO;
        _submitButton.enabled = NO;
        [_submitButton setTitle:@"提交中..." forState:UIControlStateNormal];
        _submitButton.backgroundColor = [QYBlueColor colorWithAlphaComponent:0.6];
    }
}

#pragma mark - close
- (void)onClose:(id)sender {
    if (_submitButton.enabled) {
        //解决iOS键盘消失动画被打断后闪一下问题
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *title = @"是否放弃当前评价";
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:title
                                                             message:@""
                                                            delegate:weakSelf
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:nil, nil];
            [dialog addButtonWithTitle:@"取消"];
            [dialog addButtonWithTitle:@"确定"];
            [dialog show];
        });
    } else {
        [self closeViewController];
    }
    [self.textView resignFirstResponder];   //否则close评价窗口键盘会抖动
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.textView becomeFirstResponder];
    } else if (buttonIndex == 1) {
        [self closeViewController];
    }
}

- (void)closeViewController {
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

#pragma mark - gesture
-(void)onSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
//    [_scrollView ysf_scrollToBottom:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        _placeholderLabel.hidden = YES;
    } else {
        _placeholderLabel.hidden = NO;
    }
    
    //解决自动上下移动问题
    CGRect line = [textView caretRectForPosition:textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height - (textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top);
    if (overflow > 0) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [textView setContentOffset:offset];
    }
    if (self.evaluationData.lastResult) {
        if (![_textView.text isEqualToString:self.evaluationData.lastResult.remarkString]) {
            [self updateSubmitButtonEnable:QYEvaluationSubmitTypeEnable];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if (range.location >= 100) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - QYEvaluationResolveViewDelegate
- (void)didSelectResolveButton:(QYEvaluationResolveStatus)status {
    
}

#pragma mark - other
- (void)showToast:(NSString *)toast {
    if (toast.length) {
        [self.contentView ysf_makeToast:toast duration:2 position:YSFToastPositionCenter];
    }
}

- (void)updateLastResult {
    if (self.evaluationData.lastResult) {
        for (UIButton *button in _satisButtons) {
            if (button.tag == self.evaluationData.lastResult.selectOption.option) {
                [self onSelect:button];
                break;
            }
        }
        
        for (NSString *selectTagString in self.evaluationData.lastResult.selectTags) {
            for (UIButton *tagButton in _selectedTagView.subviews) {
                if ([[tagButton titleForState:UIControlStateNormal] isEqualToString:selectTagString]) {
                    tagButton.selected = YES;
                    tagButton.backgroundColor = QYColorFromRGB(0x999999);
                }
            }
        }
        
        if (self.evaluationData.lastResult.remarkString.length) {
            _textView.text = self.evaluationData.lastResult.remarkString;
            _placeholderLabel.hidden = YES;
        }
        if (self.evaluationData.resolvedEnabled) {
            _resolveView.status = self.evaluationData.lastResult.resolveStatus;
        }
        [self updateSubmitButtonEnable:QYEvaluationSubmitTypeUnable];
    }
}

- (UIImage *)getButtonNormalImageForTagType:(QYEvaluationOption)option {
    if (option == QYEvaluationOptionVerySatisfied) {
        return [UIImage imageNamed:@"icon_evaluation_satisfied1"];
    } else if (option == QYEvaluationOptionSatisfied) {
        return [UIImage imageNamed:@"icon_evaluation_satisfied2"];
    } else if (option == QYEvaluationOptionOrdinary) {
        return [UIImage imageNamed:@"icon_evaluation_satisfied3"];
    } else if (option == QYEvaluationOptionDissatisfied) {
        return [UIImage imageNamed:@"icon_evaluation_satisfied4"];
    } else if (option == QYEvaluationOptionVeryDissatisfied) {
        return [UIImage imageNamed:@"icon_evaluation_satisfied5"];
    } else {
        return nil;
    }
}

- (UIImage *)getImageInBundle:(NSString *)imageName {
    NSString *name = [@"QYCustomResource.bundle" stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageNamed:name];
    if (!image) {
        name = [@"QYResource.bundle" stringByAppendingPathComponent:imageName];
        image = [UIImage imageNamed:name];
    }
    return image;
}


@end
