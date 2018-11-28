//
//  ThemeManager.m
//  Hunt
//
//  Created by 杨明 on 2018/8/6.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "ThemeManager.h"

static NSString *ThemeKey = @"themeKey";

@interface ThemeManager()

/* theme */
@property (nonatomic, strong) NSDictionary *theme;
/* type */
@property (nonatomic, assign) ThemeType themeType;

@end

@implementation ThemeManager

+ (ThemeManager *)sharedInstance
{
    static ThemeManager *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        sharedInstance = [[ThemeManager alloc] init];
    }
    return sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        [self reloadTheme:[ThemeManager loadThemeInfo] needPostNotification:NO];
    }
    return self;
}

- (void)reloadTheme:(ThemeType)themeType needPostNotification:(BOOL)post{
    self.themeType = themeType;
    NSString *path = [[NSBundle mainBundle] pathForResource:[self themeDataWithType:themeType] ofType:@"plist"];
    self.theme = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *rgbArr = [self.theme objectForKey:@"themeColor"];
    NSArray *gradientArr = [self.theme objectForKey:@"gradientColor"];
    NSArray *lightThemeArr = [self.theme objectForKey:@"lightThemeColor"];
    self.themeColor = RGBColor([rgbArr[0] integerValue], [rgbArr[1] integerValue], [rgbArr[2] integerValue]);
    self.gradientColor = RGBColor([gradientArr[0] integerValue], [gradientArr[1] integerValue], [gradientArr[2] integerValue]);
    self.lightThemeColor = RGBColor([lightThemeArr[0] integerValue], [lightThemeArr[1] integerValue], [lightThemeArr[2] integerValue]);
    [self py_setThemeColor:self.themeColor];
    
    if (post) {
        [SENotificationCenter postNotificationName:SKINCHANGESUCCESS object:self.themeColor];
        [self saveThemeInfo];
    }
}

- (NSString *)themeDataWithType:(ThemeType)type{
    switch (type) {
        case ThemeBlueType:
            return @"theme_blue";
            break;
        case ThemeOrangeType:
            return @"theme_orange";
            break;
    }
}

+ (UIImage *)imageForKey:(NSString *)key{
    NSDictionary *theme = [ThemeManager sharedInstance].theme;
    NSString *imageName = [theme objectForKey:key];
    return [UIImage imageNamed:imageName];
}

- (void)saveThemeInfo{
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithUnsignedInteger:self.themeType] forKey:ThemeKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (ThemeType)loadThemeInfo{
    NSNumber *themeType = [[NSUserDefaults standardUserDefaults]objectForKey:ThemeKey];
    return themeType != nil ? [themeType unsignedIntegerValue] : ThemeBlueType;
}

@end
