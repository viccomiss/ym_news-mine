//
//  AppDelegate.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/29.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "BaseNavigationController.h"
#import "BaseTabBarControllerConfig.h"
#import "LocalizedHelper.h"
#import "SEUserDefaults.h"

//share
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//微信SDK头文件
#import "WXApi.h"

#import "AppInfo.h"

#import "StartPageView.h"

@interface AppDelegate ()<UITabBarControllerDelegate,CYLTabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setDefaultLanguage];
    [self setupIQkeyborad];
    [self setupLogin];//登录设置
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self monitorNetwork];
    [self registerPush:application];
    [self addNotification];
    [self registerShare];
    [self setUMCommon];
    [self loadShareData];
    
    [self.window makeKeyAndVisible];
    
//    [self setStartPageView];
    
    return YES;
}

//启动页
- (void)setStartPageView{
    
    StartPageView *startView = [[StartPageView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
    [startView show];
}

//友盟统计
- (void)setUMCommon{
    [UMAnalyticsHelper UMAnalyticStart];
}

//分享url
- (void)loadShareData{
    if ([[SEUserDefaults shareInstance] userIsLogin]) {
        [UserModel invite_info:@{} Success:^(id responseObject) {
            
            NSString *url = [responseObject jk_stringForKey:@"url"];
            [[SEUserDefaults shareInstance] saveShareCode:url];
            
        } Failure:^(NSError *error) {
            
        }];
    }
}

- (void)addNotification{
    [SENotificationCenter addObserver:self selector:@selector(changeLanguage:) name:LANGUAGECHANGE object:nil];
    [SENotificationCenter addObserver:self selector:@selector(loginSuccess) name:LOGINSUCCESS object:nil];
}

//登录成功
- (void)loginSuccess{
    [self loadShareData];
}

//注册推送通知
- (void)registerPush:(UIApplication *)application{
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
}

//设置分享
- (void)registerShare{
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformSubTypeWechatSession),
                                        @(SSDKPlatformSubTypeWechatTimeline),
                                        @(SSDKPlatformTypeQQ),
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:KEY_WEIXIN_SSO_ID
                                       appSecret:KEY_WEIXIN_SECRET];
                 break;
                 
             default:
                 break;
         }
     }];
}

//语言
- (void)setDefaultLanguage{
    
    [[LocalizedHelper standardHelper] setUserLanguage:[[LocalizedHelper standardHelper] currentLanguage]];
}

- (void)changeLanguage:(NSNotification *)obj{
    NSString *str = obj.object;
    [[LocalizedHelper standardHelper] setUserLanguage:str];
    [self setupLogin];
}

- (void)setupIQkeyborad {
    [IQKeyboardManager sharedManager].enable=YES;
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [IQKeyboardManager sharedManager].canAdjustTextView = YES;
}

-(void)setupLogin{
    
    BaseTabBarControllerConfig *tabBarControllerConfig = [[BaseTabBarControllerConfig alloc] init];
    CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
    [self.window setRootViewController:tabBarController];
    tabBarController.delegate = self;

    [self customizeInterfaceWithTabBarController:tabBarController];
}

- (void)customizeInterfaceWithTabBarController:(CYLTabBarController *)tabBarController {
    
    [tabBarController hideTabBadgeBackgroundSeparator];
    //添加小红点
//    UIViewController *viewController = tabBarController.viewControllers[0];
//    UIView *tabBadgePointView0 = [UIView cyl_tabBadgePointViewWithClolor:[UIColor redColor] radius:4.5];
//    [viewController.tabBarItem.cyl_tabButton cyl_setTabBadgePointView:tabBadgePointView0];
//    [viewController cyl_showTabBadgePoint];
    
//    UIView *tabBadgePointView1 = [UIView cyl_tabBadgePointViewWithClolor:[UIColor redColor] radius:4.5];
//    @try {
//        [tabBarController.viewControllers[1] cyl_setTabBadgePointView:tabBadgePointView1];
//        [tabBarController.viewControllers[1] cyl_showTabBadgePoint];
//
//        UIView *tabBadgePointView2 = [UIView cyl_tabBadgePointViewWithClolor:[UIColor redColor] radius:4.5];
//        [tabBarController.viewControllers[2] cyl_setTabBadgePointView:tabBadgePointView2];
//        [tabBarController.viewControllers[2] cyl_showTabBadgePoint];
//
//
//        //添加提示动画，引导用户点击
//        [self addScaleAnimationOnView:tabBarController.viewControllers[2].cyl_tabButton.cyl_tabImageView repeatCount:20];
//    } @catch (NSException *exception) {}
}

#pragma mark - delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    
    if ([control cyl_isTabButton]) {
        //更改红标状态
        if ([[self cyl_tabBarController].selectedViewController cyl_isShowTabBadgePoint]) {
            [[self cyl_tabBarController].selectedViewController cyl_removeTabBadgePoint];
        }
        
        animationView = [control cyl_tabImageView];
    }
    
    // 即使 PlusButton 也添加了点击事件，点击 PlusButton 后也会触发该代理方法。
    if ([control cyl_isPlusButton]) {
        UIButton *button = CYLExternPlusButton;
        animationView = button.imageView;
    }
    
    //点击动效
//    if ([self cyl_tabBarController].selectedIndex % 2 == 0) {
//        [self addScaleAnimationOnView:animationView repeatCount:1];
//    } else {
//        [self addRotateAnimationOnView:animationView];
//    }
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    // 针对旋转动画，需要将旋转轴向屏幕外侧平移，最大图片宽度的一半
    // 否则背景与按钮图片处于同一层次，当按钮图片旋转时，转轴就在背景图上，动画时会有一部分在背景图之下。
    // 动画结束后复位
    animationView.layer.zPosition = 65.f / 2;
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}

- (void)monitorNetwork{
    //重连网络成功刷新用户信息（数据表+IM）
    [SENotificationCenter addObserver:self selector:@selector(reconnectionSuccess) name:RECONNECTIONSUCCESS object:nil];
    [SENotificationCenter addObserver:self selector:@selector(networkBreak) name:NETBREAK object:nil];
}

- (void)reconnectionSuccess{
    //重连成功
    
}

- (void)networkBreak{

}

//首屏固定竖屏 进入APP允许横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *pushToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[SEUserDefaults shareInstance] saveDeviceToken:pushToken];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //进入前台
    if ([AppInfo getDeviceId].length != 0) {
        [[AppInfo shareInstance] deviceSignin];
    }else{
        [[AppInfo shareInstance] registerDevice];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
