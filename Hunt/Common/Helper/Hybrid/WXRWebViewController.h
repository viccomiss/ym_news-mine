//
//  WXRWebViewController.h
//  wxer_manager
//
//  Created by levin on 2017/8/11.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "BaseViewController.h"

//进入方式
typedef NS_ENUM(NSUInteger, WXRWebViewControllerModelType) {
    WXRWebViewControllerModelTypePush,
    WXRWebViewControllerModelTypePresent
};

//数据获取方向
typedef NS_ENUM(NSUInteger, WXRWebViewControllerDataFrom) {
    WXRWebViewControllerDataFromAgreenment, //用户协议
    WXRWebViewControllerDataFromGrowEnergy, //提升掌力
    WXRWebViewControllerDataFromContactUs, //联系我们
    WXRWebViewControllerDataFromMessage //消息
};

/**
 店铺界面
 */
@interface WXRWebViewController : BaseViewController
@property (nonatomic, assign) WXRWebViewControllerModelType modelType;
/* dataFrom */
@property (nonatomic, assign) WXRWebViewControllerDataFrom dataFrom;
@property (nonatomic, copy) NSString *HtmlStr;
@property (nonatomic, copy) NSString *urlPath;//url
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *requestUrl;
@end
