//
//  FlashModel.m
//  Hunt
//
//  Created by 杨明 on 2018/11/19.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "FlashModel.h"

@implementation flash



@end

@implementation FlashGroupModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list": [flash class]};
}


@end

@implementation FlashModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list": [flash class]};
}

+(NSURLSessionDataTask*)usr_news_flash_list:(NSDictionary *)option
                              Success:(void (^)(FlashModel *items))success
                              Failure:(void (^)(NSError *error))failue{
    
    return [APIManager SafePOST:URI_USR_NEWS_NEWS_FLASH_LIST parameters:option success:^(NSURLResponse *respone, id responseObject) {
        
        success([FlashModel mj_objectWithKeyValues:[responseObject jk_dictionaryForKey:@"result"]]);
        
    } failure:^(NSURLResponse *respone, NSError *error) {
        failue(error);
    }];
}


@end
