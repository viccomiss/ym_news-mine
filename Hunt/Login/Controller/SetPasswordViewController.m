//
//  SetPasswordViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/7.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "LoginView.h"

@interface SetPasswordViewController ()<loginViewDelegate>

@property (nonatomic, strong) LoginView *loginView;

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

#pragma mark - login delegate
- (void)loginViewLeftTouch{
    
}

- (void)loginViewRightTouch{
    [self dismiss:nil];
}

- (void)dismiss:(id)param{
    [self dismissViewControllerAnimated:YES completion:^{
        if (param != nil) {
            if (self.setPasswordSuccess) {
                self.setPasswordSuccess(param);
            }
        }
    }];
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.loginView.mobile = self.mobile;
}

#pragma mark - init
- (LoginView *)loginView{
    if (!_loginView) {
        _loginView = [[LoginView alloc] initWithLoginType:LoginSetPasswordType];
        _loginView.delegate = self;
    }
    return _loginView;
}

- (void)dealloc{
    [SENotificationCenter removeObserver:self];
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
