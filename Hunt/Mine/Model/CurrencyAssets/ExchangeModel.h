//
//  ExchangeModel.h
//  Hunt
//
//  Created by 杨明 on 2018/8/4.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseModel.h"

@interface ExchangeModel : BaseModel

/* 图标地址 */
@property (nonatomic, copy) NSString *logo;
/* 交易所code */
@property (nonatomic, copy) NSString *ID;
/* 交易所名称 */
@property (nonatomic, copy) NSString *name;
/* 成交额 */
@property (nonatomic, assign) CGFloat turnover;
/* state */
@property (nonatomic, assign) NSInteger state;
/* detail */
@property (nonatomic, copy) NSString *detail;
/* website */
@property (nonatomic, copy) NSString *website;
/* 广告标识 */
@property (nonatomic, assign) BOOL ad;

//交易所详细
+(NSURLSessionDataTask*)coin_exchange:(NSDictionary *)option
                              Success:(void (^)(ExchangeModel *item))success
                              Failure:(void (^)(NSError *error))failue;

@end
