//
//  UMAnalyticsHelper.h
//  Hunt
//
//  Created by 杨明 on 2018/10/24.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UMAnalyticsHelper : NSObject

/*
 * 启动友盟统计功能
 */
+ (void)UMAnalyticStart;

/**
 *  在viewWillAppear调用,才能够获取正确的页面访问路径、访问深度（PV）的数据
 */
+ (void)beginLogPageView:(__unsafe_unretained Class)pageView;

/**
 *  在viewDidDisappeary调用，才能够获取正确的页面访问路径、访问深度（PV）的数据
 */
+ (void)endLogPageView:(__unsafe_unretained Class)pageView;

+ (void)event:(NSString *)eventId;

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

+ (void)beginEvent:(NSString *)eventId;

+ (void)endEvent:(NSString *)eventId;

@end

NS_ASSUME_NONNULL_END
