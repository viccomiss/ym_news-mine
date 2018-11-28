//
//  LoginNextViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/23.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "LoginNextViewController.h"
#import "LoginView.h"

@interface LoginNextViewController ()<loginViewDelegate>

@property (nonatomic, strong) LoginView *loginView;

@end

@implementation LoginNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadNavigationBar:YES];
    
    [self createUI];
}

#pragma mark - login delegate
- (void)dismiss:(id)param{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.loginView.mobileParam = self.mobileParam;
}

#pragma mark - init
- (LoginView *)loginView{
    if (!_loginView) {
        BOOL reg = [[self.mobileParam jk_numberForKey:@"reg"] boolValue];
        _loginView = [[LoginView alloc] initWithLoginType:!reg ? LoginRegisterType : LoginCodeType];
        _loginView.delegate = self;
    }
    return _loginView;
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
