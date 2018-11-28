//
//  UserModel.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/6.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "BaseModel.h"

@interface settings : BaseModel

/* skin */
@property (nonatomic, assign) ThemeType skin;
/* rgDisplay */
@property (nonatomic, assign) RoseOrFallType rgDisplay;
/* currency */
@property (nonatomic, copy) NSString *currency;
/* locale */
@property (nonatomic, copy) NSString *locale;

@end

@interface session : BaseModel

/* expiryTime */
@property (nonatomic, assign) NSInteger expiryTime;
/* id */
@property (nonatomic, copy) NSString *ID;

@end

@interface user : BaseModel

/* createdAt */
@property (nonatomic, assign) NSInteger createdAt;
/* id */
@property (nonatomic, copy) NSString *ID;
/* code */
@property (nonatomic, copy) NSString *code;
/* mobile */
@property (nonatomic, copy) NSString *mobile;
/* nickname */
@property (nonatomic, copy) NSString *nickname;
/* avatar */
@property (nonatomic, copy) NSString *avatar;

@end

@interface UserModel : BaseModel

/* user */
@property (nonatomic, strong) user *user;
/* session */
@property (nonatomic, strong) session *session;
/* set */
@property (nonatomic, strong) settings *settings;

//获取设置
+(NSURLSessionDataTask*)usr_setting_get:(NSDictionary *)option
                                Success:(void (^)(NSString *code))success
                                Failure:(void (^)(NSError *error))failue;

//修改设置
+(NSURLSessionDataTask*)usr_setting_update:(NSDictionary *)option
                                   Success:(void (^)(NSString *code))success
                                   Failure:(void (^)(NSError *error))failue;

//查看手机号是否已被注册
+(NSURLSessionDataTask*)is_mobile_registered:(NSDictionary *)option
                                     Success:(void (^)(BOOL isRegister))success
                                     Failure:(void (^)(NSError *error))failue;

//发送登录验证码
+(NSURLSessionDataTask*)send_signin_code:(NSDictionary *)option
                                 Success:(void (^)(NSString *code))success
                                 Failure:(void (^)(NSError *error))failue;

//发送注册验证码
+(NSURLSessionDataTask*)send_signup_code:(NSDictionary *)option
                                 Success:(void (^)(NSString *code))success
                                 Failure:(void (^)(NSError *error))failue;

//注册
+(NSURLSessionDataTask*)signup:(NSDictionary *)option
                       Success:(void (^)(NSString *code))success
                       Failure:(void (^)(NSError *error))failue;

//登录
+(NSURLSessionDataTask*)signin:(NSDictionary *)option
                       Success:(void (^)(NSString *code))success
                       Failure:(void (^)(NSError *error))failue;

//设置密码
+(NSURLSessionDataTask*)set_password:(NSDictionary *)option
                             Success:(void (^)(NSString *code))success
                             Failure:(void (^)(NSError *error))failue;

//密码登录
+(NSURLSessionDataTask*)password_signin:(NSDictionary *)option
                                Success:(void (^)(NSString *user))success
                                Failure:(void (^)(NSError *error))failue;



//找回密码
+(NSURLSessionDataTask*)verify_password:(NSDictionary *)option
                                Success:(void (^)(NSString *code))success
                                Failure:(void (^)(NSError *error))failue;

//修改密码
+(NSURLSessionDataTask*)update_password:(NSDictionary *)option
                                Success:(void (^)(NSString *code))success
                                Failure:(void (^)(NSError *error))failue;

//修改昵称
+(NSURLSessionDataTask*)update_nickname:(NSDictionary *)option
                                Success:(void (^)(NSString *code))success
                                Failure:(void (^)(NSError *error))failue;

//获取我的邀请信息
+(NSURLSessionDataTask*)invite_info:(NSDictionary *)option
                            Success:(void (^)(id responseObject))success
                            Failure:(void (^)(NSError *error))failue;

//联系我们
+(NSURLSessionDataTask*)contact_us:(NSDictionary *)option
                           Success:(void (^)(id responseObject))success
                           Failure:(void (^)(NSError *error))failue;

//上传头像
+(NSURLSessionDataTask*)updateHeaderImv:(NSDictionary *)option
                              imageData:(NSData *)imageData
                                Success:(void (^)(id responeObject))success
                                Failure:(void (^)(NSError *error))failue;

@end
