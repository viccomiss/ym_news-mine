//
//  UserModel.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/6.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "UserModel.h"
#import "SEUserDefaults.h"
#import "AliOSSManager.h"
#import "NSString+JLAdd.h"
#import "AppInfo.h"

@implementation settings
MJCodingImplementation

@end

@implementation user
MJCodingImplementation

@end

@implementation session
MJCodingImplementation

@end

@implementation UserModel
MJCodingImplementation



//获取设置
+(NSURLSessionDataTask*)usr_setting_get:(NSDictionary *)option
                                     Success:(void (^)(NSString *code))success
                                     Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_SETTINGS_GET parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        [self reloadUserSettings:responseObject];

        success([responseObject jk_stringForKey:@"errcode"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//修改设置
+(NSURLSessionDataTask*)usr_setting_update:(NSDictionary *)option
                                Success:(void (^)(NSString *code))success
                                Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_SETTINGS_UPDATE parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        [self reloadUserSettings:responseObject];
        
        success([responseObject jk_stringForKey:@"errcode"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//查看手机号是否已被注册
+(NSURLSessionDataTask*)is_mobile_registered:(NSDictionary *)option
                                Success:(void (^)(BOOL isRegister))success
                                Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USER_IS_MOBILE_REGISTERED parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([responseObject jk_boolForKey:@"result"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//密码登录
//+(NSURLSessionDataTask*)password_signin:(NSDictionary *)option
//                      Success:(void (^)(NSString *user))success
//                      Failure:(void (^)(NSError *error))failue{
//
//    return [APIManager SafePOST:URI_PASSWORD_SIGNIN parameters:option success:^(NSURLResponse *respone, id responseObject) {
//
//        NSDictionary *result = [responseObject jk_dictionaryForKey:@"result"];
//        UserModel *user = [UserModel mj_objectWithKeyValues:[result jk_dictionaryForKey:@"profile"]];
//        user.token = [result jk_stringForKey:@"token"];
//        [[SEUserDefaults shareInstance]saveUserModel:user];
//
//        success([responseObject jk_stringForKey:@"errcode"]);
//
//    } failure:^(NSURLResponse *respone, NSError *error) {
//        failue(error);
//    }];
//}

//登录
+(NSURLSessionDataTask*)signin:(NSDictionary *)option
                                Success:(void (^)(NSString *code))success
                                Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_SIGNIN parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        [self reloadLocalUserModel:responseObject];
        
        success([responseObject jk_stringForKey:@"errcode"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//修改昵称
+(NSURLSessionDataTask*)update_nickname:(NSDictionary *)option
                                Success:(void (^)(NSString *code))success
                                Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_USER_UPDATE_NICKNAME parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        [self reloadUserInfo:responseObject];

        success([responseObject jk_stringForKey:@"errcode"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//存user全部信息
+ (void)reloadLocalUserModel:(id)responseObject{
    UserModel *user = [UserModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]];
    [[SEUserDefaults shareInstance]saveUserModel:user];
}

//存user基本信息
+ (void)reloadUserInfo:(id)responseObject{
    UserModel *u = [[SEUserDefaults shareInstance] getUserModel];
    user *us = [user mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]];
    u.user = us;
    [[SEUserDefaults shareInstance]saveUserModel:u];
}

//存user设置信息
+ (void)reloadUserSettings:(id)responseObject{
    UserModel *u = [[SEUserDefaults shareInstance] getUserModel];
    settings *s = [settings mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]];
    u.settings = s;
    [[SEUserDefaults shareInstance]saveUserModel:u];
}

//注册
+(NSURLSessionDataTask*)signup:(NSDictionary *)option
                       Success:(void (^)(NSString *code))success
                       Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_SIGNUP parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        [self reloadLocalUserModel:responseObject];
        
        success([responseObject jk_stringForKey:@"errcode"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//发送注册验证码
+(NSURLSessionDataTask*)send_signup_code:(NSDictionary *)option
                                 Success:(void (^)(NSString *code))success
                                 Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_SEND_SIGNUP_CODE parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        NSString *result = [responseObject jk_stringForKey:@"errcode"];
        
        success(result);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//发送登录验证码
+(NSURLSessionDataTask*)send_signin_code:(NSDictionary *)option
                                 Success:(void (^)(NSString *code))success
                                 Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_SEND_SIGNIN_CODE parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        NSString *result = [responseObject jk_stringForKey:@"errcode"];
        
        success(result);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}


////找回密码
//+(NSURLSessionDataTask*)verify_password:(NSDictionary *)option
//                      Success:(void (^)(NSString *code))success
//                      Failure:(void (^)(NSError *error))failue{
//    return [APIManager SafePOST:URI_VERIFY_PASSWORD parameters:option success:^(NSURLResponse *respone, id responseObject) {
//
//        success([responseObject jk_stringForKey:@"errcode"]);
//
//    } failure:^(NSURLResponse *respone, NSError *error) {
//        failue(error);
//    }];
//}
//
////修改密码
//+(NSURLSessionDataTask*)update_password:(NSDictionary *)option
//                                Success:(void (^)(NSString *code))success
//                                Failure:(void (^)(NSError *error))failue{
//    return [APIManager SafePOST:URI_USER_UPDATE_PASSWORD parameters:option success:^(NSURLResponse *respone, id responseObject) {
//
//        success([responseObject jk_stringForKey:@"errcode"]);
//
//    } failure:^(NSURLResponse *respone, NSError *error) {
//        failue(error);
//    }];
//}

//设置密码
//+(NSURLSessionDataTask*)set_password:(NSDictionary *)option
//                             Success:(void (^)(NSString *code))success
//                             Failure:(void (^)(NSError *error))failue{
//    return [APIManager SafePOST:URI_SET_PASSWORD parameters:option success:^(NSURLResponse *respone, id responseObject) {
//
//        success([responseObject jk_stringForKey:@"errcode"]);
//
//    } failure:^(NSURLResponse *respone, NSError *error) {
//        failue(error);
//    }];
//}

//我的邀请码
+(NSURLSessionDataTask*)user_invite:(NSDictionary *)option
                                   Success:(void (^)(id responseObject))success
                                   Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_USER_INVITE parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([responseObject jk_dictionaryForKey:@"result"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//联系我们
+(NSURLSessionDataTask*)contact_us:(NSDictionary *)option
                            Success:(void (^)(id responseObject))success
                            Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_USR_USER_CONTACT_H5 parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([responseObject jk_stringForKey:@"result"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//获取我的邀请信息
+(NSURLSessionDataTask*)invite_info:(NSDictionary *)option
                           Success:(void (^)(id responseObject))success
                           Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_USR_USER_INVITE_INFO parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([responseObject jk_dictionaryForKey:@"result"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}


//获取用户基本资料
+(NSURLSessionDataTask*)user_profile:(NSDictionary *)option
                              Success:(void (^)(id responseObject))success
                              Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_USER_PROFILE parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        [self reloadUserInfo:responseObject];
        
        success([responseObject jk_stringForKey:@"errcode"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//修改用户头像
+(NSURLSessionDataTask*)update_avatar:(NSDictionary *)option
                             Success:(void (^)(id responseObject))success
                             Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_USER_UPDATE_AVATAR parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//上传头像
+(NSURLSessionDataTask*)updateHeaderImv:(NSDictionary *)option
                              imageData:(NSData *)imageData
                                Success:(void (^)(id responeObject))success
                                Failure:(void (^)(NSError *error))failue{
    return [APIManager SafePOST:URI_USR_FILE_UPLOAD_TOKEN parameters:option success:^(NSURLResponse *respone, id responseObject) {
        //获取ali参数成功
        //上传
        NSDictionary *backData =  [responseObject jk_dictionaryForKey:@"result"];
        [EasyLoadingView showLoading];
        
        AliOSSManager  *ossManager = [AliOSSManager sharedInstance];
        [ossManager setupEnvironmentWith:backData];
        [ossManager uploadObjectAsync:imageData fileType:FileTypeImage backBlock:^(id parameter) {
            NSDictionary *dict = @{@"vendor":backData[@"vendor"],@"bucket":backData[@"bucket"],@"key":parameter};
            NSDictionary * para =@{@"avatar":[dict mj_JSONString]};
            //更新后台
            [UserModel update_avatar:@{@"avatar":[backData jk_stringForKey:@"url"]}Success:^(id res) {
                //把图片塞到SDImageCache里
                SDImageCache *cache = [SDImageCache sharedImageCache];
                //模拟
                [cache storeImage:[UIImage imageWithData:imageData] forKey:HeaderCachePath];
                [[SEUserDefaults shareInstance] setUserLocalAvatar:HeaderCachePath];
                
                [self reloadUserInfo:res];
                
            } Failure:^(NSError *error) {
                
            }];
            
        }];
        
        success(responseObject);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
