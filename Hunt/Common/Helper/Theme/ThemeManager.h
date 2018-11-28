//
//  ThemeManager.h
//  Hunt
//
//  Created by 杨明 on 2018/8/6.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 主题管理
 */
@interface ThemeManager : NSObject

+ (ThemeManager *)sharedInstance;

/* themeColor */
@property (nonatomic, strong) UIColor *themeColor;
/* gradientColor */
@property (nonatomic, strong) UIColor *gradientColor;
/* lightThemeColor */
@property (nonatomic, strong) UIColor *lightThemeColor;

//更新主题
- (void)reloadTheme:(ThemeType)themeType needPostNotification:(BOOL)post;

+ (UIImage *)imageForKey:(NSString *)key;

+ (ThemeType)loadThemeInfo;

@end
