//
//  WebViewController.m
//  FWZXinsurance
//
//  Created by ding on 2017/11/29.
//  Copyright © 2017年 丁晓雷. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic,strong) UIView *progressView;
@property (nonatomic,weak) WKWebView *webView;
- (void)loadWebViewWith:(NSString *)urlString;
- (void)reloadWebView;
/**监听webview是否可返回，做webview的返回操作**/
@property (nonatomic,assign) BOOL enableWebBack;

/**可以调整webview的frame**/
@property (nonatomic,assign) CGRect webViewFrame;
@property (nonatomic,strong) CADisplayLink *displayLink;
//@property (nonatomic,copy)NSString *urlString;

@end

@implementation WebViewController
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColor_backgroundView;
   
    //创建UI界面
    [self createUI];
    [self loadWebViewWith:self.urlString];
    self.webView.frame = CGRectMake(0, 0, kWidth, kHeight);
    UIButton *backBtn = [Maker makeBtn:CGRectMake(10, 0, 70, 70) title:@"" img:@"back" font:kFont_Lable_15 target:self action:@selector(btnClicked:)];
    [self.view addSubview:backBtn];
}
- (void)btnClicked:(UIButton *)btn
{
    [ProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [ProgressHUD dismiss];
}
- (void)reloadWebView
{
    [self.webView reload];
}
- (void)loadWebViewWith:(NSString *)urlString
{
    self.urlString = urlString;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *mutableRequest = request.mutableCopy;
    //    if (Ktoken) {
    //        [mutableRequest addValue:Ktoken forHTTPHeaderField:@"token"];
    //    }
    [self.webView loadRequest:mutableRequest];
}
- (UIView *)progressView
{
    if (!_progressView) {
        _progressView =[[UIView alloc] initWithFrame:CGRectZero];
        //进度条的y值根据导航条是否透明会有变化
        _progressView.y = 0
        ;
        _progressView.height = 3.0;
        _progressView.backgroundColor = kColor_Blue;
    }
    return _progressView;
}
- (void)progressValueMonitor
{
    [self.view addSubview:self.progressView];
    self.progressView.width = kWidth * self.webView.estimatedProgress;
}
- (void)createUI
{
    WKWebView *webView = [[WKWebView alloc] init];
    webView.frame = self.webViewFrame.size.width == 0 ? self.view.bounds : self.webViewFrame;
    webView.backgroundColor = kColor_backgroundView;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
}
- (void)setWebViewFrame:(CGRect)webViewFrame
{
    _webViewFrame = webViewFrame;
    self.webView.frame = webViewFrame;
    self.progressView.y = webViewFrame.origin.y + 0;
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [ProgressHUD show:@"拼命加载中"];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(progressValueMonitor)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ProgressHUD dismiss];
    [self.displayLink invalidate];
    [UIView animateWithDuration:0.2 animations:^{
        self.progressView.width = kWidth;
    } completion:^(BOOL finished) {
        [self.progressView removeFromSuperview];
    }];
    self.backStatus(@"加载成功");
    
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url=[NSString stringWithFormat:@"%@",request.URL];
    
    if([url isEqualToString:self.urlString]) {
        return NO;
    }
    return NO;
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.progressView.width = kWidth;
    } completion:^(BOOL finished) {
        [self.progressView removeFromSuperview];
    }];
    [self.displayLink invalidate];
    if([error code] == NSURLErrorCancelled) return;
    [ProgressHUD showError:@"网络不给力"] ;
    self.backStatus(@"加载失败");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.progressView.width = kWidth;
    } completion:^(BOOL finished) {
        [self.progressView removeFromSuperview];
    }];
    [self.displayLink invalidate];
    if([error code] == NSURLErrorCancelled) return;
    [ProgressHUD showError:@"网络不给力"];
    self.backStatus(@"加载成功");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
