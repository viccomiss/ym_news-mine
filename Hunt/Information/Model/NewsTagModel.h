//
//  NewsTagModel.h
//  Hunt
//
//  Created by 杨明 on 2018/11/26.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 资讯标签
 */
@interface NewsTagModel : BaseModel

/* createdAt */
@property (nonatomic, assign) NSInteger createdAt;
/* name */
@property (nonatomic, copy) NSString *name;
/* id */
@property (nonatomic, copy) NSString *ID;
/* tag */
@property (nonatomic, copy) NSString *tag;

//资讯标签
+(NSURLSessionDataTask*)usr_news_tags:(NSDictionary *)option
                              Success:(void (^)(NSArray *items))success
                              Failure:(void (^)(NSError *error))failue;

@end

NS_ASSUME_NONNULL_END
