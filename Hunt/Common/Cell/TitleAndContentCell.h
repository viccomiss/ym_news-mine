//
//  TitleAndContentCell.h
//  Hunt
//
//  Created by 杨明 on 2018/9/10.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseTableViewCell.h"

/**
 上 title
 下 content
 */
@interface TitleAndContentCell : BaseTableViewCell

+ (instancetype)titleAndContent:(UITableView *)tableView cellId:(NSString *)cellId;

/* title */
@property (nonatomic, copy) NSString *title;
/* titleColor */
@property (nonatomic, strong) UIColor *contentColor;
/* content */
@property (nonatomic, copy) NSString *content;
/* 字体大小 */
@property (nonatomic, assign) CGFloat fontSize;
/* showTitle */
@property (nonatomic, assign) BOOL hideTitle;

@end
