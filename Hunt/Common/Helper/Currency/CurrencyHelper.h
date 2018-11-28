//
//  CurrencyHelper.h
//  Hunt
//
//  Created by 杨明 on 2018/8/27.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyHelper : NSObject

+ (instancetype)standardHelper;

//支持币种集合
+ (NSArray *)currencies;

//币种name
+ (NSArray *)currenciesNameArr;

//当前货币
+ (NSString *)currentCurrency;

//切换币种
+ (void)setCurrency:(NSString *)currency;

//币种符号
+ (NSString *)currencyTag;

@end
