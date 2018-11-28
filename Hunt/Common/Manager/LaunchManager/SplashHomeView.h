//
//  SplashHomeView.h
//  Hunt
//
//  Created by 杨明 on 2018/10/26.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseView.h"
#import "LaunchAdModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 开屏广告
 */
@interface SplashHomeView : BaseView

+ (instancetype)showHoneADWithData:(LaunchAdModel *)ad;

@end

NS_ASSUME_NONNULL_END
