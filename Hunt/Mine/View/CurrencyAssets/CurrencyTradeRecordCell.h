//
//  CurrencyTradeRecordCell.h
//  Hunt
//
//  Created by 杨明 on 2018/8/22.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TransactionsModel.h"

@interface CurrencyTradeRecordCell : BaseTableViewCell

+ (instancetype)currencyTradeRecordCell:(UITableView *)tableView;

/* model */
@property (nonatomic, strong) Transaction *model;

@end
