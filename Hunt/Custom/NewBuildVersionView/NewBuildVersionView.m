//
//  NewBuildVersionView.m
//  Hunt
//
//  Created by 杨明 on 2018/9/14.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "NewBuildVersionView.h"
#import "NSString+JLAdd.h"

#define HEIGHT AdaptY(198)

@interface NewBuildVersionView()<CAAnimationDelegate>

/* content */
@property (nonatomic, strong) BaseView *contentView;
/* close */
@property (nonatomic, strong) BaseButton *closeBtn;
/* icon */
@property (nonatomic, strong) BaseImageView *logoView;
/* tag */
@property (nonatomic, strong) BaseLabel *tagLabel;
/* version */
@property (nonatomic, strong) BaseLabel *contentLabel;
/* install */
@property (nonatomic, strong) BaseButton *installBtn;
/* appInfo */
@property (nonatomic, strong) AppVersionInfo *info;

@end

@implementation NewBuildVersionView

- (instancetype)initWithAppInfo:(AppVersionInfo *)info{
    if (self == [super init]) {
        
        self.info = info;
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [[UIApplication sharedApplication].windows.lastObject addSubview:self];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self createUI];
        });
    }
    return self;
}

+ (instancetype)showNewBuildVersionView:(AppVersionInfo *)info{
    return [[NewBuildVersionView alloc] initWithAppInfo:info];
}

#pragma mark - action
- (void)closeTouch{
//    [AppInfo saveUpdateHang:self.info.version];
    [self closeAnimated];
}

- (void)installTouch{
    [EasyLoadingView showLoadingText:@"" config:^EasyLoadingConfig *{
        EasyLoadingConfig *config = [EasyLoadingConfig shared];
        config.superView = self.contentView;
        return config;
    }];
    [AppInfo installRainbowWithUrl:[AppInfo shareInstance].appInfo.url];
    WeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [EasyLoadingView hidenLoingInView:weakself.contentView];
    });
}

#pragma mark - UI
- (void)createUI{
    
    CGFloat height = [self.info.releaseNotes getSpaceLabelHeightWithFont:Font(13) withWidth:AdaptX(265) - AdaptX(43) * 2 lineSpace:3];
    
    if (height < AdaptY(60)) {
       height = AdaptY(60);
    }
    
    [self addSubview:self.contentView];
    self.contentView.frame = CGRectMake(AdaptX(55), (MAINSCREEN_HEIGHT - HEIGHT - height) / 2, MAINSCREEN_WIDTH - 2 * AdaptX(55), HEIGHT + height);
    
    if (!self.info.force) {
        [self.contentView addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-AdaptX(5));
            make.top.mas_equalTo(self.contentView.mas_top).offset(AdaptX(5));
            make.size.mas_equalTo(CGSizeMake(AdaptX(40), AdaptX(40)));
        }];
    }
    
    [self.contentView addSubview:self.logoView];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(AdaptY(20));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AdaptX(40), AdaptX(40)));
    }];
    
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.logoView);
        make.top.mas_equalTo(self.logoView.mas_bottom).offset(MidPadding);
    }];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tagLabel.mas_bottom).offset(AdaptY(30));
        make.left.mas_equalTo(self.contentView.mas_left).offset(AdaptX(43));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-AdaptX(43));
//        make.height.equalTo(@(height));
    }];
    
    [self.contentView addSubview:self.installBtn];
    [self.installBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-AdaptY(20));
        make.size.mas_equalTo(CGSizeMake(AdaptX(140), AdaptY(35)));
    }];
    
    self.contentLabel.attributedText = [self.info.releaseNotes getAttributedStrWithLineSpace:3 font:Font(13)];
    self.tagLabel.text = [NSString stringWithFormat:@"%@V%@",NewVersions,self.info.version];
    
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
- (BaseView *)contentView{
    if (!_contentView) {
        _contentView = [[BaseView alloc] init];
        _contentView.backgroundColor = WhiteTextColor;
        ViewRadius(_contentView, AdaptX(4));
    }
    return _contentView;
}

- (BaseImageView *)logoView{
    if (!_logoView) {
        _logoView = [[BaseImageView alloc] initWithImage:ImageName(@"logo")];
    }
    return _logoView;
}

- (BaseLabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:MainTextColor textAlignment:NSTextAlignmentCenter];
    }
    return _tagLabel;
}

- (BaseLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(13) textColor:LightTextGrayColor textAlignment:NSTextAlignmentCenter];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (BaseButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [SEFactory buttonWithImage:ImageName(@"close_black")];
        [_closeBtn addTarget:self action:@selector(closeTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (BaseButton *)installBtn{
    if (!_installBtn) {
        _installBtn = [SEFactory buttonWithTitle:UpdateNow image:nil frame:CGRectZero font:Font(14) fontColor:WhiteTextColor];
        [_installBtn py_addToThemeColorPool:@"backgroundColor"];
        ViewRadius(_installBtn, AdaptX(4));
        [_installBtn addTarget:self action:@selector(installTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _installBtn;
}

@end
