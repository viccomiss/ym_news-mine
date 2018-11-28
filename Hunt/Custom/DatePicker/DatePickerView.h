//
//  DatePickerView.h
//  BusinessManager
//
//  Created by 伏董 on 16/3/2.
//  Copyright © 2016年 YHSY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DatePickerView : UIView

/**
 日期选择器

 @param view 触发弹出的view
 @param mode 奇迹选择器格式
 @param format 返回格式
 @param limit 是否限制起始时间为今天开始
 @param block 返回的时间字符串

 */
- (instancetype)initWithView:(UIView *)view withDatePickerMode:(UIDatePickerMode)mode withDateFormat:(NSString *)format limitTime:(BOOL)limit withBlock:(void (^)(NSString *str))block;

@end
