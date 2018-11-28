//
//  CollectedManager.m
//  Hunt
//
//  Created by 杨明 on 2018/8/28.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CollectedManager.h"

@interface CollectedManager()

/* collectArr */
@property (nonatomic, strong) NSMutableArray *collectArray;

@end

@implementation CollectedManager

+ (instancetype)standardManager {
    static CollectedManager *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[CollectedManager alloc] init];
    });
    return helper;
}

- (instancetype)init{
    if (self == [super init]) {
        
        self.collectArray = [NSMutableArray array];
    }
    return self;
}

+ (void)addCollect:(NSString *)ID{
    [[CollectedManager standardManager].collectArray addObject:ID];
}

+ (void)removeCollect:(NSString *)ID{
    [[CollectedManager standardManager].collectArray removeObject:ID];
}

+ (void)addCollections:(NSArray *)collections{
    [[CollectedManager standardManager].collectArray addObjectsFromArray:collections];
}

+ (void)resumeCollections:(NSArray *)collections{
    [CollectedManager standardManager].collectArray = [NSMutableArray arrayWithArray:collections];
}

+ (NSArray *)collections{
    return [CollectedManager standardManager].collectArray;
}


@end
