//
//  UIView+NIM.m
//  YSFKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "UIView+YSF.h"

@implementation UIView (YSF)

- (CGFloat)ysf_frameLeft {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setYsf_frameLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ysf_frameTop {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setYsf_frameTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ysf_frameRight {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setYsf_frameRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ysf_frameBottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setYsf_frameBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ysf_frameCenterX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setYsf_frameCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ysf_frameCenterY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setYsf_frameCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ysf_frameWidth {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setYsf_frameWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ysf_frameHeight {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setYsf_frameHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)ysf_frameOrigin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setYsf_frameOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)ysf_frameSize {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setYsf_frameSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (UIViewController *)ysf_viewController{
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)ysf_removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        if ([child isKindOfClass:[UIImageView class]]) {
            ((UIImageView*)child).image = nil;
        }
        [child removeFromSuperview];
        child = nil;
    }
}

- (void)ysf_hideShadow {
    self.layer.shadowColor = [UIColor clearColor].CGColor;
}

- (void)ysf_shadowColor:(UIColor*)color shadowOffset:(CGSize)offset shadowRadius:(CGFloat)radius shadowOpacity:(CGFloat)opacity {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
}

- (void)ysf_cornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color {
    CALayer *layer = [self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:radius];
    [layer setBorderWidth:width];
    [layer setBorderColor:color.CGColor];
}

- (void)ysf_shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)offset shadowRadius:(CGFloat)sradius shadowOpacity:(CGFloat)opacity
       cornerRadius:(CGFloat)cradius borderWidth:(CGFloat)width borderColor:(UIColor *)borderColor {
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = sradius;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
    self.layer.cornerRadius = cradius;
    self.layer.borderWidth = width;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.masksToBounds = YES;
}

- (void)ysf_shake {
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:0.5f];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      nil];
    [keyAn setValues:array];
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [keyAn setKeyTimes:times];
    [self.layer addAnimation:keyAn forKey:@"TextAnim"];
}

-(void)ysf_configureBorder:(CGFloat)borderWidth shadowDepth:(CGFloat)shadowDepth controlPointXOffset:(CGFloat)controlPointXOffset controlPointYOffset:(CGFloat)controlPointYOffset
{
    [self.layer setBorderWidth:borderWidth];
    [self setContentMode:UIViewContentModeCenter];
    [self.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
    [self.layer setShadowRadius:2.0];
    [self.layer setShadowOpacity:0.3];
    
    UIBezierPath* path = [self ysf_curlShadowPathWithShadowDepth:shadowDepth
                                         controlPointXOffset:controlPointXOffset
                                         controlPointYOffset:controlPointYOffset
                                                     forView:self];
    [self.layer setShadowPath:path.CGPath];
}

-(UIBezierPath*)ysf_curlShadowPathWithShadowDepth:(CGFloat)shadowDepth controlPointXOffset:(CGFloat)controlPointXOffset controlPointYOffset:(CGFloat)controlPointYOffset forView:(UIView*)view
{
    
    CGSize viewSize = [view bounds].size;
    CGPoint polyTopLeft = CGPointMake(0.0, controlPointYOffset);
    CGPoint polyTopRight = CGPointMake(viewSize.width, controlPointYOffset);
    CGPoint polyBottomLeft = CGPointMake(0.0, viewSize.height -3);
    CGPoint polyBottomRight = CGPointMake(viewSize.width, viewSize.height - 3);
    
    CGPoint controlPointLeftUp = CGPointMake(controlPointXOffset , viewSize.height - 3);
    CGPoint controlPointRightUp = CGPointMake(viewSize.width - controlPointXOffset,  viewSize.height - 3);
    
    CGPoint controlPointLeftDown = CGPointMake(controlPointXOffset , viewSize.height + shadowDepth);
    CGPoint controlPointRightDown = CGPointMake(viewSize.width - controlPointXOffset,  viewSize.height + shadowDepth);
    
    CGPoint controlPointCenterLeft = CGPointMake(viewSize.width/3, viewSize.height - 3);
    CGPoint controlPointCenterRight = CGPointMake(2*viewSize.width/3, viewSize.height - 3);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    [path moveToPoint:controlPointLeftUp];
    [path addLineToPoint:polyBottomLeft];
    [path addLineToPoint:polyTopLeft];
    [path addLineToPoint:polyTopRight];
    [path addLineToPoint:polyBottomRight];
    [path addLineToPoint:controlPointRightUp];
    [path addLineToPoint:controlPointRightDown];
    [path addCurveToPoint:controlPointLeftDown
            controlPoint1:controlPointCenterRight
            controlPoint2:controlPointCenterLeft];
    
    [path closePath];
    return path;
}

-(UIImage*)ysf_viewToImage{
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return viewImage;
}



@end
