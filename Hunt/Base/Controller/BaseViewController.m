//
//  BaseViewController.m
//  UNIS-LEASE
//
//  Created by runlin on 2016/10/24.
//  Copyright © 2016年 unis. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"

@interface BaseViewController ()


@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.closeNav) {
        [self reloadNavigationBar:NO];
    }
        
    self.view.backgroundColor = BackGroundColor;
    self.edgesForExtendedLayout = UIRectEdgeTop;

    self.automaticallyAdjustsScrollViewInsets = NO;
//    //导航栏背景图片偏移64
//    self.extendedLayoutIncludesOpaqueBars = YES;
    
    [UIViewController attemptRotationToDeviceOrientation];
    [self setUpUI];
    
    //注册主题通知
    [self registerThemeNotification];
    
    self.isFirstEnter = YES;
}

//register
- (void)registerThemeNotification{
    [SENotificationCenter addObserver:self selector:@selector(reloadTheme:) name:SKINCHANGESUCCESS object:nil];
}

- (void)reloadTheme:(NSNotification *)notification{
    
    
}

#pragma mark - UI
- (void)setUpUI{
    
    self.noDataView = [[NoDataView alloc] init];
    self.noDataView.hidden = YES;
    [self.view addSubview:self.noDataView];
}

//添加logo nav
- (void)addLogoNavView{
    
    BaseImageView *logoView = [[BaseImageView alloc] initWithFrame:CGRectMake((MAINSCREEN_WIDTH - 139) / 2, (NavbarH - StatusBarH - 30) / 2, 139, 30)];
    logoView.image = ImageName(@"logo");
    [self.navigationBar addSubview:logoView];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

//横竖屏
- (void)playPortrait:(BOOL)isLandscape{
    
    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val;
        if (isLandscape) {
            val = UIInterfaceOrientationLandscapeLeft; //横屏
        }else{
            val = UIInterfaceOrientationPortrait;//竖屏
        }
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
    }
}

- (void)dealloc{
    
    [SENotificationCenter removeObserver:self name:SKINCHANGESUCCESS object:nil];
}

@end
