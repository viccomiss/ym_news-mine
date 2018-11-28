//
//  ContactViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/10.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "ContactViewController.h"
#import "UserModel.h"

@interface ContactViewController ()

/* top */
@property (nonatomic, strong) BaseView *topView;
/* topTag */
@property (nonatomic, strong) BaseLabel *topTagLabel;
/* wechat */
@property (nonatomic, strong) BaseLabel *weChatLabel;
/* code */
@property (nonatomic, strong) BaseImageView *codeView;
/* codeTag */
@property (nonatomic, strong) BaseLabel *codeTagLabel;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = ContactUs;
    self.view.backgroundColor = WhiteTextColor;
    [self createUI];
    [self loadData];
}

- (void)loadData{
    
    [UserModel contact_us:@{} Success:^(id responseObject) {
        
        self.weChatLabel.text = [responseObject jk_stringForKey:@"wechatNo"];
//        [self.codeView sd_setImageWithURL:[NSURL URLWithString:[responseObject jk_stringForKey:@"wechatUrl"]]];
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
        make.left.right.mas_equalTo(self.view);
        make.height.equalTo(@(AdaptY(45)));
    }];
    
    BaseView *line = [[BaseView alloc] init];
    line.backgroundColor = LineColor;
    [self.topView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.topView);
        make.height.equalTo(@(0.5));
    }];
    
    [self.topView addSubview:self.topTagLabel];
    [self.topTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView.mas_left).offset(MaxPadding);
        make.centerY.mas_equalTo(self.topView);
    }];
    
    [self.topView addSubview:self.weChatLabel];
    [self.weChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topView.mas_right).offset(-MaxPadding);
        make.centerY.mas_equalTo(self.topTagLabel.mas_centerY);
    }];
    
    [self.view addSubview:self.codeView];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).offset(AdaptY(100));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AdaptX(130), AdaptX(130)));
    }];
    
    [self.view addSubview:self.codeTagLabel];
    [self.codeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.codeView.mas_centerX);
        make.top.mas_equalTo(self.codeView.mas_bottom).offset(AdaptY(25));
    }];
}

#pragma mark - init
- (BaseView *)topView{
    if (!_topView) {
        _topView = [[BaseView alloc] init];
    }
    return _topView;
}

- (BaseLabel *)topTagLabel{
    if (!_topTagLabel) {
        _topTagLabel = [SEFactory multilineLabelWithText:LocalizedString(@"官方客服微信号") frame:CGRectZero textFont:Font(15) textColor:MainBlackColor];
    }
    return _topTagLabel;
}

- (BaseLabel *)weChatLabel{
    if (!_weChatLabel) {
        _weChatLabel = [SEFactory multilineLabelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:MainBlackColor];
    }
    return _weChatLabel;
}

- (BaseImageView *)codeView{
    if (!_codeView) {
        _codeView = [[BaseImageView alloc] initWithImage:ImageName(@"code_default")];
    }
    return _codeView;
}

- (BaseLabel *)codeTagLabel{
    if (!_codeTagLabel) {
        _codeTagLabel = [SEFactory multilineLabelWithText:LocalizedString(@"加客服微信进入官方微信群") frame:CGRectZero textFont:Font(12) textColor:MainBlackColor];
    }
    return _codeTagLabel;
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
