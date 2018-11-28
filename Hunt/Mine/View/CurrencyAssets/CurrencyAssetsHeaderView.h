//
//  CurrencyAssetsHeaderView.h
//  Hunt
//
//  Created by 杨明 on 2018/8/18.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseView.h"
#import "AssetModel.h"

/**
 币资产header
 */
@interface CurrencyAssetsHeaderView : BaseView

- (void)changeAlpha:(CGFloat)alpha;

/* addBlock */
@property (nonatomic, copy) BaseBlock addBlock;
/* model */
@property (nonatomic, strong) Asset *allAsset;

@end
