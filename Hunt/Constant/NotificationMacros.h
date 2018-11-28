//
//  Notification.h
//  SuperEducation
//
//  Created by yangming on 2017/3/8.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#ifndef Notification_h
#define Notification_h

#define  SENotificationCenter [NSNotificationCenter defaultCenter]

//音视频进度条通知
#define VideoSliderTap @"VideoSliderTap"
#define VideoSliderBeginTouch @"VideoSliderBeginTouch"
#define AudioSliderTap @"AudioSliderTap"
#define AudioSliderBeginTouch @"AudioSliderBeginTouch"



//kvo 列表联动
#define ContentCollectionContentOffset @"contentCollectionContentOffset"
#define TopTagCollectionContentOffset @"topTagCollectionContentOffset"

//Skin
#define SKINCHANGESUCCESS @"skinChangeSuccess"

//Language
#define LANGUAGECHANGE @"LanguageChange"

#define LOGINSUCCESS @"LoginSuccess"
#define LOGOUTSUCCESS @"logoutSuccess"
#define FINDPASSWORDSUCCESS @"FindPassWordSuccess"

//IM
#define RECONNECTIONSUCCESS @"reconnectionSuccess" //重连网络成功
#define NETBREAK @"netBreak" //网络中断

//积分 人民币 兑换率
#define Spread 10
#define MAXVisit 1000000

#endif /* Notification_h */
