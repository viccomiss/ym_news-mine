//
//  AddTradeRecordViewController.h
//  Hunt
//
//  Created by 杨明 on 2018/8/21.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseViewController.h"
#import "TransactionsModel.h"


/**
 添加交易记录
 */
@interface AddTradeRecordViewController : BaseViewController

/* transaction */
@property (nonatomic, strong) Transaction *transaction;
/* 资产id */
@property (nonatomic, strong) NSDictionary *asset;
/* coinId 指定资产下添加交易记录使用 */
@property (nonatomic, copy) NSString *coinId;

@end
