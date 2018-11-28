//
//  TransactionsModel.h
//  Hunt
//
//  Created by 杨明 on 2018/9/17.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseModel.h"
#import "ExchangeModel.h"
#import "AssetModel.h"

/**
 交易记录
 */
@interface Transaction : BaseModel

/* 单价 or 总价 */
@property (nonatomic, assign) TransactionUNitOrTotalType unitOrTotal;
/* id */
@property (nonatomic, copy) NSString *ID;
/* type */
@property (nonatomic, assign) TransactionType type;
/* time */
@property (nonatomic, assign) NSInteger time;
/* price */
@property (nonatomic, copy) NSString *price;
/* totalPrice */
@property (nonatomic, assign) CGFloat totalPrice;
/* 资产单价price */
@property (nonatomic, assign) CGFloat assetPrice;
/* 货币单位 */
@property (nonatomic, copy) NSString *priceCurrency;
/* quantity */
@property (nonatomic, assign) NSInteger quantity;
/* walletAddr */
@property (nonatomic, copy) NSString *walletAddr;
/* notes */
@property (nonatomic, copy) NSString *notes;
/* cost */
@property (nonatomic, assign) CGFloat cost;
/* exchange */
@property (nonatomic, strong) ExchangeModel *exchange;
/* asset */
@property (nonatomic, strong) Asset *asset;
/* coinId */
@property (nonatomic, copy) NSString *coinId;
//交易所or钱包
@property (nonatomic, assign) BOOL isExchange;

//保存交易记录
+(NSURLSessionDataTask*)asset_save_transaction:(NSDictionary *)option
                                       Success:(void (^)(NSString *code))success
                                       Failure:(void (^)(NSError *error))failue;

//删除交易记录
+(NSURLSessionDataTask*)asset_remove_transaction:(NSDictionary *)option
                                         Success:(void (^)(NSString *code))success
                                         Failure:(void (^)(NSError *error))failue;

@end

@interface TransactionsModel : BaseModel

/* marker */
@property (nonatomic, copy) NSString *marker;
/* list */
@property (nonatomic, strong) NSArray *list;

//交易记录列表
+(NSURLSessionDataTask*)asset_transactions:(NSDictionary *)option
                                   Success:(void (^)(TransactionsModel *item))success
                                   Failure:(void (^)(NSError *error))failue;

@end
