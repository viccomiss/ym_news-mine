//
//  SplashHomeView.m
//  Hunt
//
//  Created by 杨明 on 2018/10/26.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "SplashHomeView.h"
#import "WXRWebViewController.h"
#import "CommonUtils.h"

@interface SplashHomeView()

/* content */
@property (nonatomic, strong) BaseImageView *contentView;
/* close */
@property (nonatomic, strong) BaseButton *closeBtn;
/* LaunchAdModel */
@property (nonatomic, strong) LaunchAdModel *model;

@end

@implementation SplashHomeView

- (instancetype)initWithData:(LaunchAdModel *)ad{
    if (self == [super init]) {
        
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
        self.model = ad;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [[UIApplication sharedApplication].windows.lastObject addSubview:self];
        
        [self createUI];
    }
    return self;
}

+ (instancetype)showHoneADWithData:(LaunchAdModel *)ad{
    return [[SplashHomeView alloc] initWithData:ad];
}

#pragma mark - action
- (void)contentTap{
    if (self.model.redirectUrl.length == 0) {
        return;
    }
    [self closeAnimated];
    WXRWebViewController *VC = [[WXRWebViewController alloc] init];
    VC.urlPath = self.model.redirectUrl;
    [[CommonUtils currentViewController].navigationController pushViewController:VC animated:YES];
}

- (void)closeTouch{
    [self closeAnimated];
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.contentView];
    [self addSubview:self.closeBtn];
    
    [self.contentView sd_setImageWithURL:[NSURL URLWithString:self.model.resourceUrl]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTap)];
    tap.numberOfTapsRequired = 1;
    [self.contentView addGestureRecognizer:tap];

    [self showAnimated];
}

- (void)showAnimated{
    
    self.alpha = 0;
    self.contentView.transform = CGAffineTransformScale(self.transform,0.1,0.1);
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    }];
}

- (void)closeAnimated{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformScale(self.transform,0.1,0.1);
        self.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.contentView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - init
- (BaseImageView *)contentView{
    if (!_contentView) {
        CGFloat width = MAINSCREEN_WIDTH - 47 * 2;
        CGFloat height = width * 1.14;
        _contentView = [[BaseImageView alloc] initWithFrame:CGRectMake(47, 119 + StatusBarH, width, height)];
        _contentView.contentMode = UIViewContentModeScaleAspectFill;
        _contentView.userInteractionEnabled = YES;
        ViewRadius(_contentView, 6);
    }
    return _contentView;
}

- (BaseButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [SEFactory buttonWithImage:ImageName(@"close_white_big") frame:CGRectMake((MAINSCREEN_WIDTH - 44) / 2, self.contentView.easy_bottom + 32, 44, 44)];
        [_closeBtn addTarget:self action:@selector(closeTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
