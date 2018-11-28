//
//  LaunchAdModel.h
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 2016/6/28.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd
//  广告数据模型

#import "BaseModel.h"
#import <UIKit/UIKit.h>

@interface LaunchAdModel : BaseModel

/* createdAt */
@property (nonatomic, assign) NSInteger createdAt;
/* 跳转地址 */
@property (nonatomic, copy) NSString *redirectUrl;
/* 资源地址 */
@property (nonatomic, copy) NSString *resourceUrl;
/* 上架时间 */
@property (nonatomic, assign) NSInteger issueAt;
/* 下架时间 */
@property (nonatomic, assign) NSInteger offTime;
/* 资源类型 */
@property (nonatomic, copy) NSString *type;

/**
 *  广告URL
 */
@property (nonatomic, copy) NSString *content;

/**
 *  点击打开连接
 */
@property (nonatomic, copy) NSString *openUrl;

/**
 *  广告分辨率
 */
@property (nonatomic, copy) NSString *contentSize;

/**
 *  广告停留时间
 */
@property (nonatomic, assign) NSInteger duration;


/**
 *  分辨率宽
 */
@property(nonatomic,assign,readonly)CGFloat width;
/**
 *  分辨率高
 */
@property(nonatomic,assign,readonly)CGFloat height;

//首页广告
+(NSURLSessionDataTask*)usr_splash_home:(NSDictionary *)option
                                Success:(void (^)(LaunchAdModel *item))success
                                Failure:(void (^)(NSError *error))failue;

@end

@interface SplashesModel : BaseModel

/* timestamp */
@property (nonatomic, assign) NSInteger timestamp;
/* 开屏数据列表 */
@property (nonatomic, strong) NSArray *splashes;

+(NSURLSessionDataTask*)usr_splash_splashes:(NSDictionary *)option
                                    Success:(void (^)(SplashesModel *item))success
                                    Failure:(void (^)(NSError *error))failue;

@end
