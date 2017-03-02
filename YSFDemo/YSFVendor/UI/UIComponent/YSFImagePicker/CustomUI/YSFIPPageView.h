//
//  PageView.h
//  yixin_iphone
//  按页展示的UIView，只载入当前页和前后页，保证内存的低占用 (目前只支持横向)
//  Created by amao on 13-5-14.
//  Copyright (c) 2013年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSFIPPageView;

@protocol YSFPageViewDataSource <NSObject>
- (NSInteger)numberOfPages: (YSFIPPageView *)pageView;
- (UIView *)pageView: (YSFIPPageView *)pageView viewInPage: (NSInteger)index;
@end

@protocol YSFPageViewDelegate <NSObject>
@optional
- (void)pageViewScrollEnd: (YSFIPPageView *)pageView
             currentIndex: (NSInteger)index
               totolPages: (NSInteger)pages;

- (void)pageViewDidScroll: (YSFIPPageView *)pageView;
- (BOOL)needScrollAnimation;

- (void)pageView:(YSFIPPageView *)pageView didEndDisplayingAtIndex:(NSInteger)index;

@end


@interface YSFIPPageView : UIView<UIScrollViewDelegate>
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
