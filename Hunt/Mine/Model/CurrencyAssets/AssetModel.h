//
//  AssetModel.h
//  Hunt
//
//  Created by 杨明 on 2018/9/17.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseModel.h"
#import "CoinRanksModel.h"

/**
 币资产model
 */
@interface Asset : BaseModel

/* id */
@property (nonatomic, copy) NSString *ID;
/* 持有数量 */
@property (nonatomic, assign) NSInteger quantity;
/* 净投入 */
@property (nonatomic, assign) CGFloat cost;
/* 利润 */
@property (nonatomic, assign) CGFloat profit;
/* 市值 */
@property (nonatomic, assign) CGFloat marketCap;
/* 市值占总资产的比例 */
@property (nonatomic, assign) CGFloat marketCapProportion;
/* 今日资产增幅 */
@property (nonatomic, assign) CGFloat changeRate;
/* 当前币价格 */
@property (nonatomic, assign) CGFloat price;
/* 今日资产增量 */
@property (nonatomic, assign) CGFloat changeAmount;
/* 买入均价 */
@property (nonatomic, assign) double avgBuyPrice;
/* 卖出均价 */
@property (nonatomic, assign) double avgSalePrice;
/* coin */
@property (nonatomic, strong) CoinRanksModel *coin;

//删除币资产
+(NSURLSessionDataTask*)remove_asset:(NSDictionary *)option
                             Success:(void (^)(NSString *item))success
                             Failure:(void (^)(NSError *error))failue;

//资产总览
+(NSURLSessionDataTask*)asset_assets_overall:(NSDictionary *)option
                                     Success:(void (^)(Asset *item))success
                                     Failure:(void (^)(NSError *error))failue;

@end


@interface AssetModel : BaseModel

/* assets */
@property (nonatomic, strong) NSArray *assets;
/* overall */
@property (nonatomic, strong) Asset *overall;

//资产总览和清单
+(NSURLSessionDataTask*)asset_assets:(NSDictionary *)option
                             Success:(void (^)(AssetModel *item))success
                             Failure:(void (^)(NSError *error))failue;

@end
