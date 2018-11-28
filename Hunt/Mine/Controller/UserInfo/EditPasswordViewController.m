//
//  EditPasswordViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/7.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "LoginView.h"
#import "UserFindPasswordViewController.h"

@interface EditPasswordViewController ()<loginViewDelegate>

@property (nonatomic, strong) LoginView *loginView;

@end

@implementation EditPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = EditPassword;
    [self createUI];
}

#pragma mark - login delegate
- (void)loginViewLeftTouch{
    
}

- (void)loginViewRightTouch{
    UserFindPasswordViewController *findVC = [[UserFindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findVC animated:YES];
}

- (void)dismiss:(id)param{
    [self.navigationController popViewControllerAnimated:YES];
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
        _loginView = [[LoginView alloc] initWithLoginType:LoginEditPasswordType];
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
