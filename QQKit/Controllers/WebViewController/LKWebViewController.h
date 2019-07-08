//
//  LSYWebViewController.h
//  TTClub
//
//  Progress from NJKWebViewProgress https://github.com/ninjinkun/NJKWebViewProgress
//  Created by RoyLei on 15/6/9.
//  Copyright (c) 2015年 TTClub. All rights reserved.
//

#import "LKBaseViewController.h"

@interface LKWebViewController : LKBaseViewController

@property (nonatomic, weak) id<UIWebViewDelegate>webViewProxyDelegate;

@property (nonatomic, copy,   readonly) NSString *url;
@property (nonatomic, strong, readonly) UIButton *reloadButton;
@property (nonatomic, strong, readonly) UIView   *bottomView;   //底部前进、后退按钮容器，默认隐藏

@property (nonatomic, assign) BOOL  isForbidScale;//default is YES

@property (nonatomic, copy) NSString *webTitle;
@property (nonatomic, copy) void (^WebViewControllerPopBlock)();

- (instancetype)initWithURL:(NSString*)urlStr webTitle:(NSString *)title;

- (instancetype)initWithURL:(NSString*)urlStr;

- (void)setProgress:(CGFloat)progress;

/**
 *  设置请求实体,默认实现只使用初始化时候的urlStr生成一个默认的url,如果需要自定义请求,需要建立自己的子类去重写该方法,生成自定义的NSURLRequest
 *
 *  @return 请求实体
 */
- (NSMutableURLRequest *)setupUrlRequest;

/**
 *  以下方法是webView时间回调处理,默认实现是控制菊花的显示和隐藏,如果需要自定义处理,需要建立自己的子类去重写以下方法
 */
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
- (void)webViewloadingStatus:(BOOL)loading;



@end
