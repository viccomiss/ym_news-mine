//
//  TopTagBottomFieldCell.h
//  Hunt
//
//  Created by 杨明 on 2018/8/21.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TransactionsModel.h"

@interface TopTagBottomFieldCell : BaseTableViewCell

/* showWeight */
@property (nonatomic, assign) BOOL showWeight;
/* tag */
@property (nonatomic, copy) NSString *tagStr;
/* placeholder */
@property (nonatomic, copy) NSString *placeholder;
/* hideArrow */
@property (nonatomic, assign) BOOL hideArrow;
/* disField */
@property (nonatomic, assign) BOOL disField;
/* time */
@property (nonatomic, assign) BOOL timeField;
/* 币model */
@property (nonatomic, strong) Transaction *coinModel;
/* 数量model */
@property (nonatomic, strong) Transaction *quantutyModel;
/* 价格model */
@property (nonatomic, strong) Transaction *priceModel;
/* 总价格model */
@property (nonatomic, strong) Transaction *totalPriceModel;
/* 时间model */
@property (nonatomic, strong) Transaction *timeModel;
/* 交易所model */
@property (nonatomic, strong) Transaction *exchangeModel;
/* 钱包model */
@property (nonatomic, strong) Transaction *walletModel;
/* weightBlock */
@property (nonatomic, copy) BaseIntBlock weightBlock;
/* weight1 tag */
@property (nonatomic, copy) NSString *weight1Tag;
/* weight2 tag */
@property (nonatomic, copy) NSString *weight2Tag;
/* UIKeyboardType */
@property (nonatomic, assign) UIKeyboardType keyboardType;

+ (instancetype)topTagBottomFieldCell:(UITableView *)tableView cellId:(NSString *)cellId;

@end
