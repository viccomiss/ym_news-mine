//
//  AppInfo.m
//  SuperEducation
//
//  Created by 123 on 2017/3/13.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "AppInfo.h"
#import "APIManager.h"
#import "Constant.h"
#import "NSDictionary+JKSafeAccess.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "NewBuildVersionView.h"
#import "SEUserDefaults.h"
#import "DeviceInfo.h"
#import "UserModel.h"
#import "SAMKeychain.h"
#import "NSString+JLAdd.h"
#import "DateManager.h"

//挂起更新状态
#define UpdateHang @"UpdateHang"
#define DeviceId @"deviceId"

@implementation File

@end

@implementation AppVersionInfo



@end

@implementation AppInfo
+(AppInfo*)shareInstance{
    static AppInfo *info = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [[AppInfo alloc]init];
    });

    return info;
}

+ (BOOL)isUserNotificationEnable { // 判断用户是否允许接收通知
    BOOL isEnable = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) { // iOS版本 >=8.0 处理逻辑
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    } else { // iOS版本 <8.0 处理逻辑
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        isEnable = (UIRemoteNotificationTypeNone == type) ? NO : YES;
    }
    return isEnable;
}

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改  iOS版本 >=8.0 处理逻辑
+ (void)goToAppSystemSetting {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:url options:@{} completionHandler:nil];
        } else {
            [application openURL:url];
        }
    }
}

+ (BOOL)isFirstLoad{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    
    if (!lastRunVersion) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    else if (![lastRunVersion isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    return NO;
}

+(void)jumpToWechat{
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    //先判断是否能打开该url
    if (canOpen)
    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
    }else {
        [EasyTextView showText:@"您还没有安转微信客户端\n请前往App Store下载"];
    }
}

+(NSString *)currentVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+(CGFloat)currentIOSVersion{
  return  [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (BOOL)checkPhotoAuthorizationStatus {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied) { //无权限
            return NO;
        }
    } else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) { //无权限
            return NO;

        }
    }
    return YES;
}

+ (BOOL)checkCameraAuthorizationStatus {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0) {
        AVAuthorizationStatus author =[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied) { //无权限
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkMicAuthorizationStatus {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0) {
        AVAuthorizationStatus author =[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied) { //无权限
            return NO;
        }
    }
    return YES;
}

+ (void)goToSettting{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (void)goManagedConfigurationList{
    NSString *url = @"http://rainb.oss-cn-hangzhou.aliyuncs.com/test/20181023/rainbow_dev_pro.mobileprovision";
    if (url) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}

+ (void)installRainbowWithUrl:(NSString *)url{
    if (url) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}

//安装应用
+ (void)installAppWithUrl:(NSString *)url{
    
    //前缀包含itms-service 协议弹出提示框
    if ([url hasPrefix:@"itms-services"]) {
        if (![[SEUserDefaults shareInstance] getProjectPrompt]) {
//            [InstallPromptView showPromptView];
        }
    }
    
    if (url) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}

+ (void)updateAppWithUrl:(NSString *)url{
    if (url) {
        NSString *u = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",url];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:u]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:u]];
        }
    }
}

+(void)saveUpdateHang:(NSString *)version{
    [[NSUserDefaults standardUserDefaults]setObject:version forKey:UpdateHang];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSString *)getUpdateHang{
    NSString *version = [[NSUserDefaults standardUserDefaults]objectForKey:UpdateHang];
    return version;
}

+ (void)checkVersion{
    
    UserModel *user = [[SEUserDefaults shareInstance] getUserModel];
    NSString *mobile = user.user.mobile.length == 0 ? @"" : [NSString stringWithFormat:@"mob/%@",user.user.mobile];
    NSString *appId = @"rainbow-ios-pgy";
    [AppInfo ota_check_update:@{@"appId" : appId, @"version" : [AppInfo currentVersion], @"deviceId" : mobile} Success:^(AppVersionInfo *item) {
        
        if (item.version) {
//            if (item.force || ![item.version isEqualToString:[AppInfo getUpdateHang]]) {
//            }
            [NewBuildVersionView showNewBuildVersionView:item];
        }
        
    } Failure:^(NSError *error) {
        
    }];
    
    if ([appId isEqualToString:@"rainbow-ios-appstore"]) {
        [AppInfo ota_restricted:appId];
    }
}

+ (void)ota_restricted:(NSString *)appId{
    
    //ota 限制
    if (![[[[SEUserDefaults shareInstance] getOtaRestricted] jk_stringForKey:@"version"] isEqualToString:[AppInfo currentVersion]]) {
        [AppInfo usr_ota_is_restricted:@{@"appId" : appId, @"version": [AppInfo currentVersion]} Success:^(NSString *result) {
            
            
        } Failure:^(NSError *error) {
            
        }];
    }
}

//是否功能受限版本
+(NSURLSessionDataTask*)usr_ota_is_restricted:(NSDictionary *)option
                                      Success:(void (^)(NSString *result))success
                                      Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_OTA_IS_RESTRICTED parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        NSMutableDictionary *otaDic = [NSMutableDictionary dictionary];
        [otaDic setObject:[responseObject jk_stringForKey:@"result"] forKey:@"ota"];
        [otaDic setObject:[AppInfo currentVersion] forKey:@"version"];
        [[SEUserDefaults shareInstance] saveOtaRestricted:otaDic];
        success([responseObject jk_stringForKey:@"result"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//检查新版本
+(NSURLSessionDataTask*)ota_check_update:(NSDictionary *)option
                                 Success:(void (^)(AppVersionInfo *item))success
                                 Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_USR_OTA_CHECK_UPDATE parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        AppVersionInfo *info = [AppVersionInfo mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]];
        [AppInfo shareInstance].appInfo = info;
        success(info);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//注册设备
- (void)registerDevice{
    NSMutableDictionary *Dic = [NSMutableDictionary dictionaryWithDictionary:[AppInfo codeParam]];
    [Dic setObject:[AppInfo getClient] forKey:@"client"];
    
    [APIManager SafePOST:URI_USR_DEVICE_CREATE parameters:Dic success:^(NSURLResponse *respone, id responseObject) {
        
        if ([[responseObject jk_stringForKey:@"errcode"] isEqualToString:@"0"]) {
            NSString *result = [responseObject jk_stringForKey:@"result"];
            [self saveDeviceId:result];
        }
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        
    }];
}

//登录设备
- (void)deviceSignin{
    
    [APIManager SafePOST:URI_USR_DEVICE_SIGNIN parameters:@{@"client" : [AppInfo getClient], @"deviceId": [AppInfo getDeviceId]} success:^(NSURLResponse *respone, id responseObject) {
        
        NSLog(@"登录设备成功 === %@",responseObject);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        
    }];
}

//存deviceId
- (void)saveDeviceId:(NSString *)deviceId
{
    //存到钥匙串
    [SAMKeychain setPassword:deviceId forService:@" "account:DeviceId];
    //存到沙盒
    [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:DeviceId];
    [[NSUserDefaults  standardUserDefaults] synchronize];
}

//获取deviceId
+ (NSString *)getDeviceId{
    NSString  *openUUID = [[NSUserDefaults standardUserDefaults] objectForKey:DeviceId];
    if (openUUID == nil || [openUUID isEqualToString:@""]) {
        openUUID = [SAMKeychain passwordForService:@" "account:DeviceId];
    }
    return openUUID;
}

+ (NSString *)getClient{
    
    NSString *platform = @"ios";
    NSString *name = [[APIManager generateUserAgent] subStringFrom:@";" to:@")"];
    NSString *pushToken = [[SEUserDefaults shareInstance] getDeviceToken];
    NSString *timezone = @"-8";
    NSString *locale = @"zh_Hans";
    NSString *version = @"";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    if (infoDictionary){
        
        // app版本
        version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    
    NSString *osVersion = [[APIManager generateUserAgent] subStringFrom:@"(" to:@";"];
    
    NSDictionary *clientDic = @{@"platform" : platform, @"name" : name, @"pushToken" : pushToken == nil ? @"" : pushToken, @"timezone" : timezone, @"locale" : locale, @"version" : version, @"osVersion" : osVersion};
    return [NSString dictionaryToJson:clientDic];
}

//code param
+ (NSDictionary *)codeParam{
    NSString *timestamp = [DateManager nowTimeStampString];
    NSString *p = @"ios";
    NSString *d = [[UIDevice currentDevice] systemName];
    NSString *v = [NSString stringWithFormat:@"%lu%@%lu%@%lu%@%@",(unsigned long)timestamp.length,timestamp,p.length,p,d.length,d,d];
    return @{@"mobile": d, @"t": timestamp, @"p": p, @"d": d, @"v": [v md5String]};
}


@end
