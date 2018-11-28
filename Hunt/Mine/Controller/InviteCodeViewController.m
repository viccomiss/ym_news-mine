//
//  InviteCodeViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/9.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "InviteCodeViewController.h"
#import "ShareMenuView.h"
#import "UserModel.h"
#import "SEUserDefaults.h"
#import "UIImage+JLAdd.h"

#define ShareHeight AdaptY(120) + TabbarNSH


@interface InviteCodeViewController ()

/* bg */
@property (nonatomic, strong) BaseImageView *bgView;
/* logoView */
@property (nonatomic, strong) BaseImageView *logoView;
/* logoTag */
@property (nonatomic, strong) BaseLabel *logoTagLabel;
/* shareTag */
@property (nonatomic, strong) BaseLabel *shareTagLabel;
/* generate */
@property (nonatomic, strong) BaseButton *generateBtn;
/* codeTag */
@property (nonatomic, strong) BaseLabel *codeTagLabel;
/* code */
@property (nonatomic, strong) BaseLabel *codeLabel;
/* copy */
@property (nonatomic, strong) BaseButton *codeBtn;
/* record */
@property (nonatomic, strong) BaseLabel *recordTagLabel;
/* invite */
@property (nonatomic, strong) BaseLabel *inviteNumLabel;
/* reward */
@property (nonatomic, strong) BaseLabel *rewardLabel;
/* rewardRule */
@property (nonatomic, strong) BaseLabel *ruleTagLabel;
/* rule */
@property (nonatomic, strong) BaseLabel *ruleLabel;
/* download */
@property (nonatomic, strong) BaseImageView *downloadView;
/* download */
@property (nonatomic, strong) BaseLabel *downloadLabel;
/* share */
@property (nonatomic, strong) ShareMenuView *shareView;
/* user */
@property (nonatomic, strong) UserModel *user;

@end

@implementation InviteCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = InviteCode;
    
    [self createUI];
    [self loadData];
}

#pragma mark - request
- (void)loadData{
    
    self.user = [[SEUserDefaults shareInstance] getUserModel];
    self.codeLabel.text = self.user.user.code;
    [EasyLoadingView showLoading];
    [UserModel invite_info:@{} Success:^(id responseObject) {
        
        self.shareTagLabel.text = [responseObject jk_stringForKey:@"msg"];
        NSString *url = [responseObject jk_stringForKey:@"url"];
        self.downloadView.image = [UIImage QRcodeByUrlString:url size:CGSizeMake(AdaptX(120), AdaptX(120))];
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - action
- (void)generateTouch{
    [UIView animateWithDuration:0.4 animations:^{
        
        CGRect navFrame = self.navigationBar.frame;
        navFrame.origin.y = -NavbarH;
        self.navigationBar.frame = navFrame;
        
        CGRect shareF = self.shareView.frame;
        shareF.origin.y = MAINSCREEN_HEIGHT - shareF.size.height;
        self.shareView.frame = shareF;
        
        self.bgView.image = ImageName(@"invite_code_share_bg");

        CGRect bgF = self.bgView.frame;
        bgF.origin.y = StatusBarH;
        bgF.size.height = MAINSCREEN_HEIGHT - TabbarNSH - StatusBarH;
        self.bgView.frame = bgF;
        
        [self.downloadLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-AdaptY(163) - TabbarNSH);
            make.centerX.mas_equalTo(self.bgView.mas_centerX);
        }];
        
        [self.downloadView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.downloadLabel.mas_top).offset(-MidPadding);
            make.centerX.mas_equalTo(self.bgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(AdaptX(120), AdaptX(120)));
        }];
        
        [self.codeTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.logoTagLabel.mas_bottom).offset(AdaptY(35));
            make.centerX.mas_equalTo(self.bgView.mas_centerX);
        }];
        
        self.logoView.hidden = NO;
        self.logoTagLabel.hidden = NO;
        self.shareTagLabel.hidden = NO;
        
        self.recordTagLabel.hidden = YES;
        self.inviteNumLabel.hidden = YES;
        self.rewardLabel.hidden = YES;
        self.ruleTagLabel.hidden = YES;
        self.ruleLabel.hidden = YES;
        self.codeBtn.hidden = YES;
    }];
}

- (void)copyCodeTouch{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.codeLabel.text;
    [EasyTextView showText:@"复制成功"];
}

- (void)restore{
    [UIView animateWithDuration:0.4 animations:^{
        
        CGRect navFrame = self.navigationBar.frame;
        navFrame.origin.y = StatusBarH;
        self.navigationBar.frame = navFrame;
        
        CGRect shareF = self.shareView.frame;
        shareF.origin.y = MAINSCREEN_HEIGHT;
        self.shareView.frame = shareF;
        
        self.bgView.image = ImageName(@"invite_code_big_bg");
        
        CGRect bgF = self.bgView.frame;
        bgF.origin.y = ISIPHONE_X_S ? AdaptY(24) : 0;
        bgF.size.height = MAINSCREEN_HEIGHT - (ISIPHONE_X_S ? TabbarNSH + AdaptY(24) : 0);
        self.bgView.frame = bgF;
        
        [self.downloadLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-AdaptY(102) - TabbarNSH);
            make.centerX.mas_equalTo(self.bgView.mas_centerX);
        }];
        
        [self.downloadView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.downloadLabel.mas_top).offset(-MidPadding);
            make.centerX.mas_equalTo(self.bgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(AdaptX(120), AdaptX(120)));
        }];
        
        [self.codeTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(NavbarH + AdaptY(60));
            make.centerX.mas_equalTo(self.bgView.mas_centerX);
        }];
        
        self.logoView.hidden = YES;
        self.logoTagLabel.hidden = YES;
        self.shareTagLabel.hidden = YES;
        
        self.recordTagLabel.hidden = NO;
        self.inviteNumLabel.hidden = NO;
        self.rewardLabel.hidden = NO;
        self.ruleTagLabel.hidden = NO;
        self.ruleLabel.hidden = NO;
    }];
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.bgView];
    
    [self.bgView addSubview:self.generateBtn];
    [self.generateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-AdaptY(18));
        make.left.mas_equalTo(self.bgView.mas_left).offset(AdaptX(26));
        make.right.mas_equalTo(self.bgView.mas_right).offset(-AdaptX(26));
        make.height.equalTo(@(AdaptY(45)));
    }];
    
    [self.bgView addSubview:self.codeTagLabel];
    [self.codeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH + AdaptY(60));
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
    }];
    
    [self.bgView addSubview:self.codeLabel];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeTagLabel.mas_bottom).offset(MidPadding);
        make.centerX.mas_equalTo(self.codeTagLabel.mas_centerX);
    }];
    
    [self.bgView addSubview:self.codeBtn];
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeLabel.mas_bottom).offset(MidPadding);
        make.centerX.mas_equalTo(self.codeTagLabel.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AdaptX(75), AdaptY(28)));
    }];
    
    [self.bgView addSubview:self.recordTagLabel];
    [self.recordTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(AdaptX(44));
        make.top.mas_equalTo(self.codeBtn.mas_bottom).offset(AdaptY(25));
    }];
    
    [self.bgView addSubview:self.inviteNumLabel];
    [self.inviteNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.recordTagLabel.mas_bottom).offset(MinPadding);
        make.left.mas_equalTo(self.recordTagLabel.mas_left);
    }];
    
    [self.bgView addSubview:self.rewardLabel];
    [self.rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inviteNumLabel.mas_bottom).offset(3);
        make.left.mas_equalTo(self.inviteNumLabel);
    }];
    
    [self.bgView addSubview:self.ruleTagLabel];
    [self.ruleTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rewardLabel.mas_bottom).offset(AdaptY(25));
        make.left.mas_equalTo(self.rewardLabel.mas_left);
    }];
    
    [self.bgView addSubview:self.ruleLabel];
    [self.ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ruleTagLabel.mas_bottom).offset(MinPadding);
        make.left.mas_equalTo(self.ruleTagLabel);
    }];
    
    [self.bgView addSubview:self.downloadLabel];
    [self.downloadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-AdaptY(102) - TabbarNSH);
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
    }];
    
    [self.bgView addSubview:self.downloadView];
    [self.downloadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.downloadLabel.mas_top).offset(-MidPadding);
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AdaptX(120), AdaptX(120)));
    }];
    
    [self.bgView addSubview:self.logoView];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).offset(AdaptY(58));
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AdaptX(40), AdaptX(40)));
    }];
    
    [self.bgView addSubview:self.logoTagLabel];
    [self.logoTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoView.mas_bottom).offset(MidPadding);
        make.centerX.mas_equalTo(self.logoView.mas_centerX);
    }];
    
    [self.bgView addSubview:self.shareTagLabel];
    [self.shareTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeLabel.mas_bottom).offset(AdaptY(50));
        make.centerX.mas_equalTo(self.bgView);
    }];
    
    WeakSelf(self);
    [self.view addSubview:self.shareView];
    self.shareView.backBlock = ^{
//        [weakself restore];
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    self.shareView.shareBlock = ^(SSDKPlatformType type) {
        
        UIImage *img = [UIImage getImage:weakself.bgView size:CGSizeMake(MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - TabbarNSH - StatusBarH - AdaptY(120))];
        
        [weakself.shareView shareWithImage:img type:type];
    };
    
    [self generateTouch];
}

#pragma mark - init
- (BaseImageView *)bgView{
    if (!_bgView) {
        _bgView = [[BaseImageView alloc] initWithImage:ImageName(@"invite_code_big_bg")];
        _bgView.frame = CGRectMake(0, ISIPHONE_X_S ? AdaptY(24) : 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - (ISIPHONE_X_S ? TabbarNSH + AdaptY(24) : 0));
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (BaseButton *)generateBtn{
    if (!_generateBtn) {
        _generateBtn = [SEFactory buttonWithTitle:GenerateInvitationCARDS image:nil frame:CGRectMake(0, 0, MAINSCREEN_WIDTH - AdaptX(26) * 2, AdaptY(45)) font:Font(16) fontColor:WhiteTextColor];
        [_generateBtn.layer insertSublayer:[UIColor setGradualChangingColor:_generateBtn fromColor:[ThemeManager sharedInstance].gradientColor toColor:[ThemeManager sharedInstance].themeColor] below:_generateBtn.titleLabel.layer];
        [_generateBtn addTarget:self action:@selector(generateTouch) forControlEvents:UIControlEventTouchUpInside];
        ViewShadow(_generateBtn, CGSizeMake(2, 2), [MainBlackColor colorWithAlphaComponent:0.2], 2, 2, AdaptX(3));
    }
    return _generateBtn;
}

- (BaseLabel *)codeTagLabel{
    if (!_codeTagLabel) {
        _codeTagLabel = [SEFactory labelWithText:MyInvitationCode frame:CGRectZero textFont:Font(14) textColor:MainBlackColor textAlignment:NSTextAlignmentCenter];
    }
    return _codeTagLabel;
}

- (BaseLabel *)codeLabel{
    if (!_codeLabel) {
        _codeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:[UIFont boldSystemFontOfSize:40] textColor:[UIColor colorWithRed:56/255.0 green:58/255.0 blue:76/255.0 alpha:1] textAlignment:NSTextAlignmentCenter];
    }
    return _codeLabel;
}

- (BaseButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn = [SEFactory buttonWithTitle:Copy image:nil frame:CGRectMake(0, 0, AdaptX(75), AdaptY(28)) font:Font(14) fontColor:WhiteTextColor];
        [_codeBtn.layer insertSublayer:[UIColor setGradualChangingColor:_codeBtn fromColor:[ThemeManager sharedInstance].gradientColor toColor:[ThemeManager sharedInstance].themeColor] below:_codeBtn.titleLabel.layer];
        [_codeBtn addTarget:self action:@selector(copyCodeTouch) forControlEvents:UIControlEventTouchUpInside];
        ViewRadius(_codeBtn, AdaptX(5));
    }
    return _codeBtn;
}

- (BaseLabel *)recordTagLabel{
    if (!_recordTagLabel) {
        _recordTagLabel = [SEFactory labelWithText:MyRecord frame:CGRectZero textFont:Font(13) textColor:MainBlackColor textAlignment:NSTextAlignmentLeft];
    }
    return _recordTagLabel;
}

- (BaseLabel *)inviteNumLabel{
    if (!_inviteNumLabel) {
        _inviteNumLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(11) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _inviteNumLabel;
}

- (BaseLabel *)rewardLabel{
    if (!_rewardLabel) {
        _rewardLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(11) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _rewardLabel;
}

- (BaseLabel *)ruleTagLabel{
    if (!_ruleTagLabel) {
        _ruleTagLabel = [SEFactory labelWithText:RewardRules frame:CGRectZero textFont:Font(13) textColor:MainBlackColor textAlignment:NSTextAlignmentLeft];
    }
    return _ruleTagLabel;
}

- (BaseLabel *)ruleLabel{
    if (!_ruleLabel) {
        _ruleLabel = [SEFactory labelWithText:LocalizedString(@"当前活动期间，每邀请一个好友注册虹掌，奖励2个掌币") frame:CGRectZero textFont:Font(11) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _ruleLabel;
}

- (BaseImageView *)downloadView{
    if (!_downloadView) {
        _downloadView = [[BaseImageView alloc] initWithImage:ImageName(@"code_default")];
    }
    return _downloadView;
}

- (BaseLabel *)downloadLabel{
    if (!_downloadLabel) {
        _downloadLabel = [SEFactory labelWithText:LocalizedString(@"扫码下载虹掌") frame:CGRectZero textFont:Font(12) textColor:MainBlackColor textAlignment:NSTextAlignmentCenter];
    }
    return _downloadLabel;
}

- (ShareMenuView *)shareView{
    if (!_shareView) {
        _shareView = [[ShareMenuView alloc] initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, ShareHeight) shareType:ShareCodeType];
    }
    return _shareView;
}

- (BaseImageView *)logoView{
    if (!_logoView) {
        _logoView = [[BaseImageView alloc] initWithImage:ImageName(@"logo")];
        _logoView.hidden  =YES;
    }
    return _logoView;
}

- (BaseLabel *)logoTagLabel{
    if (!_logoTagLabel) {
        _logoTagLabel = [SEFactory labelWithText:DigitalFutureControl frame:CGRectZero textFont:Font(11) textColor:LightTextGrayColor textAlignment:NSTextAlignmentCenter];
        _logoTagLabel.hidden = YES;
    }
    return _logoTagLabel;
}

- (BaseLabel *)shareTagLabel{
    if (!_shareTagLabel) {
        _shareTagLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(13) textColor:MainBlackColor textAlignment:NSTextAlignmentCenter];
        _shareTagLabel.hidden = YES;
    }
    return _shareTagLabel;
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
