//
//  UMCommonEvent.h
//  Hunt
//
//  Created by 杨明 on 2018/10/24.
//  Copyright © 2018年 congzhi. All rights reserved.
//

# define CONST(name, value) extern NSString* const name


#ifndef UMCommonEvent_h
#define UMCommonEvent_h

//登录

static NSString *login_hqyzm = @"login_hqyzm";//登录验证码
static NSString *login_xyb = @"login_xyb";//登录下一步
static NSString *login_wc = @"login_wc";//登录完成


//首页
static NSString *home_hqzx = @"home_hqzx";//首页行情自选
static NSString *home_hqszzf = @"home_hqszzf"; //首页行情市值涨幅页面停留
static NSString *home_jrzf = @"home_jrzf"; //首页行情市值涨幅今日涨幅排序
static NSString *home_jg = @"home_jg"; //首页行情市值涨幅价格排序
static NSString *home_cje = @"home_cje"; //首页行情市值涨幅成交额排序
static NSString *home_szpx = @"home_szpx"; //首页行情市值涨幅市值排序

static NSString *home_zxcje = @"home_zxcje";//首页行情自选成交额排序
static NSString *home_zxjg = @"home_zxjg";//首页行情自选价格排序
static NSString *home_zxjrzf = @"home_zxjrzf"; //首页行情自选今日涨幅排序
static NSString *home_jyscje = @"home_jyscje"; //首页行情交易所成交额排序
static NSString *home_zxsz = @"home_zxsz";//首页行情自选市值排序
static NSString *home_hqzx_yjtj = @"home_hqzx_yjtj"; //智能推荐一键添加
static NSString *home_hqzx_hyp = @"home_hqzx_hyp"; //智能推荐换一批
static NSString *home_hq_bxq_jk = @"home_hq_bxq_jk"; //币种报价详情简况
static NSString *home_hq_bxq_hq = @"home_hq_bxq_hq"; //币种报价详情行情
static NSString *home_hq_bxq_fx = @"home_hq_bxq_fx"; //币种报价详情分享
static NSString *home_hq_bxq_zx = @"home_hq_bxq_zx"; //币种报价详情自选状态切换
static NSString *home_hq_fsdk = @"home_hq_fsdk"; //币详情分时多空
static NSString *home_hq_fst = @"home_hq_fst"; //币详情分时图
static NSString *home_hq_qkt = @"home_hq_qkt"; //币详情乾坤图
static NSString *home_hq_ssk = @"home_hq_ssk"; //币详情三色k线
static NSString *home_hq_k = @"home_hq_k"; //币详情k线图
static NSString *home_hq_qh = @"home_hq_qh"; //币详情分时图k线图切换
static NSString *home_hq_bxq = @"home_hq_bxq"; //首页行情币种报价详情
static NSString *home_hdzc = @"home_hdzc"; //活动专场
static NSString *home_hqzx_bjzx = @"home_hdzc"; //首页行情自选编辑自选
static NSString *home_hqzx_tjzx = @"home_hqzx_tjzx"; //首页行情自选添加自选


static NSString *home_hqjys = @"home_hqjys";//首页行情交易所
static NSString *home_hqss = @"home_hqss";//首页行情搜索
static NSString *home_hqjys_xq = @"home_hqjys_xq";//交易所详情



static NSString *home_tg = @"home_tg";//糖果首页
static NSString *home_tgjl = @"home_tgjl";//糖果记录
static NSString *home_zljl = @"home_zljl";//掌力记录
static NSString *home_tgzgg = @"home_tgzgg";//糖果主公告
static NSString *home_tgfgg = @"home_tgfgg";//糖果副公告
static NSString *home_tszl = @"home_tszl";///糖果提升掌力
static NSString *home_tggl = @"home_tggl";///糖果攻略
static NSString *home_tgyqhy = @"home_tgyqhy";///糖果邀请好友
static NSString *home_zlph = @"home_zlph";///掌力排行

static NSString *home_yyxz = @"home_yyxz";//应用下载
static NSString *home_yyxzss = @"home_yyxzss";//应用下载搜索
static NSString *home_jptj = @"home_jptj";//应用下载精品推荐
static NSString *home_xzph = @"home_xzph";//应用下载排行
static NSString *home_jptjgd = @"home_jptjgd";//应用下载精品推荐更多

static NSString *home_grzx = @"home_grzx";//首页个人中心
static NSString *home_wdyqm = @"home_wdyqm";//个人中心我的邀请码
static NSString *home_bzc = @"home_bzc";//个人中心币资产
static NSString *home_hzld = @"home_hzld";//个人中心红涨绿跌
static NSString *home_jgxs = @"home_jgxs";//个人中心价格显示
static NSString *home_dyy = @"home_dyy";//个人中心多语言
static NSString *home_dyy_zw = @"home_dyy_zw";//个人中心多语言中文
static NSString *home_dyy_yw = @"home_dyy_yw";//个人中心多语言英文
static NSString *home_pfqh = @"home_pfqh";//个人中心皮肤切换
static NSString *home_pfqh_yyl = @"home_pfqh_yyl";//个人中心皮肤切换优雅蓝
static NSString *home_pfqh_hlc = @"home_pfqh_hlc";//个人中心皮肤切换活力橙
static NSString *home_jgfq = @"home_jgfq";//个人中心加官方群
static NSString *home_gyhz = @"home_gyhz";//个人中心关于虹掌





#endif /* UMCommonEvent_h */
