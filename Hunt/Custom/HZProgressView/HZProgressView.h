//
//  HZProgressView.h
//  Hunt
//
//  Created by 杨明 on 2018/8/20.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseView.h"

typedef NS_ENUM(NSUInteger, ProgressState){
    ProgressOriState , //成本
    ProgressPosState, //正数
    ProgressNegState, //正数
};

/**
 进度条
 */
@interface HZProgressView : BaseView

/* progress */
@property (nonatomic, assign) CGFloat progress;

/* ;left */
@property (nonatomic, copy) NSString *leftTag;
/* right */
@property (nonatomic, copy) NSString *rightTag;
/* ProgressState */
@property (nonatomic, assign) ProgressState state;

@end
