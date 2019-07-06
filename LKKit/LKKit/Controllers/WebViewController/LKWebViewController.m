//
//  LSYWebViewController.m
//  TTClub
//
//  Progress from NJKWebViewProgress https://github.com/ninjinkun/NJKWebViewProgress
//  Created by RoyLei on 15/6/9.
//  Copyright (c) 2015年 TTClub. All rights reserved.
//

#import "LKWebViewController.h"
#import <Masonry.h>
#import "LKMacros.h"
#import "LSYConstance.h"
#import <YYKit/UIView+YYAdd.h>
#import "LKAppearance.h"

NSString *completeRPCURLPath = @"/webviewCtrlprogressproxy/complete";

//const static NSInteger WebViewControllerFootBarHeight = 50;

const float WebViewCtrlInitialProgressValue           = 0.1f;
const float WebViewCtrlInteractiveProgressValue       = 0.5f;
const float WebViewCtrlFinalProgressValue             = 0.9f;

@interface LKWebViewController()<UIWebViewDelegate, UIScrollViewDelegate>
{
    UIWebView                   *_webView;
    NSString                    *_webTitle;
    UIButton                    *_goBackButton;
    UIButton                    *_goForwardButton;
    UIButton                    *_reloadButton;
    UIButton                    *_stopLoadingButton;
    UIBarButtonItem             *_reloadBarButton;
    UIBarButtonItem             *_stopBarButton;
    
    NSUInteger                  _loadingCount;
    NSUInteger                  _maxLoadCount;
    NSURL                       *_currentURL;
    BOOL                        _interactive;
    
    UIView                      *_progressBarView;
}

@property (nonatomic, copy,   readwrite) NSString *url;
@property (nonatomic, assign, readwrite) CGFloat progress;
@property (nonatomic, strong, readwrite) UIView  *bottomView;

@end

@implementation LKWebViewController

- (instancetype)initWithURL:(NSString*)urlStr webTitle:(NSString *)title
{
    self = [super init];
    if(self){
        urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        _url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _webTitle = title;
        _isForbidScale = YES;
    }
    return self;
}

- (instancetype)initWithURL:(NSString*)urlStr
{
    self = [super init];
    if(self){
        urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        _url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _isForbidScale = YES;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"LVWebViewController dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    [self setTitle:_webTitle];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode =  UINavigationItemLargeTitleDisplayModeNever;
    }
    [self.webView.scrollView setContentInset:UIEdgeInsetsMake(LSYNavBarHeight, 0, 0, 0)];
    [self.webView.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(LSYNavBarHeight, 0, 0, 0)];
    
    [self.view addSubview:self.webView];
    [self.webView addSubview:self.progressBarView];
    
    self.webView.backgroundColor = [UIColor blackColor];
    
    WS(weakSelf)
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view);
    }];
    
    [self loadWebPage];
}

- (void)setWebTitle:(NSString *)webTitle
{
    if (_webTitle != webTitle) {
        _webTitle = [webTitle copy];
        [self.navigationItem setTitle:webTitle];
    }
}

- (void)setIsForbidScale:(BOOL)isForbidScale
{
    _isForbidScale = isForbidScale;
    if (_isForbidScale) {
        [_webView.scrollView setMinimumZoomScale:1.0f];
        [_webView.scrollView setMaximumZoomScale:1.0f];
    }
}

#pragma mark - NavigationBarItem Action

-(void)didPressedBackButton:(UIButton *)rightBtn
{
    if (self.WebViewControllerPopBlock) {
        self.WebViewControllerPopBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 构建子View方法

- (UIView *)progressBarView
{
    if (!_progressBarView) {
        _progressBarView = [[UIView alloc] initWithFrame:CGRectMake(0, LSYNavBarHeight, 0, 2)];
        [_progressBarView setBackgroundColor:[LKAppearance sharedInstance].mainColor];
    }
    
    return _progressBarView;
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        [_webView.scrollView setDelegate:self];
        [_webView setDelegate:self];
        [_webView setScalesPageToFit:YES];
        [_webView.scrollView setMinimumZoomScale:1.0f];
        [_webView.scrollView setMaximumZoomScale:1.0f];
        _webView.backgroundColor = [UIColor blackColor];
        [_webView setOpaque:NO];
        
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return _webView;
}

//底部工具栏
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    
    return _bottomView;
}

- (UIBarButtonItem *)stopBarButton
{
    if (!_stopBarButton) {
        _stopBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.stopLoadingButton];
    }
    
    return _stopBarButton;
}

- (UIBarButtonItem *)reloadBarButton
{
    if (!_reloadBarButton) {
        _reloadBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.reloadButton];
    }
    
    return _reloadBarButton;
}

- (UIButton *)goBackButton
{
    if (!_goBackButton) {
        _goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goBackButton setImage:[UIImage imageNamed:@"icon_bottomWeb_back_normal"] forState:UIControlStateNormal];
        [_goBackButton setImage:[UIImage imageNamed:@"icon_bottomWeb_back_highlight"] forState:UIControlStateHighlighted];
    }
    return _goBackButton;
}

- (UIButton *)goForwardButton
{
    if (!_goForwardButton) {
        _goForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goForwardButton setImage:[UIImage imageNamed:@"icon_bottomWeb_go_normal"] forState:UIControlStateNormal];
        [_goForwardButton setImage:[UIImage imageNamed:@"icon_bottomWeb_go_highlight"] forState:UIControlStateHighlighted];
    }
    
    return _goForwardButton;
}

- (UIButton *)reloadButton
{
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reloadButton setSize:(CGSize){50,44}];
        [_reloadButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [_reloadButton setImage:[UIImage imageNamed:@"icon_bottomWeb_refresh_normal"] forState:UIControlStateNormal];
        [_reloadButton setImage:[UIImage imageNamed:@"icon_bottomWeb_refresh_highlight"] forState:UIControlStateHighlighted];
        [_reloadButton setImageEdgeInsets:(UIEdgeInsetsMake(0, 20, 0, -20))];
    }
    
    return _reloadButton;
}

- (UIButton *)stopLoadingButton
{
    if (!_stopLoadingButton) {
        _stopLoadingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopLoadingButton setSize:(CGSize){50,44}];
        [_stopLoadingButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [_stopLoadingButton setImage:[UIImage imageNamed:@"icon_bottomWeb_stop_normal"] forState:UIControlStateNormal];
        [_stopLoadingButton setImage:[UIImage imageNamed:@"icon_bottomWeb_stop_highlight"] forState:UIControlStateHighlighted];
        [_stopLoadingButton setImageEdgeInsets:(UIEdgeInsetsMake(0, 20, 0, -20))];
        
    }
    
    return _stopLoadingButton;
}

#pragma mark - Start load web page

- (void)loadWebPage
{
    NSMutableURLRequest *request = [self setupUrlRequest];
    [_webView loadRequest:request];
}

-(NSMutableURLRequest *)setupUrlRequest
{
    NSURL *url = [NSURL URLWithString:_url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    return request;
}

#pragma mark - Button Action

- (void)backButtonOverrideAction:(id)sender
{
    if (self.webView.canGoBack) {
        [_webView goBack];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)buttonPress:(UIButton *)sender
{
    if ([sender isEqual:_goBackButton])
    {
        [_webView goBack];
    }
    else if ([sender isEqual:_goForwardButton])
    {
        [_webView goForward];
    }
    else if ([sender isEqual:_reloadButton])
    {
        [self reset];
        [_webView reload];
        
    }
    else if ([sender isEqual:_stopLoadingButton])
    {
        [_webView stopLoading];
    }
}

- (void)toggleState
{
    _goBackButton.enabled = _webView.canGoBack;
    _goForwardButton.enabled = _webView.canGoForward;
}

- (void)webViewloadingStatus:(BOOL)loading
{
    [self toggleState];
}

#pragma mark - Handle Progress

- (void)reset
{
    _maxLoadCount = _loadingCount = 0;
    _interactive = NO;
    [self setProgress:0.0];
}

- (void)startProgress
{
    if (_progress < WebViewCtrlInitialProgressValue)
    {
        [self setProgress:WebViewCtrlInitialProgressValue];
    }
}

- (void)incrementProgress
{
    float progress = self.progress;
    float maxProgress = _interactive ? WebViewCtrlFinalProgressValue : WebViewCtrlInteractiveProgressValue;
    float remainPercent = (float)_loadingCount / (float)_maxLoadCount;
    float increment = (maxProgress - progress) * remainPercent;
    progress += increment;
    progress = fmin(progress, maxProgress);
    [self setProgress:progress];
}

- (void)completeProgress
{
    [self setProgress:1.0];
}

- (void)setProgress:(CGFloat)progress
{
    // progress should be incremental only
    if (progress > _progress || progress == 0) {
        _progress = progress;
        [self setProgress:progress animated:YES];
    }
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    BOOL isGrowing = progress > 0.0;
    [UIView animateWithDuration:(isGrowing && animated) ? 0.27 : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = _progressBarView.frame;
        frame.size.width = progress * self.view.width;
        _progressBarView.frame = frame;
    } completion:nil];
    
    if (progress >= 1.0) {
        [UIView animateWithDuration:animated ? 0.27 : 0.0 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = _progressBarView.frame;
            frame.size.width = 0;
            _progressBarView.frame = frame;
        }];
    }
    else {
        [UIView animateWithDuration:animated ? 0.27 : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 1.0;
        } completion:nil];
    }
}

- (NSString *)noScaleJSString
{
    return @"function setScale(){\
    var all_metas=document.getElementsByTagName('meta');\
    if (all_metas){\
    var k;\
    for (k=0; k<all_metas.length;k++){\
    var meta_tag=all_metas[k];\
    var viewport= meta_tag.getAttribute('name');\
    if (viewport&& viewport=='viewport'){\
    meta_tag.setAttribute('content',\"width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\");\
    }\
    }\
    }\
    }";
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.path isEqualToString:completeRPCURLPath]) {
        [self completeProgress];
        return NO;
    }
    
    BOOL ret = YES;
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        ret = [_webViewProxyDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    
    BOOL isHTTPOrLocalFile = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"] || [request.URL.scheme isEqualToString:@"file"];
    if (ret && !isFragmentJump && isHTTPOrLocalFile && isTopLevelNavigation) {
        _currentURL = request.URL;
        [self reset];
    }
    return ret;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_webViewProxyDelegate webViewDidStartLoad:webView];
    }
    
    _loadingCount++;
    _maxLoadCount = fmax(_maxLoadCount, _loadingCount);
    
    [self webViewloadingStatus:YES];
    
    [self startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    if (!_webTitle) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    [self webViewloadingStatus:NO];
    
    //禁止webView放缩
    if (self.isForbidScale) {
        [webView stringByEvaluatingJavaScriptFromString:[self noScaleJSString]];
    }
    
    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_webViewProxyDelegate webViewDidFinishLoad:webView];
    }
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", webView.request.mainDocumentURL.scheme, webView.request.mainDocumentURL.host, completeRPCURLPath];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewloadingStatus:NO];
    
    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_webViewProxyDelegate webView:webView didFailLoadWithError:error];
    }
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@://%@%@'; document.body.appendChild(iframe);  }, false);", webView.request.mainDocumentURL.scheme, webView.request.mainDocumentURL.host, completeRPCURLPath];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if ((complete && isNotRedirect) || error) {
        [self completeProgress];
    }
}

#pragma mark -
#pragma mark Method Forwarding
// for future UIWebViewDelegate impl

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ( [super respondsToSelector:aSelector] )
        return YES;
    
    if ([self.webViewProxyDelegate respondsToSelector:aSelector])
        return YES;
    
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if(!signature) {
        if([_webViewProxyDelegate respondsToSelector:selector]) {
            return [(NSObject *)_webViewProxyDelegate methodSignatureForSelector:selector];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation*)invocation
{
    if ([_webViewProxyDelegate respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_webViewProxyDelegate];
    }
}

@end



