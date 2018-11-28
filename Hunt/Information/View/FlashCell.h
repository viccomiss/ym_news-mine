//
//  FlashCell.h
//  Hunt
//
//  Created by 杨明 on 2018/11/19.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FlashModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 快讯cell
 */
@interface FlashCell : BaseTableViewCell

+ (instancetype)flashCell:(UITableView *)tableView;
/* index */
@property (nonatomic, strong) NSIndexPath *indexPath;

/* model */
@property (nonatomic, strong) flash *model;
/* tapBlock */
@property (nonatomic, copy) BaseIntBlock contentBlock;
/* shareBlock */
@property (nonatomic, copy) BaseBlock shareBlock;



@end

NS_ASSUME_NONNULL_END
