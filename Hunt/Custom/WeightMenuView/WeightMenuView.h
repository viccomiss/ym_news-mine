//
//  WeightMenuView.h
//  Hunt
//
//  Created by 杨明 on 2018/7/30.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 权重顶部view
 */
typedef void(^weightMenuBlock)(WeightMenuBtnType btnType, NSInteger tag);

@interface WeightMenuView : UIView

- (instancetype)initWithMenuType:(WeightMenuType)menuType titleArray:(NSArray *)titles;

/* block */
@property (nonatomic, copy) weightMenuBlock weightMenuBlock;
/* 手动失效按钮索引 */
@property (nonatomic, assign) NSInteger failIndex;

@end
