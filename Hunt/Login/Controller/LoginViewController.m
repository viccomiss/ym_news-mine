//
//  LoginViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/7.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "FindPasswordViewController.h"
#import "RegisterViewController.h"
#import "SetPasswordViewController.h"
#import "LoginNextViewController.h"

@interface LoginViewController ()<loginViewDelegate>

@property (nonatomic, strong) LoginView *loginView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SENotificationCenter addObserver:self selector:@selector(loginSuccess) name:LOGINSUCCESS object:nil];
    [self createUI];
}

- (void)loginSuccess{
    [self dismissViewControllerAnimated:NO completion:nil];

}

#pragma mark - login delegate
//- (void)loginViewLeftTouch{
//    FindPasswordViewController *passwordVC = [[FindPasswordViewController alloc] init];
//    BaseNavigationController *passwordNav = [[BaseNavigationController alloc] initWithRootViewController:passwordVC];
//    [self presentViewController:passwordNav animated:YES completion:nil];
//}

//- (void)loginViewRightTouch{
//    WeakSelf(self);
//    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
//    BaseNavigationController *registerNav = [[BaseNavigationController alloc] initWithRootViewController:registerVC];
//    [self presentViewController:registerNav animated:YES completion:nil];
//    registerVC.registerSuccess = ^(id parameter) {
//
//        SetPasswordViewController *setPVC = [[SetPasswordViewController alloc] init];
//        setPVC.mobile = parameter;
//        [self presentViewController:setPVC animated:YES completion:nil];
//        setPVC.setPasswordSuccess = ^(id parameter) {
//            [weakself.loginView autoLoginByPassword:parameter];
//        };
//    };
//}

- (void)loginViewLoginTouch:(id)param{
    LoginNextViewController *nextVC = [[LoginNextViewController alloc] init];
    nextVC.mobileParam = param;
    [self.navigationController pushViewController:nextVC animated:YES];
    [UMAnalyticsHelper event:login_xyb];
}

- (void)dismiss:(id)param{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - init
- (LoginView *)loginView{
    if (!_loginView) {
        _loginView = [[LoginView alloc] initWithLoginType:LoginCheckPhoneType];
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
