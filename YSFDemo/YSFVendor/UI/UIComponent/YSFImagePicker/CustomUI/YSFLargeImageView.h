#import <UIKit/UIKit.h>
@class YSFLargeImageView;

#define kYSFLargeImageGapWidth 16.0f

@protocol YSFLargeImageViewDelegate <NSObject>
- (void)onTouch:(YSFLargeImageView *)cell;
@optional
- (void)onDoubleTap:(YSFLargeImageView *)cell;
- (void)onLargeImageViewLongPressed:(YSFLargeImageView *)cell;
@end

@interface YSFLargeImageView : UIView <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIScrollView *imageScrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) BOOL easyClose; //下滑退出 默认NO
@property (weak, nonatomic) id<YSFLargeImageViewDelegate> delegate;
@property (assign, nonatomic) NSInteger gapWidth; // 图片预览时的间隔
@property (assign, nonatomic) BOOL      enableDoubleTap;//允许双击，默认为YES

/**
 *  图片为nil的时候显示loading
 */
@property (assign, nonatomic) BOOL showNoImageLoading;

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;

@end
