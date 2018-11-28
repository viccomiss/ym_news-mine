//
//  WeightMenuButton.h
//  Hunt
//
//  Created by 杨明 on 2018/8/4.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseButton.h"

/**
 menu 栏 btn
 */
@interface WeightMenuButton : BaseButton

/* type */
@property (nonatomic, assign) WeightMenuBtnType type;
/* 失效 */
@property (nonatomic, assign) BOOL failer;

@end
