//
//  MineInviteView.h
//  Hunt
//
//  Created by 杨明 on 2018/8/5.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface MineInviteView : BaseView

/* inviteBlock */
@property (nonatomic, copy) BaseBlock inviteBlock;

/* user */
@property (nonatomic, strong) UserModel *user;

@end
