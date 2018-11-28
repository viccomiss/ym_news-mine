//
//  CurrencyTradeRecordSectionHeaderView.h
//  Hunt
//
//  Created by 杨明 on 2018/8/22.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionsModel.h"

/**
 币详情组header
 */
@interface CurrencyTradeRecordSectionHeaderView : UITableViewHeaderFooterView

/* model */
@property (nonatomic, strong) Transaction *model;

@end
