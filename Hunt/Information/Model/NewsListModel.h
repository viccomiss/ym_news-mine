//
//  NewsListModel.h
//  Hunt
//
//  Created by 杨明 on 2018/11/26.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 资讯model
 */
@interface New : BaseModel

/* pv */
@property (nonatomic, assign) NSInteger pv;
/* publishDate */
@property (nonatomic, assign) NSInteger publishDate;
/* id */
@property (nonatomic, copy) NSString *ID;
/* state */
@property (nonatomic, assign) NSInteger state;
/* tag */
@property (nonatomic, copy) NSString *tag;
/* title */
@property (nonatomic, copy) NSString *title;
/* content */
@property (nonatomic, copy) NSString *content;
/* "白话区块链" 资讯来源 */
@property (nonatomic, copy) NSString *originName;
/* coverImgIds */
@property (nonatomic, strong) NSArray *coverImgIds;

//资讯详情
+(NSURLSessionDataTask*)usr_news_new:(NSDictionary *)option
                             Success:(void (^)(New *items))success
                             Failure:(void (^)(NSError *error))failue;


+(void)saveNewsListIds:(NSString *)newId;

+(NSArray *)getNewsIds;

@end

@interface NewsListModel : BaseModel

/* marker */
@property (nonatomic, copy) NSString *marker;
/* list */
@property (nonatomic, strong) NSArray *list;

//资讯列表
+(NSURLSessionDataTask*)usr_news_list:(NSDictionary *)option
                              Success:(void (^)(NewsListModel *items))success
                              Failure:(void (^)(NSError *error))failue;

@end

NS_ASSUME_NONNULL_END
