//
//  TransactionsModel.m
//  Hunt
//
//  Created by 杨明 on 2018/9/17.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "TransactionsModel.h"

@implementation Transaction

+(NSURLSessionDataTask*)asset_save_transaction:(NSDictionary *)option
                            Success:(void (^)(NSString *code))success
                            Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_ASSET_SAVE_TRANSACTION parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([responseObject jk_stringForKey:@"errcode"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

+(NSURLSessionDataTask*)asset_remove_transaction:(NSDictionary *)option
                                       Success:(void (^)(NSString *code))success
                                       Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_ASSET_REMOVE_TRANSACTION parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([responseObject jk_stringForKey:@"errcode"]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end

@implementation TransactionsModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : [Transaction class]};
}

+(NSURLSessionDataTask*)asset_transactions:(NSDictionary *)option
                            Success:(void (^)(TransactionsModel *item))success
                            Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_ASSET_TRANSACTIONS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([TransactionsModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
