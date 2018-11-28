//
//  FlashModel.h
//  Hunt
//
//  Created by 杨明 on 2018/11/19.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 快讯model
 */
@interface flash : BaseModel

/* highlight */
@property (nonatomic, assign) BOOL highlight;
/* publishDate */
@property (nonatomic, assign) NSInteger publishDate;
/* id */
@property (nonatomic, copy) NSString *ID;
/* state */
@property (nonatomic, assign) NSInteger state;
/* text */
@property (nonatomic, copy) NSString *text;
/* articlesType */
@property (nonatomic, assign) NSInteger articlesType;
/* title */
@property (nonatomic, copy) NSString *title;

@end

//手动分组
@interface FlashGroupModel : BaseModel

/* date */
@property (nonatomic, copy) NSString *time;
/* array */
@property (nonatomic, strong) NSArray *flashArray;
/* news */
@property (nonatomic, assign) NSInteger news;

@end


@interface FlashModel : BaseModel

/* marker */
@property (nonatomic, copy) NSString *marker;
/* list */
@property (nonatomic, strong) NSArray *list;

//快讯列表
+(NSURLSessionDataTask*)usr_news_flash_list:(NSDictionary *)option
                                    Success:(void (^)(FlashModel *items))success
                                    Failure:(void (^)(NSError *error))failue;

@end

NS_ASSUME_NONNULL_END
