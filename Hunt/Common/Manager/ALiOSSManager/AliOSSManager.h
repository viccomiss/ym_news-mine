//
//  AliOSSManager.h
//  SuperEducation
//
//  Created by 123 on 2017/3/8.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enumeration.h"

typedef NS_ENUM(NSInteger, UploadImageState) {
    UploadImageFailed   = 0,
    UploadImageSuccess  = 1
};

@interface AliOSSManager : NSObject
+ (instancetype)sharedInstance;

- (void)setupEnvironmentWith:(id)setParamete;

- (void)uploadObjectAsync:(NSData *)data fileType:(FileType)type backBlock:(BaseIdBlock)backBlock;

- (void)downloadObjectAsync;

//- (void)resumableUpload;
@end
