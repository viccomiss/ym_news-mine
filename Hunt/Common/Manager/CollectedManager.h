//
//  CollectedManager.h
//  Hunt
//
//  Created by 杨明 on 2018/8/28.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 自选管理
 */
@interface CollectedManager : NSObject

+ (instancetype)standardManager;

+ (void)addCollect:(NSString *)ID;

+ (void)removeCollect:(NSString *)ID;

+ (NSArray *)collections;

+ (void)addCollections:(NSArray *)collections;

//服务器同步
+ (void)resumeCollections:(NSArray *)collections;

@end
