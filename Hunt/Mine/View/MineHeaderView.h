//
//  MineHeaderView.h
//  Hunt
//
//  Created by 杨明 on 2018/8/4.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 个人中心header
 */
@interface MineHeaderView : UIView


/* inviteBlock */
@property (nonatomic, copy) BaseBlock inviteBlock;
/* loginBlock */
@property (nonatomic, copy) BaseBlock loginBlock;

- (void)reloadLoginState;

@end
