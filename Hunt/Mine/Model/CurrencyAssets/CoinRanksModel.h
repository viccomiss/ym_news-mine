//
//  CoinRanksModel.h
//  Hunt
//
//  Created by 杨明 on 2018/8/3.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseModel.h"

/**
 币行情Model
 */
@interface names : BaseModel

/* zh_CN */
@property (nonatomic, copy) NSString *zh_CN;

@end

@interface property : BaseModel

/* key */
@property (nonatomic, copy) NSString *key;
/* key */
@property (nonatomic, copy) NSString *value;
/* key */
@property (nonatomic, copy) NSString *name;
/* text */
@property (nonatomic, copy) NSString *text;


@end

@interface CoinRanksModel : BaseModel

/* iconUrl */
@property (nonatomic, copy) NSString *logo;
/* coinId */
@property (nonatomic, copy) NSString *ID;
/* 币英文名 */
@property (nonatomic, copy) NSString *symbol;
/* 最高价 */
@property (nonatomic, assign) CGFloat high;
/* 最低价 */
@property (nonatomic, assign) CGFloat low;
/* 换手率 */
@property (nonatomic, assign) CGFloat turnoverRate;
/* 涨跌幅 */
@property (nonatomic, assign) CGFloat changeRate;
/* 流通量 */
@property (nonatomic, assign) CGFloat circulatingSupply;
/* 市值 */
@property (nonatomic, assign) CGFloat marketCap;
/* 成交额 */
@property (nonatomic, assign) CGFloat turnover;
/* 最大量 */
@property (nonatomic, assign) CGFloat maxSupply;
/* 发行量 */
@property (nonatomic, assign) CGFloat totalSupply;
/* 币中文名 */
@property (nonatomic, strong) names *names;
/* name */
@property (nonatomic, copy) NSString *name;
/* 当前价格 */
@property (nonatomic, assign) CGFloat price;
/* 状态 */
@property (nonatomic, assign) NSInteger state;
/* 成交量 */
@property (nonatomic, assign) CGFloat volume;
/* collected */
@property (nonatomic, assign) CollectedType collected;
/* 详细介绍 */
@property (nonatomic, copy) NSString *detail;
/* 排行 */
@property (nonatomic, assign) NSInteger marketCapRank;
/* 其他属性 */
@property (nonatomic, strong) NSArray *properties;
/* 广告标识 */
@property (nonatomic, assign) BOOL ad;

//币详细
+(NSURLSessionDataTask*)coin_coin:(NSDictionary *)option
                          Success:(void (^)(CoinRanksModel *item))success
                          Failure:(void (^)(NSError *error))failue;

@end
