//
//  RegisterViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/7.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginView.h"

@interface RegisterViewController ()<loginViewDelegate>

@property (nonatomic, strong) LoginView *loginView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

#pragma mark - login delegate
- (void)loginViewLeftTouch{
    
}

- (void)loginViewRightTouch{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismiss:(id)param{
    [self dismissViewControllerAnimated:YES completion:^{
        if (param != nil) {
            if (self.registerSuccess) {
                self.registerSuccess(param);
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
}

#pragma mark - init
- (LoginView *)loginView{
    if (!_loginView) {
        _loginView = [[LoginView alloc] initWithLoginType:LoginRegisterType];
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
