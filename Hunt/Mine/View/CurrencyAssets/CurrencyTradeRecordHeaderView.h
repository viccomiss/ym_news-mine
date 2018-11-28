//
//  CurrencyTradeRecordHeaderView.h
//  Hunt
//
//  Created by 杨明 on 2018/8/22.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseView.h"
#import "AssetModel.h"

/**
 币详情header
 */
@interface CurrencyTradeRecordHeaderView : BaseView

/* model */
@property (nonatomic, strong) Asset *asset;
/* addBlock */
@property (nonatomic, copy) BaseBlock addBlock;

@end
