//
//  SEJSApiShare.m
//  Hybrid
//
//  Created by Jacky on 2017/10/27.
//  Copyright © 2017年 从知科技. All rights reserved.
//

#import "SEJSApiShare.h"
#import "CommonUtils.h"
#import "InviteCodeViewController.h"

@implementation SEJSApiShare

-(void)responsejsCallWithData:(id)data{
    [super responsejsCallWithData:data];
    
    InviteCodeViewController *inviteVC = [[InviteCodeViewController alloc] init];
    [[CommonUtils currentViewController].navigationController pushViewController:inviteVC animated:YES];
}

-(void)disconnectResponsejsCall{
    
    
    
}
@end
