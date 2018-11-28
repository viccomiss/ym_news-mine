//
//  NewsTagModel.m
//  Hunt
//
//  Created by 杨明 on 2018/11/26.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "NewsTagModel.h"

@implementation NewsTagModel

+(NSURLSessionDataTask*)usr_news_tags:(NSDictionary *)option
                                      Success:(void (^)(NSArray *items))success
                                      Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_NEWS_NEWS_TAGS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        NSArray *arr = [responseObject jk_arrayForKey:@"result"];
        for (NSDictionary *dic in arr) {
            NewsTagModel *model = [NewsTagModel mj_objectWithKeyValues:dic];
            [arrM addObject:model];
        }
        
        success(arrM);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
