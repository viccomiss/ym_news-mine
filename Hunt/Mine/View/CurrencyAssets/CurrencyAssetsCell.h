//
//  CurrencyAssetsCell.h
//  Hunt
//
//  Created by 杨明 on 2018/8/18.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AssetModel.h"

/**
 币资产cell
 */
@interface CurrencyAssetsCell : BaseTableViewCell

+ (instancetype)currencyAssetsCell:(UITableView *)tableView;

/* model */
@property (nonatomic, strong) Asset *model;

@end
