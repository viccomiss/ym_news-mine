//
//  TitleAndMultiLinesContentCell.h
//  Hunt
//
//  Created by 杨明 on 2018/9/12.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseTableViewCell.h"


/**
 title    多行label
 */
@interface TitleAndMultiLinesContentCell : BaseTableViewCell

+ (instancetype)titleAndMultiLinesContentCell:(UITableView *)tableView cellId:(NSString *)cellId;

/* title */
@property (nonatomic, copy) NSString *title;
/* content */
@property (nonatomic, copy) NSString *content;

/* highlighted */
@property (nonatomic, assign) BOOL highlightedTouch;
/* touchBlock */
@property (nonatomic, copy) BaseBlock touchBlock;
/* showFaq */
- (void)showFaqWithStr:(NSString *)str;

@end
