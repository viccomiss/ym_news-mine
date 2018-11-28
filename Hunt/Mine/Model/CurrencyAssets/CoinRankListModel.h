//
//  CoinRankListModel.h
//  Hunt
//
//  Created by 杨明 on 2018/8/27.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseModel.h"
#import "CoinRanksModel.h"

/**
 币列表
 */
@interface CoinRankListModel : BaseModel

/* market */
@property (nonatomic, copy) NSString *marker;
/* list */
@property (nonatomic, strong) NSArray *list;

//币行情列表
+(NSURLSessionDataTask*)coin_ranks:(NSDictionary *)option
                           Success:(void (^)(CoinRankListModel *item))success
                           Failure:(void (^)(NSError *error))failue;

//推荐币
+(NSURLSessionDataTask*)coin_recommended_coins:(NSDictionary *)option
                                       Success:(void (^)(CoinRankListModel *item))success
                                       Failure:(void (^)(NSError *error))failue;

//自选币详细列表
+(NSURLSessionDataTask*)coin_collected_coins:(NSDictionary *)option
                                     Success:(void (^)(CoinRankListModel *item))success
                                     Failure:(void (^)(NSError *error))failue;

//添加自选
+(NSURLSessionDataTask*)coin_add_collections:(NSDictionary *)option
                                     Success:(void (^)(NSString *code))success
                                     Failure:(void (^)(NSError *error))failue;

//删除自选
+(NSURLSessionDataTask*)coin_remove_collections:(NSDictionary *)option
                                        Success:(void (^)(NSString *code))success
                                        Failure:(void (^)(NSError *error))failue;

//自选ID列表
+(NSURLSessionDataTask*)coin_collections:(NSDictionary *)option
                                 Success:(void (^)(NSArray *coins))success
                                 Failure:(void (^)(NSError *error))failue;

//保存自选ID
+(NSURLSessionDataTask*)coin_save_collections:(NSDictionary *)option
                                      Success:(void (^)(NSString *code))success
                                      Failure:(void (^)(NSError *error))failue;

//搜索币
+(NSURLSessionDataTask*)coin_search_coins:(NSDictionary *)option
                                  Success:(void (^)(CoinRankListModel *item))success
                                  Failure:(void (^)(NSError *error))failue;
@end
