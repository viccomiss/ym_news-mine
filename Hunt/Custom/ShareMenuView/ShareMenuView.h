//
//  ShareMenuView.h
//  Hunt
//
//  Created by 杨明 on 2018/8/9.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "BaseView.h"
#import <ShareSDK/ShareSDK.h>

typedef void(^shareBlock)(SSDKPlatformType type);

@interface ShareMenuView : BaseView

/* backBlock */
@property (nonatomic, copy) BaseBlock backBlock;

/* shareBlock */
@property (nonatomic, copy) shareBlock shareBlock;

//分享图片
- (void)shareWithImage:(UIImage *)img type:(SSDKPlatformType)type;

//分享红包
- (void)shareRedEnvelopeWithData:(NSDictionary *)data type:(SSDKPlatformType)type;

//分享课程
//- (void)shareBundleWithId:(Bundle *)bundle type:(SSDKPlatformType)type;

- (instancetype)initWithFrame:(CGRect)frame shareType:(ShareType)type;

@end
