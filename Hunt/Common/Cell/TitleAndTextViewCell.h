//
//  TitleAndTextViewCell.h
//  wxer_manager
//
//  Created by levin on 2017/7/8.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TransactionsModel.h"

/**
 
 */
@interface TitleAndTextViewCell : BaseTableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholder;
/** otherBtn  title */
@property (nonatomic, copy) NSString *otherTitle;
/* 交易记录备注 */
@property (nonatomic, strong) Transaction *notesModel;

/** otherBlock */
@property (nonatomic, copy) BaseBlock otherBlock;
/* 字数限制 */
@property (nonatomic, assign) BOOL characterLength;

+ (instancetype)titleAndTextViewCell:(UITableView *)tableView cellID:(NSString *)cellid;

@end
