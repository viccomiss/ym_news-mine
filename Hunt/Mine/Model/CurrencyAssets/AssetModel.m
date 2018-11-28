//
//  AssetModel.m
//  Hunt
//
//  Created by 杨明 on 2018/9/17.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "AssetModel.h"

@implementation Asset

+(NSURLSessionDataTask*)remove_asset:(NSDictionary *)option
                             Success:(void (^)(NSString *item))success
                             Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_ASSET_REMOVE_ASSET parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([responseObject jk_stringForKey:@"errcode"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

+(NSURLSessionDataTask*)asset_assets_overall:(NSDictionary *)option
                             Success:(void (^)(Asset *item))success
                             Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_ASSET_ASSETS_OVERALL parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([Asset mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end

@implementation AssetModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"assets" : [Asset class]};
}

+(NSURLSessionDataTask*)asset_assets:(NSDictionary *)option
                         Success:(void (^)(AssetModel *item))success
                         Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_ASSET_ASSETS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([AssetModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
