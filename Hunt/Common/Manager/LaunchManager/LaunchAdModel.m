//
//  LaunchAdModel.m
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 2016/6/28.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd
//  广告数据模型
#import "LaunchAdModel.h"

@implementation LaunchAdModel
MJCodingImplementation

+(NSURLSessionDataTask*)usr_splash_home:(NSDictionary *)option
                                Success:(void (^)(LaunchAdModel *item))success
                                Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_SPLASH_HOME parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([LaunchAdModel mj_objectWithKeyValues:[[responseObject jk_dictionaryForKey:@"result"] jk_dictionaryForKey:@"splash"]]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end

@implementation SplashesModel
MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"splashes" : [LaunchAdModel class]};
}

+(NSURLSessionDataTask*)usr_splash_splashes:(NSDictionary *)option
                                    Success:(void (^)(SplashesModel *item))success
                                    Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_SPLASH_SPLASHES parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([SplashesModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}



@end
