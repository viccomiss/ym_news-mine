//
//  SELoginFailer.m
//  Hunt
//
//  Created by 杨明 on 2018/10/20.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "SEJSLoginFailer.h"
#import "APIManager.h"
#import "CommonUtils.h"

@implementation SEJSLoginFailer

-(void)responsejsCallWithData:(id)data{
    [super responsejsCallWithData:data];
    
    if ([[data jk_stringForKey:@"name"] isEqualToString:@"login"]) {
//        UIViewController *vc = [CommonUtils currentViewController];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [vc.navigationController popViewControllerAnimated:YES];
//        });
        [APIManager loginFailureShowLogin:YES];
    }
}

-(void)disconnectResponsejsCall{
    
    
    
}

@end
