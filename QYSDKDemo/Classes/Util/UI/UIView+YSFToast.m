//
//  UIView+Toast.m
//  Toast
//
//  Copyright 2014 Charles Scalesse.
//


#import "UIView+YSFToast.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat YSFToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat YSFToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat YSFToastHorizontalPadding   = 10.0;
static const CGFloat YSFToastVerticalPadding     = 10.0;
static const CGFloat YSFToastCornerRadius        = 6.0;
static const CGFloat YSFToastOpacity             = 0.7;
static const CGFloat YSFToastFontSize            = 16.0;
static const CGFloat YSFToastMaxTitleLines       = 0;
static const CGFloat YSFToastMaxMessageLines     = 0;
static const NSTimeInterval YSFToastFadeDuration = 0.2;

// shadow appearance
static const CGFloat YSFToastShadowOpacity       = 0.7;
static const CGFloat YSFToastShadowRadius        = 4.0;
static const CGSize  YSFToastShadowOffset        = { 2.0, 2.0 };
static const BOOL    YSFToastDisplayShadow       = YES;

// display duration
static const NSTimeInterval YSFToastDefaultDuration  = 3.0;

// image view size
static const CGFloat YSFToastImageViewWidth      = 80.0;
static const CGFloat YSFToastImageViewHeight     = 80.0;

// activity
static const CGFloat YSFToastActivityWidth       = 100.0;
static const CGFloat YSFToastActivityHeight      = 100.0;
static const NSString * YSFToastActivityDefaultPosition = @"center";

// interaction
static const BOOL YSFToastHidesOnTap             = YES;     // excludes activity views

// associative reference keys
static const NSString * YSFToastTimerKey         = @"YSFToastTimerKey";
static const NSString * YSFToastViewKey  = @"YSFToastViewKey";
static const NSString * YSFToastActivityViewKey  = @"YSFToastActivityViewKey";
static const NSString * YSFToastTapCallbackKey   = @"YSFToastTapCallbackKey";

// positions
NSString * const YSFToastPositionTop             = @"top";
NSString * const YSFToastPositionCenter          = @"center";
NSString * const YSFToastPositionBottom          = @"bottom";

@interface UIView (YSFToastPrivate)

- (void)ysf_hideToast:(UIView *)toast;
- (void)ysf_toastTimerDidFinish:(NSTimer *)timer;
- (void)ysf_handleToastTapped:(UITapGestureRecognizer *)recognizer;
- (CGPoint)ysf_centerPointForPosition:(id)position withToast:(UIView *)toast;
- (UIView *)ysf_viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image;
- (CGSize)ysf_sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end


@implementation UIView (YSFToast)

#pragma mark - Toast Methods

- (void)ysf_makeToast:(NSString *)message {
    [self ysf_makeToast:message duration:YSFToastDefaultDuration position:nil];
}

- (void)ysf_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position {
    UIView *toast = [self ysf_viewForMessage:message title:nil image:nil];
    [self ysf_showToast:toast duration:duration position:position];  
}

- (void)ysf_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position title:(NSString *)title {
    UIView *toast = [self ysf_viewForMessage:message title:title image:nil];
    [self ysf_showToast:toast duration:duration position:position];  
}

- (void)ysf_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position image:(UIImage *)image {
    UIView *toast = [self ysf_viewForMessage:message title:nil image:image];
    [self ysf_showToast:toast duration:duration position:position];  
}

- (void)ysf_makeToast:(NSString *)message duration:(NSTimeInterval)duration  position:(id)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self ysf_viewForMessage:message title:title image:image];
    [self ysf_showToast:toast duration:duration position:position];  
}

- (void)ysf_showToast:(UIView *)toast {
    [self ysf_showToast:toast duration:YSFToastDefaultDuration position:nil];
}


- (void)ysf_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position {
    [self ysf_showToast:toast duration:duration position:position tapCallback:nil];
    
}


- (void)ysf_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position
      tapCallback:(void(^)(void))tapCallback
{
    toast.center = [self ysf_centerPointForPosition:position withToast:toast];
    toast.alpha = 0.0;
    
    if (YSFToastHidesOnTap) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(ysf_handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    
    [self addSubview:toast];
    
    [UIView animateWithDuration:YSFToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(ysf_toastTimerDidFinish:) userInfo:toast repeats:NO];
                         // associate the timer with the toast view
                         objc_setAssociatedObject (toast, &YSFToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         objc_setAssociatedObject (toast, &YSFToastTapCallbackKey, tapCallback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}


- (void)ysf_hideToast:(UIView *)toast {
    [UIView animateWithDuration:YSFToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         toast.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [toast removeFromSuperview];
                     }];
}

#pragma mark - Events

- (void)ysf_toastTimerDidFinish:(NSTimer *)timer {
    [self ysf_hideToast:(UIView *)timer.userInfo];
}

- (void)ysf_handleToastTapped:(UITapGestureRecognizer *)recognizer {
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(self, &YSFToastTimerKey);
    [timer invalidate];
    
    void (^callback)(void) = objc_getAssociatedObject(self, &YSFToastTapCallbackKey);
    if (callback) {
        callback();
    }
    [self ysf_hideToast:recognizer.view];
}

#pragma mark - Toast Activity Methods

- (void)ysf_makeToastActivity {
    [self ysf_makeToastActivity:YSFToastActivityDefaultPosition];
}

- (void)ysf_makeToastActivity:(id)position {
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &YSFToastActivityViewKey);
    if (existingActivityView != nil) return;
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YSFToastActivityWidth, YSFToastActivityHeight)];
    activityView.center = [self ysf_centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:YSFToastOpacity];
    activityView.alpha = 0.0;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = YSFToastCornerRadius;
    
    if (YSFToastDisplayShadow) {
        activityView.layer.shadowColor = [UIColor blackColor].CGColor;
        activityView.layer.shadowOpacity = YSFToastShadowOpacity;
        activityView.layer.shadowRadius = YSFToastShadowRadius;
        activityView.layer.shadowOffset = YSFToastShadowOffset;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate the activity view with self
    objc_setAssociatedObject (self, &YSFToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:YSFToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

- (void)ysf_hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &YSFToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:YSFToastFadeDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &YSFToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

#pragma mark - load toast
- (void)ysf_makeActivityToast:(NSString *)toast shadow:(BOOL)shadow {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &YSFToastActivityViewKey);
    if (existingActivityView != nil) {
        [self ysf_hideToastActivity];
    }
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YSFToastActivityWidth, YSFToastActivityHeight)];
    contentView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:YSFToastOpacity];
    contentView.alpha = 0.0;
    contentView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    contentView.layer.cornerRadius = YSFToastCornerRadius;
    if (shadow) {
        contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        contentView.layer.shadowOpacity = YSFToastShadowOpacity;
        contentView.layer.shadowRadius = YSFToastShadowRadius;
        contentView.layer.shadowOffset = YSFToastShadowOffset;
    }
    
    CGFloat labelHeight = toast.length ? 15 : 0;
    CGFloat space = toast.length ? 10 : 0;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGFloat top = (CGRectGetHeight(contentView.frame) - CGRectGetHeight(indicator.bounds) - labelHeight - space) / 2;
    indicator.center = CGPointMake(contentView.bounds.size.width / 2, top + CGRectGetHeight(indicator.bounds) / 2);
    [contentView addSubview:indicator];
    [indicator startAnimating];
    
    if (toast.length) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(indicator.frame) + space,
                                                                   CGRectGetWidth(contentView.frame),
                                                                   labelHeight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14.0f];
        label.textColor = [UIColor whiteColor];
        label.text = toast;
        [contentView addSubview:label];
    }
    
    // associate the activity view with self
    objc_setAssociatedObject(self, &YSFToastActivityViewKey, contentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addSubview:contentView];
    
    [UIView animateWithDuration:YSFToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         contentView.alpha = 1.0;
                     } completion:nil];
}

- (void)ysf_makeToast:(NSString *)toast image:(UIImage *)image shadow:(BOOL)shadow duration:(NSTimeInterval)duration {
    UIView *existingView = (UIView *)objc_getAssociatedObject(self, &YSFToastViewKey);
    if (existingView) {
        [self ysf_hideToastView];
    }
    NSDictionary *dict = @{ NSFontAttributeName : [UIFont systemFontOfSize:14.0] };
    CGFloat textWidth = [toast boundingRectWithSize:CGSizeMake(MAXFLOAT, 20)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:dict
                                            context:nil].size.width;
    textWidth = ceilf(textWidth + 20);
    textWidth = MAX(textWidth, YSFToastActivityWidth);
    textWidth = MIN(textWidth, 2 * YSFToastActivityWidth);
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textWidth, YSFToastActivityHeight)];
    contentView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:YSFToastOpacity];
    contentView.alpha = 0.0;
    contentView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    contentView.layer.cornerRadius = YSFToastCornerRadius;
    if (shadow) {
        contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        contentView.layer.shadowOpacity = YSFToastShadowOpacity;
        contentView.layer.shadowRadius = YSFToastShadowRadius;
        contentView.layer.shadowOffset = YSFToastShadowOffset;
    }
    
    CGFloat labelHeight = toast.length ? 15 : 0;
    CGFloat space = toast.length ? 10 : 0;
    CGSize size = CGSizeZero;
    CGFloat label_Y = (CGRectGetHeight(contentView.frame) - labelHeight) / 2;
    
    if (image) {
        size = image.size;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(roundf((CGRectGetWidth(contentView.frame) - size.width) / 2),
                                     roundf((CGRectGetHeight(contentView.frame) - labelHeight - space - size.height) / 2),
                                     size.width,
                                     size.height);
        [contentView addSubview:imageView];
        label_Y = CGRectGetMaxY(imageView.frame) + space;
    }
    
    if (toast.length) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, roundf(label_Y), CGRectGetWidth(contentView.frame), labelHeight)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14.0f];
        label.textColor = [UIColor whiteColor];
        label.text = toast;
        [contentView addSubview:label];
    }
    
    // associate the activity view with self
    objc_setAssociatedObject(self, &YSFToastViewKey, contentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addSubview:contentView];
    
    [UIView animateWithDuration:YSFToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         contentView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(ysf_toastTimerDidFinish:) userInfo:contentView repeats:NO];
                         objc_setAssociatedObject (toast, &YSFToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}

- (void)ysf_hideToastView {
    UIView *existingView = (UIView *)objc_getAssociatedObject(self, &YSFToastViewKey);
    if (existingView != nil) {
        [UIView animateWithDuration:YSFToastFadeDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingView removeFromSuperview];
                             objc_setAssociatedObject (self, &YSFToastViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

#pragma mark - Helpers
- (CGPoint)ysf_centerPointForPosition:(id)point withToast:(UIView *)toast {
    if([point isKindOfClass:[NSString class]]) {
        if([point caseInsensitiveCompare:YSFToastPositionTop] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + YSFToastVerticalPadding);
        } else if([point caseInsensitiveCompare:YSFToastPositionCenter] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.4);
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    // default to bottom
    return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - YSFToastVerticalPadding);
}

- (CGSize)ysf_sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
}

- (UIView *)ysf_viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    // sanity
    if((message == nil) && (title == nil) && (image == nil)) return nil;

    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = YSFToastCornerRadius;
    
    if (YSFToastDisplayShadow) {
        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
        wrapperView.layer.shadowOpacity = YSFToastShadowOpacity;
        wrapperView.layer.shadowRadius = YSFToastShadowRadius;
        wrapperView.layer.shadowOffset = YSFToastShadowOffset;
    }

    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:YSFToastOpacity];
    
    if(image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(YSFToastHorizontalPadding, YSFToastVerticalPadding, YSFToastImageViewWidth, YSFToastImageViewHeight);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = YSFToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    if (title != nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = YSFToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:YSFToastFontSize];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width * YSFToastMaxWidth) - imageWidth, self.bounds.size.height * YSFToastMaxHeight);
        CGSize expectedSizeTitle = [self ysf_sizeForString:title font:titleLabel.font constrainedToSize:maxSizeTitle lineBreakMode:titleLabel.lineBreakMode];
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = YSFToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:YSFToastFontSize];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * YSFToastMaxWidth) - imageWidth, self.bounds.size.height * YSFToastMaxHeight);
        CGSize expectedSizeMessage = [self ysf_sizeForString:message font:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if(titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = YSFToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + YSFToastHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;

    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + YSFToastHorizontalPadding;
        messageTop = titleTop + titleHeight + YSFToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }

    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (YSFToastHorizontalPadding * 2)), (longerLeft + longerWidth + YSFToastHorizontalPadding));    
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + YSFToastVerticalPadding), (imageHeight + (YSFToastVerticalPadding * 2)));
                         
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
        
    return wrapperView;
}

@end
