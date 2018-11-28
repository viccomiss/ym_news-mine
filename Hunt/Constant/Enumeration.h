//
//  Enumeration.h
//  UNIS-LEASE
//
//  Created by runlin on 2016/11/10.
//  Copyright © 2016年 unis. All rights reserved.
//

#ifndef Enumeration_h
#define Enumeration_h

#define RGW @"RGW" //三色k线
#define QK @"QK" //三色k线
#define FSDK @"FSDK" //三色k线

/** 课程分类 */
typedef NS_ENUM(NSUInteger, CourseType){
    CourseAudioType = 1,  //音频
    CourseVideoType,  //音频
    CourseArticleType,  //音频
};

/** 上下架状态 */
typedef NS_ENUM(NSUInteger, UpAndDownState){
    DownState,  //下架
    UpState //上架
};

/** share type */
typedef NS_ENUM(NSUInteger, TransactionType){
    TransactionBuyType = 1, //买入
    TransactionSaleType = 2, //卖出
};

typedef NS_ENUM(NSUInteger, TransactionUNitOrTotalType){
    TransactionUnitType, //单价
    TransactionTotalType, //总价
};

/** share type */
typedef NS_ENUM(NSUInteger, ShareType){
    ShareCodeType, //邀请码
    ShareMarketType, //市值
    ShareBundleType, //专栏
    ShareNewsType, //资讯
    ShareFlashType, //快讯
};

/** 登录type */
typedef NS_ENUM(NSUInteger, LoginType){
    LoginCheckPhoneType,
    LoginCodeType,
    LoginPasswordType,
    LoginFindPasswordType,
    LoginUserFindPasswordType,
    LoginEditPhoneType,
    LoginEditPasswordType,
    LoginSetPasswordType,
    LoginRegisterType,
};

/** theme type */
typedef NS_ENUM(NSUInteger, CollectedType){
    CollectedCancelType,
    CollectedHaveType,
};

/** theme type */
typedef NS_ENUM(NSUInteger, ThemeType){
    ThemeBlueType = 1,
    ThemeOrangeType = 2,
};

//上传文件的类型
typedef NS_ENUM(NSUInteger, FileType) {
    FileTypeImage = 1,//图片
    FileTypeAudio,//音频
    FileTypeVideo,//视频
};

/** cell type */
typedef NS_ENUM(NSUInteger, MineCellType){
    MineNormalCellType,
    MineMessageTagCellType,
    MineSummaryCellType,
    MineSwitchCellType,
};

/** WightMenuType */
typedef NS_ENUM(NSUInteger, WeightMenuBtnType){
    WeightMenuBtnNormalType = 0,
    WeightMenuBtnDownType = 1,
    WeightMenuBtnUpType = 2,
};

/** kMenuType */
typedef NS_ENUM(NSUInteger, KMenuType){
    KMenuKLineOrTimeType = 0,
    KMenuKType ,
    KMenuTimeType , //分时
    KMenuTimeShortType , //分时多空
    KMenuInd1Type ,
    KMenuInd2Type ,
    KMenuInd3Type ,
    KMenuCycleType , //时间段
};


typedef NS_ENUM(NSUInteger, KMenuStateType){
    KMenuFixedType = 0, //固定
    KMenuDynamicType = 1, //动态隐藏
    KMenuQuataType = 2, //指标
};

typedef NS_ENUM(NSUInteger, RoseOrFallType){
    RoseType = 1, //上涨
    FallType = 2, //下跌
};

/** 权重menuType */
typedef NS_ENUM(NSUInteger, WeightMenuType){
    WeightMenuFourType,
    WeightMenuTwoType,
    WeightMenuThreeType
};

/** 排行or交易所类型 */
typedef NS_ENUM(NSUInteger, CoinRankOrExchangeType){
    CoinRankType,
    ExchangeType,
};

/** 无数据类型 */
typedef NS_ENUM(NSUInteger, NoDataType){
    NoTextType = 1,
    NoNetworkType = 2,
    NoFlashType = 3,
    NoUnWarnType = 4,
    NoHistoryType = 5,
    NoMessageType,
    NoSearchType,
};


/** 网络监听 */
typedef NS_ENUM(NSUInteger,NetWorkState) {
    NetWorkUnknow = 0,  //没网
    NetWorkConnected = 1,     //有网
};
#endif /* Enumeration_h */
