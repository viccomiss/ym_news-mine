//
//  LocalizedHelper.h
//  Hunt
//
//  Created by 杨明 on 2018/7/25.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LocalizedString(key) [[LocalizedHelper standardHelper] stringWithKey:key]

@interface LocalizedHelper : NSObject

+ (instancetype)standardHelper;
    
- (NSBundle *)bundle;
    
- (NSString *)currentLanguage;
    
- (void)setUserLanguage:(NSString *)language;
    
- (NSString *)stringWithKey:(NSString *)key;
    
@end
