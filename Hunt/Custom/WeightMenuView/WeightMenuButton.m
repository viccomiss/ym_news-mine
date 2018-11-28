//
//  WeightMenuButton.m
//  Hunt
//
//  Created by 杨明 on 2018/8/4.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "WeightMenuButton.h"

@implementation WeightMenuButton

- (instancetype)init{
    if (self == [super init]) {
        
    }
    return self;
}

- (void)setType:(WeightMenuBtnType)type{
    _type = type;
    
    if (!self.failer) {
        switch (type) {
            case WeightMenuBtnNormalType:
                [self setImage:ImageName(@"weight_normal") forState:UIControlStateNormal];
                break;
            case WeightMenuBtnDownType:
                [self setImage:[ThemeManager imageForKey:@"weight_down"] forState:UIControlStateNormal];
                break;
            case WeightMenuBtnUpType:
                [self setImage:[ThemeManager imageForKey:@"weight_up"] forState:UIControlStateNormal];
                break;
        }
    }
}


- (void)setFailer:(BOOL)failer{
    _failer = failer;
    
    [self setImage:nil forState:UIControlStateNormal];
    self.userInteractionEnabled = NO;
}
@end
