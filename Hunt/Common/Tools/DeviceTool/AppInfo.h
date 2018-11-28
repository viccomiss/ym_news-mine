//
//  AppInfo.h
//  SuperEducation
//
//  Created by 123 on 2017/3/13.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface File : BaseModel

/* seize */
@property (nonatomic, assign) CGFloat size;
/* url */
@property (nonatomic, copy) NSString *url;

@end

@interface AppVersionInfo : BaseModel

/* version */
@property (nonatomic, copy) NSString *version;
/* releaseNotes */
@property (nonatomic, copy) NSString *releaseNotes;
/* file */
@property (nonatomic, strong) File *file;
/* url */
@property (nonatomic, copy) NSString *url;
/* force */
@property (nonatomic, assign) BOOL force;


@end

@interface AppInfo : NSObject

/* appInfo */
@property (nonatomic, strong) AppVersionInfo *appInfo;

+(AppInfo*)shareInstance;
+(NSString *)currentVersion;
+(CGFloat)currentIOSVersion;

//设备信息
+ (NSString *)getClient;

//设备id
+ (NSString *)getDeviceId;

//注册设备
- (void)registerDevice;

//登录设备
- (void)deviceSignin;

/**
 相机权限是否可用
 */
+ (BOOL)checkCameraAuthorizationStatus;
/**
 相册权限是否可用
 */
+ (BOOL)checkPhotoAuthorizationStatus;

/**
 判断麦克风
 */
+ (BOOL)checkMicAuthorizationStatus;

//前往系统设置界面
+ (void)goToSettting;

//跳转描述文件与设备管理
+ (void)goManagedConfigurationList;

//跳转到wifi
+ (void)goToWiFi;

//跳转至微信
+(void)jumpToWechat;

//检测是否是第一次进入APP
+ (BOOL)isFirstLoad;

+ (BOOL)isUserNotificationEnable;

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改  iOS版本 >=8.0 处理逻辑
+ (void)goToAppSystemSetting;

//版本升级
+ (void)installRainbowWithUrl:(NSString *)url;

//安装程序
+ (void)installAppWithUrl:(NSString *)url;

//更新升级
+ (void)updateAppWithUrl:(NSString *)url;

//检查新版本
+ (void)checkVersion;

//挂起新版本更新
+(void)saveUpdateHang:(NSString *)version;

//获取挂起状态
+(NSString *)getUpdateHang;


@end
