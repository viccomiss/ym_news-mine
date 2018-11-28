//
//  SEUserDefaults.m
//  SuperEducation
//
//  Created by 123 on 2017/2/24.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "SEUserDefaults.h"
#import "NSString+JLAdd.h"
#import "UIImage+JLAdd.h"

#define UserInfoModel @"userModel"
#define PhoneAreaCode @"areaCode"
#define Token @"token"
#define UserAvatarPath @"UserAvatarPath"
#define PromotionSettingPath @"PromotionSetting"
#define DeviceToken @"deviceToken"
#define RGDisplayKey @"RGDisplayKey"
#define ShareUrlKey @"ShareUrlKey"
#define CandyPoint @"CandyPoint"
#define OtaRestricted @"OtaRestricted"
#define ProjectPromptKey @"ProjectPromptKey"


@implementation SEUserDefaults
+(instancetype)shareInstance{
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc]init];
    });
    return shareInstance;
}

-(void)saveProjectPrompt:(BOOL)touch{
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:touch] forKey:ProjectPromptKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(BOOL)getProjectPrompt{
    NSNumber *touch = [[NSUserDefaults standardUserDefaults]objectForKey:ProjectPromptKey];
    return [touch boolValue];
}

-(void)saveOtaRestricted:(NSDictionary *)ota{
    
    [[NSUserDefaults standardUserDefaults]setObject:ota forKey:OtaRestricted];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSDictionary *)getOtaRestricted{
    NSMutableDictionary *ota = [[NSUserDefaults standardUserDefaults]objectForKey:OtaRestricted];
    if (ota == nil) {
        [ota setObject:@"1" forKey:@"ota"];
    }
    return ota;
}

-(void)saveUserModel:(UserModel*)model{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:UserInfoModel];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(UserModel*)getUserModel{
   NSData *data  =  [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoModel];
    UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return model;
}

-(void)saveSesstionId{
    UserModel *user = [self getUserModel];
    [[NSUserDefaults standardUserDefaults]setObject:user.session.ID forKey:Token];
}

-(void)saveDeviceToken:(NSString *)deviceToken{
    [[NSUserDefaults standardUserDefaults]setObject:deviceToken forKey:DeviceToken];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)getDeviceToken{
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:DeviceToken];
    return deviceToken.length == 0 ? @"" : deviceToken;
}

- (UIColor *)getRiseOrFallColor:(RoseOrFallType)type{
    RoseOrFallType localType = [self getRGDisplayType];
    if (localType == RoseType) {
        //红涨绿跌
        return type == RoseType ? BackRedColor : BackGreenColor;
    }else{
        //绿涨红跌
        return type == RoseType ? BackGreenColor : BackRedColor;
    }
}

- (void)saveRGDisplay:(RoseOrFallType)type{
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithUnsignedInteger:type] forKey:RGDisplayKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (RoseOrFallType)getRGDisplayType{
    NSNumber *type = [[NSUserDefaults standardUserDefaults] objectForKey:RGDisplayKey];
    return type == nil ? RoseType : [type unsignedIntegerValue];
}

-(BOOL)userIsLogin{
    UserModel *user = [self getUserModel];
    if (user.session.ID && [user.session.ID notEmptyOrNull]) {
        return YES;
    }else{
        return NO;
    }
}

//存糖果
-(void)saveCandyPoint:(CGFloat)point{
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithFloat:point] forKey:CandyPoint];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(CGFloat)getCandyPoint{
    NSNumber *point = [[NSUserDefaults standardUserDefaults]objectForKey:CandyPoint];
    return [point floatValue];
}

//分享url
-(void)saveShareCode:(NSString *)code{
    [[NSUserDefaults standardUserDefaults]setObject:code forKey:ShareUrlKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(UIImage *)getShareCode:(CGSize)size{
    NSString *code = [[NSUserDefaults standardUserDefaults]objectForKey:ShareUrlKey];
    return [UIImage QRcodeByUrlString:code size:size];
}

-(void)saveAreaCode:(NSString *)code{
    [[NSUserDefaults standardUserDefaults]setObject:code forKey:PhoneAreaCode];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)getAreaCode{
    NSString *code = [[NSUserDefaults standardUserDefaults]objectForKey:PhoneAreaCode];
    return code;
}
-(void)userLogout{
    //清空用户基本信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserInfoModel];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Token];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserAvatarPath];
}

- (void)setUserLocalAvatar:(NSString *)imageKey {
    [[NSUserDefaults standardUserDefaults] setObject:imageKey forKey:UserAvatarPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)getUserLocalAvatarKey {
    if ([self userIsLogin]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:UserAvatarPath];
    }
    return nil;
}
@end
