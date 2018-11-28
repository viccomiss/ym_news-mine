//
//  AboutHuntViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/10.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "AboutHuntViewController.h"
#import "NSString+JLAdd.h"
#import "NewBuildVersionView.h"

@interface AboutHuntViewController ()

/* logo */
@property (nonatomic, strong) BaseImageView *logoView;
/* name */
@property (nonatomic, strong) BaseLabel *nameLabel;
/* version */
@property (nonatomic, strong) BaseLabel *versionLabel;
/* update */
@property (nonatomic, strong) BaseLabel *updateTag;
/* content */
@property (nonatomic, strong) BaseTextView *contentView;
/* installBtn */
@property (nonatomic, strong) BaseButton *installBtn;

@end

@implementation AboutHuntViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.contentView setContentOffset:CGPointZero animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = AboutUs;
    self.view.backgroundColor = WhiteTextColor;
    [self createUI];
}

#pragma mark - action
- (void)installTouch{
    [NewBuildVersionView showNewBuildVersionView:[AppInfo shareInstance].appInfo];
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.logoView];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(AdaptY(60) + NavbarH);
        make.size.mas_equalTo(CGSizeMake(AdaptX(70), AdaptX(70)));
    }];
    
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.logoView.mas_centerX);
        make.top.mas_equalTo(self.logoView.mas_bottom).offset(MaxPadding);
    }];
    
    [self.view addSubview:self.versionLabel];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(MidPadding);
        make.centerX.mas_equalTo(self.nameLabel.mas_centerX);
    }];
    
    [self.view addSubview:self.updateTag];
    [self.updateTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.versionLabel.mas_bottom).offset(AdaptY(80));
        make.centerX.mas_equalTo(self.nameLabel.mas_centerX);
    }];
    
    if ([AppInfo shareInstance].appInfo.version.length != 0) {
        [self.view addSubview:self.installBtn];
        [self.installBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-AdaptY(30));
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(AdaptX(290), AdaptY(45)));
        }];
        [self.installBtn setTitle:[NSString stringWithFormat:@"%@V%@",UpdateTo,[AppInfo shareInstance].appInfo.version] forState:UIControlStateNormal];
    }
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(2 * MaxPadding);
        make.right.mas_equalTo(self.view.mas_right).offset(-2 * MaxPadding);
        make.top.mas_equalTo(self.updateTag.mas_bottom).offset(MidPadding);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(- MaxPadding - AdaptY(30) - AdaptY(45));
    }];
    
    self.versionLabel.text = [NSString stringWithFormat:@"%@ v%@",VersionTag,[AppInfo currentVersion]];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:[UpdatesContent getAttributedStrWithLineSpace:3 font:Font(12)]];
    [attStr addAttribute:NSForegroundColorAttributeName value:TextDarkGrayColor range:NSMakeRange(0, attStr.length)];
    self.contentView.attributedText = attStr;
}

#pragma mark - init
- (BaseImageView *)logoView{
    if (!_logoView) {
        _logoView = [[BaseImageView alloc] initWithImage:ImageName(@"logo")];
    }
    return _logoView;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:Rainbow frame:CGRectZero textFont:Font(15) textColor:MainBlackColor textAlignment:NSTextAlignmentCenter];
    }
    return _nameLabel;
}

- (BaseLabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentCenter];
    }
    return _versionLabel;
}

- (BaseLabel *)updateTag{
    if (!_updateTag) {
        _updateTag = [SEFactory labelWithText:UpdateTag frame:CGRectZero textFont:Font(15) textColor:MainBlackColor textAlignment:NSTextAlignmentCenter];
    }
    return _updateTag;
}

- (BaseTextView *)contentView{
    if (!_contentView) {
        _contentView = [SEFactory textViewWithText:@"" frame:CGRectZero font:Font(12) textColor:TextDarkGrayColor];
        _contentView.editable = NO;
        _contentView.layoutManager.allowsNonContiguousLayout = NO;
    }
    return _contentView;
}

- (BaseButton *)installBtn{
    if (!_installBtn) {
        _installBtn = [SEFactory buttonWithTitle:@"更新到V2.20" frame:CGRectMake(0, 0, AdaptX(290), AdaptY(45)) font:Font(16) fontColor:WhiteTextColor];
        [_installBtn.layer insertSublayer:[UIColor setGradualChangingColor:_installBtn fromColor:[ThemeManager sharedInstance].gradientColor toColor:[ThemeManager sharedInstance].themeColor] below:_installBtn.titleLabel.layer];
        ViewRadius(_installBtn, AdaptY(45 / 2));
        [_installBtn addTarget:self action:@selector(installTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _installBtn;
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
