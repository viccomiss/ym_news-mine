//
//  MobileCountryModel.h
//  Hunt
//
//  Created by 杨明 on 2018/8/14.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseModel.h"

/**
 手机区号
 */
@interface MobileCountryModel : BaseModel

/* id */
@property (nonatomic, copy) NSString *index;
/* country */
@property (nonatomic, copy) NSString *name;
/* areaCode */
@property (nonatomic, copy) NSString *code;


+(NSURLSessionDataTask*)mobile_country:(NSDictionary *)option
                               Success:(void (^)(NSArray *list))success
                               Failure:(void (^)(NSError *error))failue;

@end
