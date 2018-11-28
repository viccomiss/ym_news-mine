//
//  SEJSRedpacketrain.m
//  Hunt
//
//  Created by 杨明 on 2018/10/18.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "SEJSRedpacketrain.h"
#import "CommonUtils.h"
#import "WXRWebViewController.h"
#import "ShareMenuView.h"
#import "SEUserDefaults.h"

#define ShareHeight AdaptY(120) + TabbarNSH

@interface SEJSRedpacketrain()<UIGestureRecognizerDelegate>

/* jumpUrl */
@property (nonatomic, copy) NSString *jumpUrl;
/* share */
@property (nonatomic, strong) ShareMenuView *shareView;
/* maskView */
@property (nonatomic, strong) BaseView *maskView;

@end

@implementation SEJSRedpacketrain

-(void)responsejsCallWithData:(id)data{
    [super responsejsCallWithData:data];
    
    WXRWebViewController *vc = (WXRWebViewController *)[CommonUtils currentViewController];
    if ([[data jk_stringForKey:@"name"] isEqualToString:@"setRulesBtn"]) {
        self.jumpUrl = [data jk_stringForKey:@"url"];
        UIBarButtonItem *rulesItem = [[UIBarButtonItem alloc] initWithTitle:RuleOfActivity style:UIBarButtonItemStyleDone target:self action:@selector(rulesTouch)];
        vc.navigationItem.rightBarButtonItem = rulesItem;
    }else if ([[data jk_stringForKey:@"name"] isEqualToString:@"setShareBtn"]){
        WeakSelf(self);
        [vc.view addSubview:self.maskView];
        [vc.view addSubview:self.shareView];
        
        //分享数据
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[data jk_stringForKey:@"shareContent"] forKey:@"intro"];
        [dic setObject:[data jk_stringForKey:@"shareTitle"] forKey:@"title"];
        [dic setObject:vc.urlPath forKey:@"url"];
        [dic setObject:@"redEnvelope_logo" forKey:@"img"];
        
        self.shareView.shareBlock = ^(SSDKPlatformType type) {
            
            switch (type) {
                case SSDKPlatformTypePoster:
                {
                   
                }
                    break;
                case SSDKPlatformSubTypeWechatSession:
                {
                    [weakself.shareView shareRedEnvelopeWithData:dic type:type];
                }
                    break;
                case SSDKPlatformSubTypeWechatTimeline:
                {
                    [weakself.shareView shareRedEnvelopeWithData:dic type:type];
                }
                    break;
                default:
                    break;
            }
        };
        self.shareView.backBlock = ^{
            [weakself dissmissShare];
        };
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[ImageName(@"share") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareTouch)];
        vc.navigationItem.rightBarButtonItem = shareItem;
    }
}

- (void)loginAlert:(NSString *)alertStr{
    [EasyAlertView alertViewWithPart:^EasyAlertPart *{
        return [EasyAlertPart shared].setTitle(@"").setSubtitle(alertStr).setAlertType(AlertViewTypeAlert) ;
    } config:^EasyAlertConfig *{
        return [EasyAlertConfig shared].settwoItemHorizontal(YES).setAnimationType(AlertAnimationTypeFade).setTintColor(WhiteTextColor).setBgViewEvent(NO).setSubtitleTextAligment(NSTextAlignmentCenter).setEffectType(AlertBgEffectTypeAlphaCover) ;
    } buttonArray:^NSArray<NSString *> *{
        return @[Cancel,Confirm] ;
    } callback:^(EasyAlertView *showview , long index) {
        if (index) {
            [APIManager loginFailureShowLogin:YES];
        }
    }];
}

- (void)rulesTouch{
    WXRWebViewController *rulesVC = [[WXRWebViewController alloc] init];
    rulesVC.urlPath = self.jumpUrl;
    [[CommonUtils currentViewController].navigationController pushViewController:rulesVC animated:YES];
}

- (void)shareTouch{
    
    if (![[SEUserDefaults shareInstance] userIsLogin]) {
        [self loginAlert:ShareAlertSummary];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 1;
        self.shareView.frame = CGRectMake(0, MAINSCREEN_HEIGHT - self.shareView.frame.size.height, MAINSCREEN_WIDTH, self.shareView.frame.size.height);
    }];
}

- (void)maskTap:(UITapGestureRecognizer *)gesture{
    [self dissmissShare];
}

- (void)dissmissShare{
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.frame = CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, self.shareView.frame.size.height);
        self.maskView.alpha = 0;
    }];
}

- (ShareMenuView *)shareView{
    if (!_shareView) {
        _shareView = [[ShareMenuView alloc] initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, ShareHeight) shareType:ShareBundleType];
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

-(void)disconnectResponsejsCall{
    
    
    
}

@end
