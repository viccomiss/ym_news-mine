//
//  InfomationDetailViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/11/19.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "InfomationDetailViewController.h"
#import <WebKit/WebKit.h>
#import "ShareMenuView.h"
#import "SEUserDefaults.h"
#import "NewsListModel.h"
#import "DateManager.h"
#import "NSString+JLAdd.h"


#define ShareHeight AdaptY(120) + TabbarNSH
@interface InfomationDetailViewController()<WKNavigationDelegate,WKUIDelegate,UIGestureRecognizerDelegate>

/* info */
@property (nonatomic, strong) BaseView *infoView;
/* title */
@property (nonatomic, strong) BaseLabel *titleLabel;
/* time */
@property (nonatomic, strong) BaseLabel *timeLabel;
/* bottom */
@property (nonatomic, strong) BaseView *bottomView;
/* statement */
@property (nonatomic, strong) BaseLabel *statementLabel;
/* webView */
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIScrollView *scrollView;
/* content */
@property (nonatomic, strong) BaseView *contentView;
@property (nonatomic, strong) ShareMenuView *shareView;
@property (nonatomic, strong) BaseView *maskView;
/* new */
@property (nonatomic, strong) New *model;

@end

@implementation InfomationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"虹掌资讯";
    [self createUI];
    [self loadData];
}

#pragma mark - action
- (BOOL)checkLogin{
    if (![[SEUserDefaults shareInstance] userIsLogin]) {
        [EasyAlertView alertViewWithPart:^EasyAlertPart *{
            return [EasyAlertPart shared].setTitle(@"").setSubtitle(CurrentAccountNotLoggedIn).setAlertType(AlertViewTypeAlert) ;
        } config:^EasyAlertConfig *{
            return [EasyAlertConfig shared].settwoItemHorizontal(YES).setAnimationType(AlertAnimationTypeFade).setTintColor(WhiteTextColor).setBgViewEvent(NO).setSubtitleTextAligment(NSTextAlignmentCenter).setEffectType(AlertBgEffectTypeAlphaCover) ;
        } buttonArray:^NSArray<NSString *> *{
            return @[Cancel,Confirm] ;
        } callback:^(EasyAlertView *showview , long index) {
            if (index) {
                [APIManager loginFailureShowLogin:YES];
            }
        }];
        return NO;
    }
    return YES;
}

- (void)shareTouch{
    if ([self checkLogin]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 1;
            self.shareView.frame = CGRectMake(0, MAINSCREEN_HEIGHT - self.shareView.frame.size.height - TabbarNSH, MAINSCREEN_WIDTH, self.shareView.frame.size.height);
        }];
    }
}

- (void)maskTap:(UITapGestureRecognizer *)gesture{
    [self dissmissShare];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isEqual:self.shareView]) {
        return NO;
    }
    return YES;
}

- (void)dissmissShare{
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.frame = CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, self.shareView.frame.size.height);
        self.maskView.alpha = 0;
    }];
}

#pragma mark - request
- (void)loadData{
    
    [EasyLoadingView showLoading];
    [New usr_news_new:@{@"newsId": self.newsId} Success:^(New * _Nonnull items) {
        
        self.model = items;
        
        self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[DateManager timeInterval:items.publishDate days:1 isMDHS:YES],items.originName];
        
        self.titleLabel.attributedText = [items.title getAttributedStrWithLineSpace:3 font:[UIFont boldSystemFontOfSize:22]];
        
        
        //自动换行
        NSString *htmlStr = items.content;
        if (htmlStr.length == 0) {
            htmlStr = @"<h4 align=\"center\">暂无内容</h4>";
        }
        
        if (htmlStr) {
            NSURL *cssUrl = [[NSBundle mainBundle] URLForResource:@"body_style" withExtension:@"css"];
            NSMutableString *html = [NSMutableString string];
            [html appendString:@"<html>"];
            [html appendString:@"<head>"];
            [html appendString:@"<style type=""text/css""> p {line-height:28px;padding:7px 7px} </style>"];
            [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",cssUrl];
            [html appendString:htmlStr];
            [html appendString:@"</body>"];
            [html appendString:@"</html>"];
            [self.webView loadHTMLString:html baseURL:cssUrl];
            [self setConstraints];
        }
        
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setConstraints{
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(NavbarH);
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.leading.trailing.mas_equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.infoView).offset(MaxPadding);
        make.right.mas_equalTo(self.infoView.mas_right).offset(-MaxPadding);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.infoView.mas_bottom).offset(-MaxPadding);
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(MaxPadding);
    }];
    
    UIView *topline = [[UIView alloc] init];
    topline.backgroundColor = LineColor;
    [self.infoView addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.infoView.mas_bottom);
        make.left.right.mas_equalTo(self.titleLabel);
        make.height.equalTo(@(0.5));
    }];

    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoView.mas_bottom);
        make.height.greaterThanOrEqualTo(@16.f);
        make.leading.trailing.bottom.mas_equalTo(self.contentView);
    }];
}

- (void)setBottomConstraints{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.webView);
        make.height.equalTo(@(AdaptY(90)));
        make.bottom.mas_equalTo(self.scrollView.mas_bottom);
        make.top.mas_equalTo(self.webView.mas_bottom);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    [self.bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomView);
        make.left.mas_equalTo(self.bottomView.mas_left).offset(MaxPadding);
        make.right.mas_equalTo(self.bottomView.mas_right).offset(-MaxPadding);
        make.height.equalTo(@(0.5));
    }];
    
    [self.statementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(line);
        make.centerY.mas_equalTo(self.bottomView);
    }];
}

#pragma mark - UI
- (void)createUI{
    
    WeakSelf(self);
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.infoView];
    [self.infoView addSubview:self.titleLabel];
    [self.infoView addSubview:self.timeLabel];
    [self.contentView addSubview:self.webView];
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.statementLabel];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.shareView];
    self.shareView.backBlock = ^{
        [weakself dissmissShare];
    };
    self.shareView.shareBlock = ^(SSDKPlatformType type) {
        switch (type) {
            case SSDKPlatformTypeCopyLink:
            {
                
            }
                break;
            case SSDKPlatformSubTypeWechatSession:
            {
//                [weakself.shareView shareBundleWithId:weakself.bundle type:type];
            }
                break;
            case SSDKPlatformSubTypeWechatTimeline:
            {
//                [weakself.shareView shareBundleWithId:weakself.bundle type:type];
            }
                break;
            default:
                break;
        }
    };
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[ImageName(@"share") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareTouch)];
    self.navigationItem.rightBarButtonItem = shareItem;
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"load：receiveInfo");
    //禁用操作
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none'" completionHandler:nil];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none'" completionHandler:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES ;
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id data, NSError * _Nullable error) {
        CGFloat height = [data floatValue] < 40 ? 40 : [data floatValue] + 10;
        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.infoView.mas_bottom);
            make.height.mas_equalTo(height);
            make.leading.trailing.mas_equalTo(self.scrollView);
//            make.bottom.mas_equalTo(self.bottomView.mas_top);
        }];
        [self setBottomConstraints];
    }];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"load：fail%@",error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO ;
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"loadFinish:jumpRequest");
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"load：responseHeader");
    WKNavigationResponsePolicy responsePolicy = WKNavigationResponsePolicyAllow;
    // 这句是必须加上的，不然会异常
    decisionHandler(responsePolicy);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated){
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


#pragma mark - init
- (BaseView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[BaseView alloc] init];
        _bottomView.backgroundColor = WhiteTextColor;
    }
    return _bottomView;
}

- (BaseLabel *)statementLabel{
    if (!_statementLabel) {
        _statementLabel = [SEFactory labelWithText:@"声明：本文版权归原作者所有，转载此文为传递更多市场信息，不代表虹掌的观点和立场，文章内容仅供参考，不构成投资建议，投资者据此操作，风险自担。" frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
        _statementLabel.numberOfLines = 0;
    }
    return _statementLabel;
}

- (BaseView *)infoView{
    if (!_infoView) {
        _infoView = [[BaseView alloc] init];
        _infoView.backgroundColor = WhiteTextColor;
    }
    return _infoView;
}

- (BaseLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:[UIFont boldSystemFontOfSize:22] textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

-(UIScrollView*)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavbarH, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - NavbarH)];
        _scrollView.backgroundColor = BackGroundColor;
    }
    return _scrollView;
}

-(BaseView *)contentView{
    if (!_contentView) {
        _contentView = [[BaseView alloc]initWithFrame:CGRectZero];
    }
    return _contentView;
}

- (ShareMenuView *)shareView{
    if (!_shareView) {
        _shareView = [[ShareMenuView alloc] initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, ShareHeight) shareType:ShareNewsType];
    }
    return _shareView;
}

- (BaseView *)maskView{
    if (!_maskView) {
        _maskView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _maskView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTap:)];
        tap.numberOfTapsRequired = 1;
        tap.delegate = self;
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

-(WKWebView *)webView{
    if (!_webView) {
        //css 内容自适应 禁止缩放
        NSMutableString*adaptJS = [[NSMutableString alloc]initWithString:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=1,user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.width='100%';imgs[i].style.height='auto';}"];
        WKUserScript *longTapUScript = [[WKUserScript alloc] initWithSource:adaptJS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:longTapUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.allowsInlineMediaPlayback = YES;
        wkWebConfig.userContentController = wkUController;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
        _webView.scrollView.scrollEnabled = NO;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}
@end



