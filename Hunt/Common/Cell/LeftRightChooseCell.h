//
//  LeftRightChooseCell.h
//  wxer_manager
//
//  Created by levin on 2017/7/8.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TransactionsModel.h"

/**
 类型选择cell  左右结构
 */
@interface LeftRightChooseCell : BaseTableViewCell

@property (nonatomic, copy) BaseIntBlock buttonTouch;
/* 交易所or钱包 */
@property (nonatomic, strong) Transaction *exchangeModel;

+ (instancetype)typeChooseCell:(UITableView *)tableView cellID:(NSString *)cellid leftStr:(NSString *)leftStr rightStr:(NSString *)rightStr;

@end
