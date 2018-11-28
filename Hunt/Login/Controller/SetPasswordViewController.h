//
//  SetPasswordViewController.h
//  Hunt
//
//  Created by 杨明 on 2018/8/7.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseHiddenNavViewController.h"

/**
 设置密码
 */
@interface SetPasswordViewController : BaseHiddenNavViewController

/* mobile */
@property (nonatomic, copy) NSString *mobile;

/* setpass */
@property (nonatomic, copy) BaseIdBlock setPasswordSuccess;

@end
