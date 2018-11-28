//
//  Define.h
//  SuperEducation
//
//  Created by yangming on 2017/2/21.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#ifndef Skin_h
#define Skin_h

//Skin
#define NAVBARCOLOR [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:1]

#define ColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//例如 0x000000
#define ColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//blue
#define MainBlueColor ColorFromHex(0x1890ff)

//orange
#define MainOrangColor ColorFromHex(0xFF7418)

//candy
#define DarkBgColor ColorFromHex(0x2C2932)
#define lightBgColor ColorFromHex(0x575265)


//common
#define MainDarkColor ColorFromHex(0x121212)
#define MainBlackColor ColorFromHex(0x000000)
#define BackGroundColor  ColorRGBA(241, 242, 245, 1)
#define LightGrayColor ColorFromHex(0xC1C1C1)
#define LightLineColor ColorFromHex(0xcccccc)
#define DarkBlackColor ColorFromHex(0x333333)
#define LineColor ColorRGBA(235, 235, 235, 1)
#define WhiteTextColor [UIColor whiteColor]
#define RedTextColor [UIColor redColor]
#define RandColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
#define CyanColor ColorRGBA(80, 227, 194, 1)
#define BackGreenColor ColorFromHex(0x23A61F)
#define BackRedColor ColorFromHex(0xD93536)
#define MainYellowColor ColorFromHex(0xFFEE1A)
#define GrayPlaceHolderColor ColorFromHex(0xD0D5DA)


//text
#define TextDarkColor ColorFromHex(0x3a3a3a)
#define MainTextColor ColorFromHex(0x333333)
#define TextDarkGrayColor ColorFromHex(0x777777)
#define LightTextGrayColor ColorFromHex(0x999999)


//fail
#define MainLightDarkColor ColorFromHex(0x3C434A)
#define MainGrayColor ColorFromHex(0xBBC2CC)
#define FailureTextColor ColorRGBA(154, 154, 154, 1)
#define DecribeTextColor ColorFromHex(0x9a9a9a)
#define DarkGrayColor ColorFromHex(0x7A7A7A)
#define LightGreenColor ColorFromHex(0x12B23A)
#define TranslucentColor ColorRGBA(118, 118, 118, 0.5)//半透明颜色
#define BlackTranslucentColor [[UIColor blackColor] colorWithAlphaComponent:0.3]



//语言
#define SIMPLIFIED_CHINESE @"zh_CN"
#define ENGLISH @"en_US"


//是否为空或是[NSNull null]
#define NotNilAndNull(_ref) (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))


//检测是否是第一次进入APP
#define LAST_RUN_VERSION_KEY @"last_run_version_of_application"

/******************************** typedef ********************************/

typedef void (^BaseBlock)(void);
typedef void (^BaseIntBlock )(NSInteger tag);
typedef void (^BaseFloatBlock )(CGFloat value);
typedef void (^BaseIdBlock )(id parameter);
typedef void (^BaseBoolBlock )(BOOL tag);
typedef void (^BaseDoubleBlock)(id parameter1,id parameter2);
typedef void (^BaseThreeBlock)(id parameter1,id parameter2,id parameter3);

#endif


