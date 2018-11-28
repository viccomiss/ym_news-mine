//
//  UMAnalyticsHelper.m
//  Hunt
//
//  Created by 杨明 on 2018/10/24.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "UMAnalyticsHelper.h"
#import <UMAnalytics/MobClick.h>
#import <UMCommon/UMCommon.h>

//友盟key
static NSString *UMCommonKey = @"5bcc076bf1f5567e8d0002dc";

@implementation UMAnalyticsHelper

+ (void)UMAnalyticStart {
    
    [UMConfigure initWithAppkey:UMCommonKey channel:nil];
    //开发者需要显式的调用此函数，日志系统才能工作
    //    [UMCommonLogManager setUpUMCommonLogManager];
    
    NSString* deviceID =  [UMConfigure deviceIDForIntegration];
    NSLog(@"集成测试的deviceID:%@",deviceID);
    
    // version标识
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
#if DEBUG
    // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [UMConfigure setLogEnabled:YES];
#endif
    //闪退统计
    [MobClick setCrashReportEnabled:YES];
}

+ (void)beginLogPageView:(__unsafe_unretained Class)pageView {
    [MobClick beginLogPageView:NSStringFromClass(pageView)];
    return;
}

+ (void)endLogPageView:(__unsafe_unretained Class)pageView {
    [MobClick endLogPageView:NSStringFromClass(pageView)];
    return;
}

+ (void)event:(NSString *)eventId{
    [MobClick event:eventId];
    return;
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes{
    [MobClick event:eventId attributes:attributes];
    return;
}

+ (void)beginEvent:(NSString *)eventId{
    [MobClick beginEvent:eventId];
    return;
}

+ (void)endEvent:(NSString *)eventId{
    [MobClick endEvent:eventId];
    return;
}

@end
