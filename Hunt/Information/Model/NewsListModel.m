//
//  NewsListModel.m
//  Hunt
//
//  Created by 杨明 on 2018/11/26.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "NewsListModel.h"

#define NewListKey @"NewListKey"

@implementation New

+(NSURLSessionDataTask*)usr_news_new:(NSDictionary *)option
                              Success:(void (^)(New *items))success
                              Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_NEWS_NEWS parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([New mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

+(void)saveNewsListIds:(NSString *)newId{
    NSMutableArray *arrM = [NSMutableArray array];
    
    NSArray *newsIds = [self getNewsIds];
    [arrM addObjectsFromArray:newsIds];
    if (arrM.count >= 100) {
        [arrM replaceObjectAtIndex:0 withObject:newId];
    }else{
        [arrM addObject:newId];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSArray arrayWithArray:arrM] forKey:NewListKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSArray *)getNewsIds{
    NSArray *ids = [[NSUserDefaults standardUserDefaults]objectForKey:NewListKey];
    return ids;
}

@end

@implementation NewsListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list": [New class]};
}

+(NSURLSessionDataTask*)usr_news_list:(NSDictionary *)option
                              Success:(void (^)(NewsListModel *items))success
                              Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_NEWS_NEWS_LIST parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([NewsListModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}

@end
