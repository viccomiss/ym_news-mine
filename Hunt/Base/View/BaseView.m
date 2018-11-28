//
//  BaseView.m
//  SuperEducation
//
//  Created by 123 on 2017/2/28.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (instancetype)init{
    if (self == [super init]) {
        
        [SENotificationCenter addObserver:self selector:@selector(themeChange:) name:SKINCHANGESUCCESS object:nil];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        [SENotificationCenter addObserver:self selector:@selector(themeChange:) name:SKINCHANGESUCCESS object:nil];
    }
    return self;
}

- (void)themeChange:(NSNotification *)notification{
    
}

- (void)dealloc{
    [SENotificationCenter removeObserver:self name:SKINCHANGESUCCESS object:nil];
}

@end
