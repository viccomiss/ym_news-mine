//
//  SEUserDefaults.h
//  SuperEducation
//
//  Created by 123 on 2017/2/24.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface SEUserDefaults : NSObject
+(instancetype)shareInstance;

-(void)saveUserModel:(UserModel*)model;
-(UserModel*)getUserModel;
-(BOOL)userIsLogin;
-(void)userLogout;
-(void)saveSesstionId;

//下载应用弹框
-(void)saveProjectPrompt:(BOOL)touch;
-(BOOL)getProjectPrompt;

//应用下载控制
-(void)saveOtaRestricted:(NSDictionary *)ota;
-(NSDictionary *)getOtaRestricted;

//存取糖果积分
-(void)saveCandyPoint:(CGFloat)point;
-(CGFloat)getCandyPoint;


-(void)saveAreaCode:(NSString *)code;
-(NSString *)getAreaCode;
- (void)setUserLocalAvatar:(NSString *)imageKey;
- (NSString *)getUserLocalAvatarKey;

//分享url
-(void)saveShareCode:(NSString *)code;
-(UIImage *)getShareCode:(CGSize)size;

//红涨绿跌颜色
- (UIColor *)getRiseOrFallColor:(RoseOrFallType)type;

//存红涨绿跌
- (void)saveRGDisplay:(RoseOrFallType)type;

//取红涨绿跌
- (RoseOrFallType)getRGDisplayType;

//存deviceToken
-(void)saveDeviceToken:(NSString *)deviceToken;
-(NSString *)getDeviceToken;

@end
