//
//  FlashHeaderView.h
//  Hunt
//
//  Created by 杨明 on 2018/11/26.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlashModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 快讯sectionheader
 */
@interface FlashHeaderView : UITableViewHeaderFooterView

/* model */
@property (nonatomic, strong) flash *model;

@end

NS_ASSUME_NONNULL_END
