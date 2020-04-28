#import "YSFWebViewController.h"
#import "NSString+QY.h"
#import "QYMacro.h"
#import "UIView+YSF.h"
#import <WebKit/WebKit.h>

static NSInteger const kWebViewMaxErrorCount = 3;
static int const kWebViewAppStoreURLError = 102;
static int const kWebViewVideoURLError = 204;


@interface YSFWebViewController() <WKNavigationDelegate>

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIColor *progressColor;

@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIImage *errorImage;
@property (nonatomic, strong) UIImageView *errorImageView;

@property (nonatomic, assign) BOOL needOffset;
@property (nonatomic, assign) NSInteger currentErrorCount;

@end


@implementation YSFWebViewController
- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
}

- (instancetype)initWithUrl:(NSString *)urlString needOffset:(BOOL)needOffset errorImage:(UIImage *)errorImage {
    self = [super init];
    if (self) {
        _urlString = [urlString qy_trim];
        _needOffset = needOffset;
        _errorImage = errorImage;
        _currentErrorCount = 0;
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)urlString
                 needOffset:(BOOL)needOffset
                 errorImage:(UIImage *)errorImage
              progressColor:(UIColor *)progressColor {
    self = [super init];
    if (self) {
        _urlString = [urlString qy_trim];
        _needOffset = needOffset;
        _errorImage = errorImage;
        _progressColor = progressColor;
        _currentErrorCount = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //webView
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    self.webView = [[WKWebView alloc] initWithFrame:rect configuration:config];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    //progressView
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navigationBarBounds.size.height - progressBarHeight,
                                 navigationBarBounds.size.width,
                                 progressBarHeight);
    self.progressView = [[UIProgressView alloc] initWithFrame:barFrame];
    self.progressView.backgroundColor = YSFQYPlaceholderColor;
    self.progressView.tintColor = _progressColor ?: YSFQYBlueColor;
    [self.navigationController.navigationBar addSubview:self.progressView];
    //KVO
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    //load
    [self loadWebView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}

- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc] initWithFrame:self.view.frame];
        _tapView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tapView];
        //gesture
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapErrorView)];
        [_tapView addGestureRecognizer:gesture];
        //hide
        _tapView.hidden = YES;
    }
    return _tapView;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        CGFloat navHeight = self.needOffset ? YSFNavigationBarHeight : 0;
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, navHeight + 20, 0, 0)];
        _errorLabel.font = [UIFont systemFontOfSize:16.f];
        _errorLabel.textColor = YSFQYButtonTitleNormalColor;
        [self.view insertSubview:_errorLabel aboveSubview:self.tapView];
        //hide
        _errorLabel.hidden = YES;
    }
    return _errorLabel;
}

- (UIImageView *)errorImageView {
    if (!_errorImageView) {
        _errorImageView = [[UIImageView alloc] initWithImage:_errorImage];
        [self.view insertSubview:_errorImageView aboveSubview:self.tapView];
        //hide
        _errorImageView.hidden = YES;
    }
    return _errorImageView;
}

#pragma mark - load
- (void)loadWebView {
    self.title = @"正在加载...";
    NSURL *url = [NSURL URLWithString:[self.urlString qy_formattedURLString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.progressView.progress >= 1) {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.currentErrorCount = 0;
}

//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    [self handleError:error];
}

//跳转失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self handleError:error];
}

- (void)handleError:(NSError *)error {
    self.title = @"";
    //网页正常但被取消异步加载
    if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorCancelled) {
        return;
    }
    //kWebViewAppStoreURLError = 102: 网页包含AppStore链接
    //kWebViewVideoURLError = 204: 链接为视频（不支持插件）
    if ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == kWebViewVideoURLError) {
        return;
    }
    self.title = @"加载失败";
    
    if (_currentErrorCount == kWebViewMaxErrorCount
        || error.code == kCFURLErrorCannotFindHost
        || error.code == kWebViewAppStoreURLError) {
        self.currentErrorCount = 0;
        if (error.code == kCFURLErrorCannotFindHost || error.code == kWebViewAppStoreURLError) {
            self.tapView.hidden = YES;
            self.errorLabel.hidden = NO;
            self.errorImageView.hidden = YES;
            
            self.errorLabel.text = @"无法打开网页";
            [self.errorLabel sizeToFit];
            self.errorLabel.ysf_frameCenterX = self.tapView.ysf_frameCenterX;
        } else {
            self.tapView.hidden = NO;
            self.errorLabel.hidden = NO;
            self.errorImageView.hidden = NO;
            
            self.errorLabel.text = @"网络出错，轻触屏幕重新加载";
            [self.errorLabel sizeToFit];
            self.errorLabel.ysf_frameCenterX = self.tapView.ysf_frameCenterX;
            
            self.errorImageView.bounds = CGRectMake(0,
                                                    0,
                                                    self.errorImageView.image.size.width,
                                                    self.errorImageView.image.size.height);
            self.errorImageView.ysf_frameTop = self.errorLabel.ysf_frameTop + 2;
            self.errorImageView.ysf_frameRight = roundf(self.errorLabel.ysf_frameLeft - 10);
        }
    } else {
        self.currentErrorCount ++;
        //retry
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [weakSelf loadWebView];
        });
    }
}

- (void)tapErrorView {
    self.tapView.hidden = YES;
    self.errorLabel.hidden = YES;
    self.errorImageView.hidden = YES;
    
    self.currentErrorCount = 0;
    [self loadWebView];
}

@end
