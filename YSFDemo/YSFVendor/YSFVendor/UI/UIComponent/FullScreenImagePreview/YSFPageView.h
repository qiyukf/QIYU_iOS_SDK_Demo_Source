//
//  NIMPageView.h
//  YSFKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSFPageView;

@protocol YSFPageViewDataSource <NSObject>
- (NSInteger)numberOfPages: (YSFPageView *)pageView;
- (UIView *)pageView: (YSFPageView *)pageView viewInPage: (NSInteger)index;
@end

@protocol YSFPageViewDelegate <NSObject>
@optional
- (void)pageViewScrollEnd: (YSFPageView *)pageView
             currentIndex: (NSInteger)index
               totolPages: (NSInteger)pages;

- (void)pageViewDidScroll: (YSFPageView *)pageView;
- (BOOL)needScrollAnimation;
@end


@interface YSFPageView : UIView<UIScrollViewDelegate>
@property (nonatomic,strong)    UIScrollView   *scrollView;
@property (nonatomic,weak)    id<YSFPageViewDataSource>  dataSource;
@property (nonatomic,weak)    id<YSFPageViewDelegate>    pageViewDelegate;
- (void)scrollToPage: (NSInteger)pages;
- (void)reloadData;
- (UIView *)viewAtIndex: (NSInteger)index;
- (NSInteger)currentPage;


//旋转相关方法,这两个方法必须配对调用,否则会有问题
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration;
@end
