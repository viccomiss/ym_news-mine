//
//  AssetDetailModel.m
//  Hunt
//
//  Created by 杨明 on 2018/9/17.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "AssetDetailModel.h"

@implementation AssetDetailModel

+(NSURLSessionDataTask*)asset_asset:(NSDictionary *)option
                             Success:(void (^)(AssetDetailModel *item))success
                             Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_ASSET_ASSET parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([AssetDetailModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
