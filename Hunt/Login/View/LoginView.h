//
//  LoginView.h
//  nuoee_krypto
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol loginViewDelegate<NSObject>

@optional
- (void)loginViewLeftTouch;

- (void)loginViewRightTouch;

- (void)loginViewClauseTouch;

- (void)loginViewLoginTouch:(id)param;

- (void)dismiss:(id)param;

@end

@interface LoginView : UIView

- (instancetype)initWithLoginType:(LoginType)type;

@property (nonatomic, weak) id<loginViewDelegate> delegate;

/* mobile */
@property (nonatomic, copy) NSString *mobile;
/* mobilePar */
@property (nonatomic, strong) id mobileParam;

//设置密码自动登录
- (void)autoLoginByPassword:(id)param;

@end
