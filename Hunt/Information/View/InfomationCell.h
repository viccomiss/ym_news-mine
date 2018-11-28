//
//  InfomationCell.h
//  Hunt
//
//  Created by 杨明 on 2018/11/19.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NewsListModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 资讯cell 
 */
@interface InfomationCell : BaseTableViewCell

+ (instancetype)infomationCell:(UITableView *)tableView;
/* model */
@property (nonatomic, strong) New *model;

@end

NS_ASSUME_NONNULL_END
