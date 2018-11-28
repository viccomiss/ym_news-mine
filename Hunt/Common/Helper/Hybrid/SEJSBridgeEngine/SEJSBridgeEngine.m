//
//  SEJSBridgeEngine.m
//  wxer_manager
//
//  Created by Jacky on 2017/10/30.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "SEJSBridgeEngine.h"
#import "SEJSApiPay.h"
#import "SEJSApiShare.h"
#import "SEJSRedpacketrain.h"
#import "SEJSLoginFailer.h"

#import "NSString+JLAdd.h"

static NSString *SHARE = @"goInvitation";
static NSString *ShareBtn = @"setShareBtn";
static NSString *RulesBtn = @"setRulesBtn";
static NSString *LoginKey = @"login";


@implementation SEJSBridgeEngine

-(void)registerNativeService{
    
    //分享
    [self registerHandler:SHARE handler:^(NSString * data, WVJBResponseCallback responseCallback) {
        NSDictionary *shareDict = [data jsonToDictionary];
        [[SEJSApiShare shareJSApiBase] responsejsCallWithData:shareDict[@"data"]];
    }];
    
    //红包雨
    [self registerHandler:ShareBtn handler:^(NSString * data, WVJBResponseCallback responseCallback) {
        NSMutableDictionary *shareDict = [NSMutableDictionary dictionaryWithDictionary:[data jsonToDictionary]];
        [shareDict setObject:ShareBtn forKey:@"name"];
        [[SEJSRedpacketrain shareJSApiBase] responsejsCallWithData:shareDict];
    }];
    
    [self registerHandler:RulesBtn handler:^(NSString * data, WVJBResponseCallback responseCallback) {
        NSMutableDictionary *shareDict = [NSMutableDictionary dictionaryWithDictionary:[data jsonToDictionary]];
        [shareDict setObject:RulesBtn forKey:@"name"];
        [[SEJSRedpacketrain shareJSApiBase] responsejsCallWithData:shareDict];
    }];
    
    [self registerHandler:LoginKey handler:^(id data, WVJBResponseCallback responseCallback) {
        NSMutableDictionary *loginDict = [NSMutableDictionary dictionaryWithDictionary:[data jsonToDictionary]];
        [loginDict setObject:LoginKey forKey:@"name"];
        [[SEJSLoginFailer shareJSApiBase] responsejsCallWithData:loginDict];
    }];
}
//移除响应事件
-(void)removeResponsingNativeService{
    [[SEJSApiPay shareJSApiBase] disconnectResponsejsCall];
}
@end
