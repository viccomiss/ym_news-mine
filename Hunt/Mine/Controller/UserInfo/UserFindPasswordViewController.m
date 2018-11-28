//
//  UserFindPasswordViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/7.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "UserFindPasswordViewController.h"
#import "LoginView.h"
#import "LoginViewController.h"
#import "CommonUtils.h"

@interface UserFindPasswordViewController ()<loginViewDelegate>

@property (nonatomic, strong) LoginView *loginView;

@end

@implementation UserFindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = MobileFindPassword;
    [self createUI];
}

#pragma mark - login delegate
- (void)loginViewLeftTouch{
    
}

- (void)loginViewRightTouch{
    
}

- (void)dismiss:(id)param{
    [self.navigationController popToRootViewControllerAnimated:YES];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BaseNavigationController *loginNav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [[CommonUtils currentViewController] presentViewController:loginNav animated:YES completion:nil];
    });
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
        _loginView = [[LoginView alloc] initWithLoginType:LoginUserFindPasswordType];
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
