//
//  MobileCountryModel.m
//  Hunt
//
//  Created by 杨明 on 2018/8/14.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "MobileCountryModel.h"

@implementation MobileCountryModel

+(NSURLSessionDataTask*)mobile_country:(NSDictionary *)option
                      Success:(void (^)(NSArray *list))success
                      Failure:(void (^)(NSError *error))failue{

    return [APIManager SafePOST:URI_MOBILE_COUNTRY parameters:option success:^(NSURLResponse *respone, id responseObject) {

        NSArray *array = [responseObject jk_arrayForKey:@"result"];
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            MobileCountryModel *model = [MobileCountryModel mj_objectWithKeyValues:dic];
            [arrM addObject:model];
        }
        
        success(arrM);

    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
