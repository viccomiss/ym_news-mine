//
//  Constant.h
//  AFNetworking-demo
//
//  Created by Jakey on 15/6/3.
//  Copyright (c) 2015年 Jakey. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifdef SYNTHESIZE_CONSTS
# define CONST(name, value) NSString* const name = @ value
#else
# define CONST(name, value) extern NSString* const name
#endif

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif


#if 0 // 0 测试环境   1生产环境

//---------------------生产环境---------------------
#define SEDebug 0
CONST(API_VERSION, "1.1");
//CONST(URI_BASE_SERVER, "http://api.hongzhang.vip/v1/"); //正式服务器
CONST(URI_BASE_SERVER, "https://api-hz.congzhitech.com/v1/"); //正式服务器

CONST(KEY_WEIXIN_SSO_ID, "wx3505cb69fbc464d7");
CONST(KEY_WEIXIN_SECRET, "f6647b9fc047b45d42dd983b0725c0a4");
CONST(WEBSOCKET_URL, "wss://liveim.wakkaa.com/");
CONST(IM_URL, "im.wakkaa.com");
CONST(IM_PORT, "19001");

#else

//---------------------测试环境---------------------
#define SEDebug 1
CONST(API_VERSION, "1.1");
CONST(URI_BASE_SERVER, "http://sandbox-api-hz.congzhitech.com/v1/"); //测试服务器
//CONST(URI_BASE_SERVER, "http://192.168.1.52:8080/"); //测试服务器

CONST(KEY_WEIXIN_SSO_ID, "wx3505cb69fbc464d7");
CONST(KEY_WEIXIN_SECRET, "f6647b9fc047b45d42dd983b0725c0a4");
CONST(WEBSOCKET_URL, "ws://sandbox-api-hz.congzhitech.com/");
CONST(IM_URL, "sandbox-im.wakkaa.com");
CONST(IM_PORT, "19001");

#endif


//APP版本更新蒲公英下载地址
CONST(APP_UPDATE_DOWNLOAD_URL, "itms-services://?action=download-manifest&url=https://www.pgyer.com/app/plist/");
//APP版本更新蒲公英下载buildKey （蒲公英api 获取所有版本记录）
CONST(APP_UPDATE_DOWNLOAD_BUILDKEY, "8194c59e7df5bb924faeefc723064213");

/*====================================接口============================================*/
//mine
CONST(URI_MOBILE_COUNTRY, "usr/user/mobile_countries"); //获取手机号归属地列表
CONST(URI_USER_IS_MOBILE_REGISTERED, "usr/user/is_mobile_registered"); //查看手机号是否已被注册
CONST(URI_SEND_SIGNUP_CODE, "usr/user/send_signup_vcode"); //发送注册验证码
CONST(URI_SIGNUP, "usr/user/signup"); //注册
CONST(URI_SEND_SIGNIN_CODE, "usr/user/send_signin_vcode"); //发送登录验证码
CONST(URI_SIGNIN, "usr/user/signin"); //登录
CONST(URI_REFRESH_SESSION, "usr/user/refresh_session"); //刷新session
CONST(URI_USER_PROFILE, "usr/user/profile"); //获取用户基本资料
CONST(URI_USER_UPDATE_NICKNAME, "usr/user/update_nickname"); //修改昵称
CONST(URI_USER_UPDATE_AVATAR, "usr/user/update_avatar"); //  修改用户头像
CONST(URI_USR_FILE_UPLOAD_TOKEN, "usr/file/upload_token"); //  获取文件上传token
CONST(URI_USR_USER_CONTACT_H5, "usr/user/contact_h5"); //  联系我们
CONST(URI_USR_USER_INVITE_INFO, "usr/user/invite_info"); //获取我的邀请信息

//assets
CONST(URI_USR_ASSET_ASSETS, "usr/asset/assets"); //资产总览和清单
CONST(URI_USR_ASSET_ASSETS_OVERALL, "usr/asset/assets_overall"); //资产总览
CONST(URI_USR_ASSET_ASSET, "usr/asset/asset"); //资产详细
CONST(URI_USR_ASSET_REMOVE_ASSET, "usr/asset/remove_asset"); //删除币资产
CONST(URI_USR_ASSET_TRANSACTIONS, "usr/asset/transactions"); //交易记录列表
CONST(URI_USR_ASSET_SAVE_TRANSACTION, "usr/asset/save_transaction"); //保存交易记录
CONST(URI_USR_ASSET_REMOVE_TRANSACTION, "usr/asset/remove_transaction"); //删除交易记录


//setting
CONST(URI_USR_SETTINGS_GET, "usr/settings/get"); //获取APP设置
CONST(URI_USR_SETTINGS_UPDATE, "usr/settings/update"); //修改设置


CONST(URI_SET_PASSWORD, "set_password"); //设置密码
CONST(URI_PASSWORD_SIGNIN, "password_signin"); //密码登录
CONST(URI_VERIFY_LOGIN, "verify_signin"); //验证码登录
CONST(URI_VERIFY_PASSWORD, "verify_password"); //找回密码
CONST(URI_USER_UPDATE_PASSWORD, "user/update_password"); //修改密码
CONST(URI_USER_INVITE, "user/invite"); //我的邀请码
CONST(URI_USER_SET_KLINETYPE, "user/set_klinetype"); //红涨绿跌
CONST(URI_USER_SET_PRICETYPE, "user/set_pricetype"); //价格显示
CONST(URI_USER_SET_LANGUAGE, "user/set_language"); //修改语言
CONST(URI_USER_SET_SKIN, "user/set_skin"); //修改皮肤




//coin
CONST(URI_COIN_RANKS, "usr/coin/coins"); //币行情列表
CONST(URI_COIN_COIN, "usr/coin/coin"); //币详细
CONST(URI_COIN_RECOMMENDED_COINS, "usr/coin/recommended_coins"); //推荐币
CONST(URI_COIN_COLLECTED_COINS, "usr/coin/collected_coins"); //自选币详细列表
CONST(URI_COIN_ADD_COLLECTIONS, "usr/coin/add_collections"); //添加自选
CONST(URI_COIN_SAVE_COLLECTIONS, "usr/coin/save_collections"); //保存自选
CONST(URI_COIN_REMOVE_COLLECTIONS, "usr/coin/remove_collections"); //删除自选
CONST(URI_COIN_COLLECTIONS, "usr/coin/collections"); //自选ID列表
CONST(URI_COIN_SEARCH_COINS, "usr/coin/search_coins"); //搜索币
CONST(URI_COIN_SYMBOLS_OF_COIN, "usr/coin/symbols_of_coin"); //币行情(币的交易对列表)
CONST(URI_COIN_KLINE, "usr/coin/kline"); //K线数据
CONST(URI_COIN_TIMELINE, "usr/coin/timeline"); //分时线数据

//exchange
CONST(URI_EXCHANGE_RANKS, "usr/coin/exchanges"); //交易所列表
CONST(URI_COIN_EXCHANGE, "usr/coin/exchange"); //交易所详情
CONST(URI_USR_COIN_SYMBOLS_OF_EXCHANGE, "usr/coin/symbols_of_exchange"); //交易所下的交易对列表
CONST(URI_COIN_SEARCH_EXCHANGES, "usr/coin/search_exchanges"); //搜索交易所
CONST(URI_USR_OTA_IS_RESTRICTED, "usr/ota/is_restricted"); //是否功能受限版本

//news
CONST(URI_USR_NEWS_NEWS_TAGS, "usr/news/news_tags"); //资讯标签列表
CONST(URI_USR_NEWS_NEWS_LIST, "usr/news/news_list"); //资讯列表
CONST(URI_USR_NEWS_NEWS_FLASH_LIST, "usr/news/newsflash_list"); //快讯列表
CONST(URI_USR_NEWS_NEWS, "usr/news/news"); //快讯详情

//广告
CONST(URI_USR_SPLASH_SPLASHES, "usr/splash/splashes"); //开屏广告列表
CONST(URI_USR_SPLASH_HOME, "usr/splash/home"); //首页广告

//app
CONST(URI_USR_OTA_CHECK_UPDATE, "usr/ota/check_update"); //检查新版本
CONST(URI_USR_DEVICE_CREATE, "usr/device/create"); //注册设备
CONST(URI_USR_DEVICE_SIGNIN, "usr/device/signin"); //设备登录


@interface Constant : NSObject

@end
