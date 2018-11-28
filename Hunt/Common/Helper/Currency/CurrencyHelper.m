//
//  CurrencyHelper.m
//  Hunt
//
//  Created by 杨明 on 2018/8/27.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CurrencyHelper.h"
#import "SEUserDefaults.h"
#import "UserModel.h"

#define CurrencyKey @"CurrencyKey"

@interface CurrencyHelper()

/* currency */
@property (nonatomic, strong) NSArray *currencyArr;
/* currencyName */
@property (nonatomic, strong) NSArray *currencyNameArr;

@end

@implementation CurrencyHelper

+ (instancetype)standardHelper {
    static CurrencyHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[CurrencyHelper alloc] init];
    });
    return helper;
}

- (instancetype)init{
    if (self == [super init]) {
        
        self.currencyArr = @[@"CNY",@"USD",@"JPY",@"KRW"];
        self.currencyNameArr = @[@"人民币",@"美元",@"日元",@"韩元"];
    }
    return self;
}

+ (NSArray *)currencies{
    return [CurrencyHelper standardHelper].currencyArr;
}

+ (NSArray *)currenciesNameArr{
    return [CurrencyHelper standardHelper].currencyNameArr;
}

+ (NSString *)currentCurrency{
    NSString *currency = [[NSUserDefaults standardUserDefaults] objectForKey:CurrencyKey];
    return currency.length == 0 ? [CurrencyHelper currencies][0] : currency;
}

+ (void)setCurrency:(NSString *)currency{
    [[NSUserDefaults standardUserDefaults]setObject:currency forKey:CurrencyKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSString *)currencyTag{
    return [CurrencyHelper moneyTagWithMoneyCode:[CurrencyHelper currentCurrency]];
}

+ (NSString *)moneyTagWithMoneyCode:(NSString *)moneyCode{
    
    NSString *moneyTag = moneyCode;
    
    // 亚洲
    if ([moneyCode isEqualToString:@"HKD"]) moneyTag = @"HK$";
    if ([moneyCode isEqualToString:@"MOP"]) moneyTag = @"PAT";
    if ([moneyCode isEqualToString:@"CNY"]) moneyTag = @"￥";
    if ([moneyCode isEqualToString:@"YND"]) moneyTag = @"D";
    if ([moneyCode isEqualToString:@"JPY"]) moneyTag = @"￥"; //J￥
    if ([moneyCode isEqualToString:@"LAK"]) moneyTag = @"K";
    if ([moneyCode isEqualToString:@"KHR"]) moneyTag = @"CR";
    if ([moneyCode isEqualToString:@"PHP"]) moneyTag = @"P";
    if ([moneyCode isEqualToString:@"MYR"]) moneyTag = @"M$";
    if ([moneyCode isEqualToString:@"SGD"]) moneyTag = @"S$";
    if ([moneyCode isEqualToString:@"THP"]) moneyTag = @"BT$";
    if ([moneyCode isEqualToString:@"BUK"]) moneyTag = @"K";
    if ([moneyCode isEqualToString:@"LKR"]) moneyTag = @"S.Re";
    if ([moneyCode isEqualToString:@"MVR"]) moneyTag = @"M.R.R";
    if ([moneyCode isEqualToString:@"IDR"]) moneyTag = @"Rps";
    if ([moneyCode isEqualToString:@"PRK"]) moneyTag = @"Pak.Re";
    if ([moneyCode isEqualToString:@"INR"]) moneyTag = @"Re";
    if ([moneyCode isEqualToString:@"NPR"]) moneyTag = @"N.Re";
    if ([moneyCode isEqualToString:@"AFA"]) moneyTag = @"Af";
    if ([moneyCode isEqualToString:@"IRR"]) moneyTag = @"RI";
    if ([moneyCode isEqualToString:@"IQD"]) moneyTag = @"ID";
    if ([moneyCode isEqualToString:@"SYP"]) moneyTag = @"￡.S";
    if ([moneyCode isEqualToString:@"LBP"]) moneyTag = @"￡L";
    if ([moneyCode isEqualToString:@"JOD"]) moneyTag = @"J.D";
    if ([moneyCode isEqualToString:@"SAR"]) moneyTag = @"S.A.RIs";
    if ([moneyCode isEqualToString:@"KWD"]) moneyTag = @"K.D";
    if ([moneyCode isEqualToString:@"BHD"]) moneyTag = @"BD";
    if ([moneyCode isEqualToString:@"QAR"]) moneyTag = @"QR";
    if ([moneyCode isEqualToString:@"OMR"]) moneyTag = @"RO";
    if ([moneyCode isEqualToString:@"YER"]) moneyTag = @"YRL";
    if ([moneyCode isEqualToString:@"YDD"]) moneyTag = @"YD";
    if ([moneyCode isEqualToString:@"TRL"]) moneyTag = @"￡T";
    if ([moneyCode isEqualToString:@"CYP"]) moneyTag = @"￡C";
    if ([moneyCode isEqualToString:@"KRW"]) moneyTag = @"₩";
    
    // 大洋洲
    if ([moneyCode isEqualToString:@"AUD"]) moneyTag = @"$A";
    if ([moneyCode isEqualToString:@"NZD"]) moneyTag = @"$NZ";
    if ([moneyCode isEqualToString:@"FJD"]) moneyTag = @"F.$";
    if ([moneyCode isEqualToString:@"SBD"]) moneyTag = @"SL.$";
    
    // 欧洲
    if ([moneyCode isEqualToString:@"EUR"]) moneyTag = @"EUR";
    if ([moneyCode isEqualToString:@"ISK"]) moneyTag = @"I.Kr";
    if ([moneyCode isEqualToString:@"DKK"]) moneyTag = @"D.Kr";
    if ([moneyCode isEqualToString:@"NOK"]) moneyTag = @"N.Kr";
    if ([moneyCode isEqualToString:@"SEK"]) moneyTag = @"S.Kr";
    if ([moneyCode isEqualToString:@"FIM"]) moneyTag = @"FMK";
    if ([moneyCode isEqualToString:@"SUR"]) moneyTag = @"Rbs";
    if ([moneyCode isEqualToString:@"PLZ"]) moneyTag = @"ZL";
    if ([moneyCode isEqualToString:@"CSK"]) moneyTag = @"Kcs";
    if ([moneyCode isEqualToString:@"HUF"]) moneyTag = @"FT";
    if ([moneyCode isEqualToString:@"DEM"]) moneyTag = @"DM";
    if ([moneyCode isEqualToString:@"ATS"]) moneyTag = @"ScH";
    if ([moneyCode isEqualToString:@"CHF"]) moneyTag = @"SF";
    if ([moneyCode isEqualToString:@"NLG"]) moneyTag = @"Gs";
    if ([moneyCode isEqualToString:@"BEF"]) moneyTag = @"Bi";
    if ([moneyCode isEqualToString:@"LUF"]) moneyTag = @"Lux.F";
    if ([moneyCode isEqualToString:@"GBP"]) moneyTag = @"￡";
    if ([moneyCode isEqualToString:@"IEP"]) moneyTag = @"￡.Ir";
    if ([moneyCode isEqualToString:@"FRF"]) moneyTag = @"F.F";
    if ([moneyCode isEqualToString:@"ESP"]) moneyTag = @"Pts";
    if ([moneyCode isEqualToString:@"PTE"]) moneyTag = @"ESC";
    if ([moneyCode isEqualToString:@"ITL"]) moneyTag = @"Lit";
    if ([moneyCode isEqualToString:@"MTP"]) moneyTag = @"￡.M";
    if ([moneyCode isEqualToString:@"ROL"]) moneyTag = @"L";
    if ([moneyCode isEqualToString:@"BGL"]) moneyTag = @"Lev";
    if ([moneyCode isEqualToString:@"ALL"]) moneyTag = @"Af";
    if ([moneyCode isEqualToString:@"GRD"]) moneyTag = @"Dr";
    
    // 美洲
    if ([moneyCode isEqualToString:@"CAD"]) moneyTag = @"Can.$";
    if ([moneyCode isEqualToString:@"USD"]) moneyTag = @"$"; //@"U.S.$"
    if ([moneyCode isEqualToString:@"MXP"]) moneyTag = @"Mex.$";
    if ([moneyCode isEqualToString:@"GTQ"]) moneyTag = @"Q";
    if ([moneyCode isEqualToString:@"SVC"]) moneyTag = @"￠";
    if ([moneyCode isEqualToString:@"HNL"]) moneyTag = @"L";
    if ([moneyCode isEqualToString:@"NIC"]) moneyTag = @"CS";
    if ([moneyCode isEqualToString:@"CRC"]) moneyTag = @"￠";
    if ([moneyCode isEqualToString:@"PAB"]) moneyTag = @"B";
    if ([moneyCode isEqualToString:@"CUP"]) moneyTag = @"Cu.Pes";
    if ([moneyCode isEqualToString:@"BSD"]) moneyTag = @"B.$";
    if ([moneyCode isEqualToString:@"JMD"]) moneyTag = @"$.J";
    if ([moneyCode isEqualToString:@"HTG"]) moneyTag = @"G";
    if ([moneyCode isEqualToString:@"DOP"]) moneyTag = @"R.D.$";
    if ([moneyCode isEqualToString:@"TTD"]) moneyTag = @"T.T.$";
    if ([moneyCode isEqualToString:@"BBD"]) moneyTag = @"BDS.$";
    if ([moneyCode isEqualToString:@"COP"]) moneyTag = @"Col.$";
    if ([moneyCode isEqualToString:@"VEB"]) moneyTag = @"B";
    if ([moneyCode isEqualToString:@"GYD"]) moneyTag = @"G.$";
    if ([moneyCode isEqualToString:@"SRG"]) moneyTag = @"S.FI";
    if ([moneyCode isEqualToString:@"PES"]) moneyTag = @"S/";
    if ([moneyCode isEqualToString:@"ECS"]) moneyTag = @"S/";
    if ([moneyCode isEqualToString:@"BRC"]) moneyTag = @"Gr.$";
    if ([moneyCode isEqualToString:@"BOP"]) moneyTag = @"NBol.P";
    if ([moneyCode isEqualToString:@"CLP"]) moneyTag = @"P";
    if ([moneyCode isEqualToString:@"ARP"]) moneyTag = @"Arg.P";
    if ([moneyCode isEqualToString:@"PVG"]) moneyTag = @"Guars";
    if ([moneyCode isEqualToString:@"UYP"]) moneyTag = @"N.$";
    
    // 非洲
    if ([moneyCode isEqualToString:@"EGP"]) moneyTag = @"￡E";
    if ([moneyCode isEqualToString:@"LYD"]) moneyTag = @"LD";
    if ([moneyCode isEqualToString:@"SDP"]) moneyTag = @"￡S";
    if ([moneyCode isEqualToString:@"TND"]) moneyTag = @"TD";
    if ([moneyCode isEqualToString:@"DZD"]) moneyTag = @"AD";
    if ([moneyCode isEqualToString:@"MAD"]) moneyTag = @"DH";
    if ([moneyCode isEqualToString:@"MRO"]) moneyTag = @"UM";
    if ([moneyCode isEqualToString:@"XOF"]) moneyTag = @"C.F.A.F";
    if ([moneyCode isEqualToString:@"GMD"]) moneyTag = @"D.G";
    if ([moneyCode isEqualToString:@"GWP"]) moneyTag = @"PG";
    if ([moneyCode isEqualToString:@"GNS"]) moneyTag = @"GS";
    if ([moneyCode isEqualToString:@"SLL"]) moneyTag = @"Le";
    if ([moneyCode isEqualToString:@"LRD"]) moneyTag = @"Lib.$";
    if ([moneyCode isEqualToString:@"GHC"]) moneyTag = @"￠";
    if ([moneyCode isEqualToString:@"NGN"]) moneyTag = @"N";
    if ([moneyCode isEqualToString:@"XAF"]) moneyTag = @"CFAF";
    if ([moneyCode isEqualToString:@"GQE"]) moneyTag = @"EK";
    if ([moneyCode isEqualToString:@"ZAR"]) moneyTag = @"R";
    if ([moneyCode isEqualToString:@"DJF"]) moneyTag = @"DJ.FS";
    if ([moneyCode isEqualToString:@"SOS"]) moneyTag = @"Sh.So";
    if ([moneyCode isEqualToString:@"KES"]) moneyTag = @"K.Sh";
    if ([moneyCode isEqualToString:@"UGS"]) moneyTag = @"U.Sh";
    if ([moneyCode isEqualToString:@"TZS"]) moneyTag = @"T.Sh";
    if ([moneyCode isEqualToString:@"RWF"]) moneyTag = @"RF";
    if ([moneyCode isEqualToString:@"BIF"]) moneyTag = @"F.Bu";
    if ([moneyCode isEqualToString:@"ZRZ"]) moneyTag = @"Z";
    if ([moneyCode isEqualToString:@"ZMK"]) moneyTag = @"KW";
    if ([moneyCode isEqualToString:@"MCF"]) moneyTag = @"F.Mg";
    if ([moneyCode isEqualToString:@"SCR"]) moneyTag = @"S.RP(S)";
    if ([moneyCode isEqualToString:@"MUR"]) moneyTag = @"Maur.Rp";
    if ([moneyCode isEqualToString:@"ZWD"]) moneyTag = @"FZIM.$";
    if ([moneyCode isEqualToString:@"KMF"]) moneyTag = @"Com.F";
    
    
    return moneyTag;
}

@end
