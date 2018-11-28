//
//  CoinRanksModel.m
//  Hunt
//
//  Created by 杨明 on 2018/8/3.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CoinRanksModel.h"

@implementation names


@end

@implementation property


@end

@implementation CoinRanksModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"properties": [property class]};
}

+(NSURLSessionDataTask*)coin_coin:(NSDictionary *)option
                           Success:(void (^)(CoinRanksModel *item))success
                           Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_COIN_COIN parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([CoinRanksModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
