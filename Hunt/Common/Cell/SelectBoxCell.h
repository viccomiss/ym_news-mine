//
//  SelectBoxCell.h
//  Hunt
//
//  Created by 杨明 on 2018/8/6.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SelectBoxModel.h"

/**
 选择框cell
 */
@interface SelectBoxCell : BaseTableViewCell

+ (instancetype)selectBoxCell:(UITableView *)tableView;

/* str */
@property (nonatomic, strong) SelectBoxModel *model;

@end
