//
//  AssetDetailModel.h
//  Hunt
//
//  Created by 杨明 on 2018/9/17.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseModel.h"
#import "AssetModel.h"
#import "TransactionsModel.h"

/**
 资产详细model
 */
@interface AssetDetailModel : BaseModel

/* asset */
@property (nonatomic, strong) Asset *asset;
/* transactions */
@property (nonatomic, strong) TransactionsModel *transactions;

//资产详细
+(NSURLSessionDataTask*)asset_asset:(NSDictionary *)option
                            Success:(void (^)(AssetDetailModel *item))success
                            Failure:(void (^)(NSError *error))failue;

@end
