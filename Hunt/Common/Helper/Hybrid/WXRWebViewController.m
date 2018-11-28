//
//  WXRWebViewController.m
//  wxer_manager
//
//  Created by levin on 2017/8/11.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "WXRWebViewController.h"
#import <WebKit/WebKit.h>
#import "SEUserDefaults.h"
#import "AppInfo.h"
#import "SEJSBridgeEngine.h"
#import "NSString+JLAdd.h"

#define  PROMOTION  @"promotion"
#define Agent @"rainbow:"

@interface WXRWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) BaseButton *closeBtn;
/* progress */
@property (nonatomic, strong) UIProgressView *progressView;

@property SEJSBridgeEngine *webViewBridge;
/* userAgent */
@property (nonatomic, copy) NSString *userAgent;

@end

@implementation WXRWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [WKWebViewJavascriptBridge enableLogging];
    self.webViewBridge = [SEJSBridgeEngine bridgeForWebView:self.webView];
    
    [self.webViewBridge setWebViewDelegate:self];
    [self.webViewBridge disableJavscriptAlertBoxSafetyTimeout];
    [self.webViewBridge registerNativeService];
    
    [self addNavigationBackBtn];
    [self setContraints];
    
    if ([self.HtmlStr notEmptyOrNull]) {
        [self.webView loadHTMLString:[NSString stringWithFormat:@"%@",self.HtmlStr] baseURL:nil];
    }else if (self.url){
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }else if (self.urlPath){
        
        [self setAgent];
        
    }else {
        if (self.dataFrom == WXRWebViewControllerDataFromContactUs) {
            self.title = ContactUs;
            [self loadContactUs];
        }
    }
    
   //监听登录失效退出页面，预防session为空
    [SENotificationCenter addObserver:self selector:@selector(loginOut) name:LOGOUTSUCCESS object:nil];
}

- (void)loginOut{
    [self.navigationController popViewControllerAnimated:NO];
}

//设置agent
- (void)setAgent{
    WeakSelf(self);
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        __strong typeof(weakself) strongSelf = weakself;
        NSString *newUserAgent = @"";
        if ([result hasPrefix:Agent]) {
            newUserAgent = result;
        }else{
            newUserAgent = [NSString stringWithFormat:@"%@%@",Agent,result];//自定义需要拼接的字符串
        }
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":newUserAgent}];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [strongSelf.webView setCustomUserAgent:newUserAgent];
        
        if (strongSelf.urlPath){
            [strongSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strongSelf.urlPath]]];
        }
        
        [strongSelf.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            strongSelf.userAgent = result;
            //没有agent 刷新
            if (![result hasPrefix:Agent]) {
//                [strongSelf setAgent];
            }
        }];
    }];
}

#pragma mark - request
- (void)loadContactUs{
    [UserModel contact_us:@{} Success:^(id responseObject) {
        
        self.urlPath = responseObject;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlPath]]];
        
    } Failure:^(NSError *error) {
        
    }];
}


-(void)setContraints{
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
    }];
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [_webViewBridge removeResponsingNativeService];
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    if ([AppInfo currentIOSVersion] >= 9.0) {
        [webView reload];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    
    //https://open.weixin.qq.com  微信授权
    NSString *str = [URL absoluteString];
    NSString *scheme = [URL scheme];
    NSLog(@"scheme == %@ url == %@",scheme, URL);
    if ([str hasPrefix:@"https://open.weixin.qq.com"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlPath]]];
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    if (self.urlPath) {
        if (![self.userAgent hasPrefix:Agent]) {
            [self setAgent];
        }
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView) {
        if ([keyPath isEqualToString:@"title"]){
            if (_webView.title == nil) {
                [_webView reload];
            }
            if (![self.title notEmptyOrNull]) {
                self.title = self.webView.title;
            }
        }
        if ([keyPath isEqualToString:@"canGoBack"]){
            self.closeBtn.hidden = !self.webView.canGoBack;
        }
        if ([keyPath isEqual: @"estimatedProgress"]) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:_webView.estimatedProgress animated:YES];
            if(_webView.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark =========action=========
-(void)backAction{
    if (_webViewBridge.hasResponsing) {
        [_webViewBridge removeResponsingNativeService];
        _webViewBridge.hasResponsing = NO;
        return;
    }
    
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)closeAction {
    [_webViewBridge removeResponsingNativeService];
    
    if (self.modelType == WXRWebViewControllerModelTypePresent) {
        if (self.navigationController) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark =========UI=========
- (void)addNavigationBackBtn {
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 105, 44)];
    [btnView setLayoutMargins:UIEdgeInsetsMake(0, -15, 0, 0)];
    [btnView setBackgroundColor:[UIColor clearColor]];
    BaseButton *backButton =  [SEFactory buttonWithImage:ImageName(@"nav_back_black") frame:CGRectMake(-15, 0, 40, 44)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    backButton.imageView.contentMode = UIViewContentModeLeft;
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.closeBtn =  [SEFactory buttonWithTitle:Close frame:CGRectMake(backButton.easy_right + 8, 0, 40, 44) font:Font(15) fontColor:MainTextColor];
    [self.closeBtn setBackgroundColor:[UIColor clearColor]];
    self.closeBtn.imageView.contentMode = UIViewContentModeCenter;
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn setHidden:YES];
    [btnView addSubview:backButton];
    [btnView addSubview:self.closeBtn];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    if (self.navigationController) {
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
    }
}

-(WKWebView *)webView{
    if (!_webView) {
        //内容自适应处理 加载html字符串使用
        NSString *adaptCss = [NSString stringWithFormat:@"<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><style type='text/css'>img{max-width: 100%%; width:auto; height:auto;}</style>"];
        
        //禁止长按弹出 UIMenuController 相关
        NSString *disableCss = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";
        //css 选中样式取消
        NSMutableString*disableCssJS = [NSMutableString string];
        [disableCssJS appendString:@"var style = document.createElement('style');"];
        [disableCssJS appendString:@"style.type = 'text/css';"];
        [disableCssJS appendFormat:@"var cssContent = document.createTextNode('%@');", disableCss];
        [disableCssJS appendString:@"style.appendChild(cssContent);"];
        [disableCssJS appendString:@"document.body.appendChild(style);"];
        [disableCssJS appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
        [disableCssJS appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        WKUserScript *longTapUScript = [[WKUserScript alloc] initWithSource:disableCssJS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        
        WKUserContentController *userCC = [[WKUserContentController alloc] init];
        [userCC addUserScript:longTapUScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = userCC;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:NULL];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [_webView addObserver:self forKeyPath:NSInternalInconsistencyException options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NavbarH, MAINSCREEN_WIDTH, 2)];
        _progressView.progressTintColor = MainBlueColor;
    }
    return _progressView;
}

-(void)dealloc{
    [_webViewBridge removeResponsingNativeService];
    [_webView removeObserver:self forKeyPath:@"canGoBack"];
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:NSInternalInconsistencyException];
    
    //清除缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
        NSLog(@"缓存清除成功");
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
