//
//  CoinRankListModel.m
//  Hunt
//
//  Created by 杨明 on 2018/8/27.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CoinRankListModel.h"

@implementation CoinRankListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list": [CoinRanksModel class]};
}


+(NSURLSessionDataTask*)coin_ranks:(NSDictionary *)option
                           Success:(void (^)(CoinRankListModel *item))success
                           Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_COIN_RANKS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        CoinRankListModel *model = [CoinRankListModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]];
        
        success(model);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//推荐币
+(NSURLSessionDataTask*)coin_recommended_coins:(NSDictionary *)option
                           Success:(void (^)(CoinRankListModel *item))success
                           Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_COIN_RECOMMENDED_COINS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        CoinRankListModel *model = [CoinRankListModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]];
        
        success(model);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//自选币详细列表
+(NSURLSessionDataTask*)coin_collected_coins:(NSDictionary *)option
                                       Success:(void (^)(CoinRankListModel *item))success
                                       Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_COIN_COLLECTED_COINS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        CoinRankListModel *model = [CoinRankListModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]];
        
        success(model);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//添加自选
+(NSURLSessionDataTask*)coin_add_collections:(NSDictionary *)option
                                     Success:(void (^)(NSString *code))success
                                     Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_COIN_ADD_COLLECTIONS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([responseObject jk_stringForKey:@"errcode"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//删除自选
+(NSURLSessionDataTask*)coin_remove_collections:(NSDictionary *)option
                                     Success:(void (^)(NSString *code))success
                                     Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_COIN_REMOVE_COLLECTIONS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([responseObject jk_stringForKey:@"errcode"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//自选ID列表
+(NSURLSessionDataTask*)coin_collections:(NSDictionary *)option
                                        Success:(void (^)(NSArray *coins))success
                                        Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_COIN_COLLECTIONS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([responseObject jk_arrayForKey:@"result"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//保存自选ID
+(NSURLSessionDataTask*)coin_save_collections:(NSDictionary *)option
                                 Success:(void (^)(NSString *code))success
                                 Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_COIN_SAVE_COLLECTIONS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([responseObject jk_stringForKey:@"errcode"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

//搜索币
+(NSURLSessionDataTask*)coin_search_coins:(NSDictionary *)option
                                      Success:(void (^)(CoinRankListModel *item))success
                                      Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_COIN_SEARCH_COINS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([CoinRankListModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}



@end
