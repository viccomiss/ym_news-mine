//
//  ExchangeModel.m
//  Hunt
//
//  Created by 杨明 on 2018/8/4.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "ExchangeModel.h"

@implementation ExchangeModel

+(NSURLSessionDataTask*)coin_exchange:(NSDictionary *)option
                               Success:(void (^)(ExchangeModel *item))success
                               Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_COIN_EXCHANGE parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        ExchangeModel *model = [ExchangeModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]];
        
        
        success(model);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
