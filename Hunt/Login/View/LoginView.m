//
//  LoginView.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "LoginView.h"
#import "UnderLineTextField.h"
#import "AreaPhoneHeaderView.h"
#import "UserModel.h"
#import "WXRWebViewController.h"
#import "CommonUtils.h"
#import "SEUserDefaults.h"
#import "PhoneAreaCodeViewController.h"
#import "DateManager.h"
#import "DeviceInfo.h"
#import "APIManager.h"
#import "NSString+JLAdd.h"
#import "AppInfo.h"

#define LINEHEIGHT AdaptY(45)

@interface LoginView()

/* close */
@property (nonatomic, strong) BaseButton *closeBtn;
@property (nonatomic, strong) BaseLabel *topTagLabel;
/* detail */
@property (nonatomic, strong) BaseLabel *detailLabel;
@property (nonatomic, strong) BaseButton *topChangeBtn;
@property (nonatomic, strong) UnderLineTextField *phoneField;
/* area */
@property (nonatomic, strong) AreaPhoneHeaderView *areaView;
@property (nonatomic, strong) UnderLineTextField *passwordField;
@property (nonatomic, strong) UnderLineTextField *codeField;
@property (nonatomic, strong) BaseButton *loginBtn;
@property (nonatomic, strong) BaseButton *leftBtn;
@property (nonatomic, strong) BaseButton *rightBtn;
@property (nonatomic, strong) BaseButton *clauseBtn;
@property (nonatomic, assign) LoginType type;
@property (nonatomic, strong) BaseButton *timeBtn;
/* phoneAreaTag */
@property (nonatomic, strong) BaseLabel *phoneAreaTagLabel;
/* areaBtn */
@property (nonatomic, strong) BaseButton *areaBtn;

//修改手机号
/* 当前绑定 */
@property (nonatomic, strong) BaseLabel *phoneTag;
/* phone */
@property (nonatomic, strong) BaseLabel *currentPhone;

//修改密码
@property (nonatomic, strong) UnderLineTextField *inputPWField;
@property (nonatomic, strong) UnderLineTextField *confirmNewField;
/* user */
@property (nonatomic, strong) UserModel *user;
/* string */
@property (nonatomic, copy) NSString *client;

@end

@implementation LoginView

- (instancetype)initWithLoginType:(LoginType)type{
    if (self == [super init]) {
        
        self.type = type;
        self.backgroundColor = WhiteTextColor;
        [self createUI];
    }
    return self;
}

//code param
- (NSDictionary *)codeParam{
    NSString *timestamp = [DateManager nowTimeStampString];
    NSString *p = @"ios";
    NSString *d = [[UIDevice currentDevice] systemName];
    NSString *mobile = [NSString stringWithFormat:@"%@-%@",self.areaView.code,self.phoneField.text];
    NSString *v = [NSString stringWithFormat:@"%lu%@%lu%@%lu%@%@",(unsigned long)timestamp.length,timestamp,p.length,p,d.length,d,mobile];
    return @{@"mobile": mobile, @"t": timestamp, @"p": p, @"d": d, @"v": [v md5String]};
}


#pragma mark - check
- (BOOL)checkPhone{
    if (self.phoneField.text.length == 0) {
        [EasyTextView showText:PhoneNumberNotBlank];
        return NO;
    }
    
//    if (self.phoneField.text.length != 11) {
//        [EasyTextView showText:PleaseFillCorrectMobileNumber];
//        return NO;
//    }
    return YES;
}

- (BOOL)checkCode{
    if (self.codeField.text.length == 0) {
        [EasyTextView showText:VerCodeNotBlank];
        return NO;
    }
    if (self.codeField.text.length != 6) {
        [EasyTextView showText:PleaseEnterCorrectVerCode];
        return NO;
    }
    return YES;
}

- (BOOL)checkPassword{
    if (self.passwordField.text.length == 0) {
        [EasyTextView showText:@"密码不能为空"];
        return NO;
    }
    if (self.passwordField.text.length < 6 || self.passwordField.text.length > 25) {
        if (self.type == LoginPasswordType) {
            [EasyTextView showText:@"密码错误"];
        }else{
            [EasyTextView showText:@"密码长度为6-25之间"];
        }
        return NO;
    }
    return YES;
}

- (BOOL)checkNewPassword{
    if (self.inputPWField.text.length == 0) {
        [EasyTextView showText:@"密码不能为空"];
        return NO;
    }
    if (self.inputPWField.text.length < 6 || self.passwordField.text.length > 25) {
        [EasyTextView showText:@"密码长度为6-25之间"];
        return NO;
    }
    return YES;
}

- (BOOL)checkConfirmPassword{
    if (self.confirmNewField.text.length == 0) {
        [EasyTextView showText:@"密码不能为空"];
        return NO;
    }
    if (self.confirmNewField.text.length < 6 || self.passwordField.text.length > 25) {
        [EasyTextView showText:@"密码长度为6-25之间"];
        return NO;
    }
    return YES;
}

#pragma mark - action
- (void)areaTouch{
    PhoneAreaCodeViewController *areaVC = [[PhoneAreaCodeViewController alloc] init];
    [[CommonUtils currentViewController].navigationController pushViewController:areaVC animated:YES];
    WeakSelf(self);
    areaVC.areaBlock = ^(id parameter1, id parameter2) {
        weakself.areaView.code = parameter1;
        [weakself.areaBtn setTitle:parameter2 forState:UIControlStateNormal];
        [weakself.areaBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    };
}

- (void)autoLoginByPassword:(id)param{
//    @{@"password": self.inputPWField.text, @"mobile": self.mobile}
    [EasyLoadingView showLoading];
    [UserModel password_signin:@{@"mobile": [param jk_stringForKey:@"mobile"], @"password" : [param jk_stringForKey:@"password"], @"deviceToken" : [[SEUserDefaults shareInstance] getDeviceToken], @"pusherType" : @"IOS"} Success:^(NSString *responeObject) {
        
        [SENotificationCenter postNotificationName:LOGINSUCCESS object:nil];
        if ([self.delegate respondsToSelector:@selector(dismiss:)]) {
            [self.delegate dismiss:nil];
        }
        
    } Failure:^(NSError *error) {
        
    }];
}


- (void)loginTouch:(BaseButton *)sender{
    
    if (self.type != LoginEditPasswordType && self.type != LoginSetPasswordType) {
        if (![self checkPhone]) return;
    }
    
    switch (self.type) {
        case LoginCheckPhoneType:
        {
            [EasyLoadingView showLoading];
            [UserModel is_mobile_registered:[self codeParam] Success:^(BOOL reg) {
                
                if ([self.delegate respondsToSelector:@selector(loginViewLoginTouch:)]) {
                    [self.delegate loginViewLoginTouch:@{@"code":self.areaView.code,@"mobile": self.phoneField.text, @"reg" : [NSNumber numberWithBool:reg]}];
                }
                
            } Failure:^(NSError *error) {
                
            }];
        }
            break;
        case LoginRegisterType:
        {
            if (![self checkCode]) return;
            [EasyLoadingView showLoading];
            [UserModel signup:@{@"mobile":[NSString stringWithFormat:@"%@-%@",self.areaView.code,self.phoneField.text], @"verifyCode" : self.codeField.text, @"sponsorCode" : self.passwordField.text.length == 0 ? @"" : self.passwordField.text, @"client" : [AppInfo getClient]} Success:^(NSString *code) {
                
                if ([code isEqualToString:@"0"]) {
                    [EasyTextView showText:RegisterSuccess];
                    [SENotificationCenter postNotificationName:LOGINSUCCESS object:nil];
                    if ([self.delegate respondsToSelector:@selector(dismiss:)]) {
                        [self.delegate dismiss:nil];
                    }
                }
                
            } Failure:^(NSError *error) {
                
            }];
        }
            break;
        case LoginCodeType:
        {
            if (![self checkCode]) return;
            
            [EasyLoadingView showLoading];
            [UserModel signin:@{@"mobile": [NSString stringWithFormat:@"%@-%@",self.areaView.code,self.phoneField.text], @"verifyCode" : self.codeField.text, @"client" : [AppInfo getClient]} Success:^(NSString *code) {
                
                if ([code isEqualToString:@"0"]) {
                    [EasyTextView showText:LoginSuccess];
                    [SENotificationCenter postNotificationName:LOGINSUCCESS object:nil];
                    if ([self.delegate respondsToSelector:@selector(dismiss:)]) {
                        [self.delegate dismiss:nil];
                    }
                    [UMAnalyticsHelper event:login_wc];
                }
                
            } Failure:^(NSError *error) {
                
            }];
        }
            break;
        case LoginPasswordType:
        {
            if (![self checkPassword]) return;
            
            [EasyLoadingView showLoading];
            [UserModel password_signin:@{@"mobile": [NSString stringWithFormat:@"%@-%@",self.areaView.code,self.phoneField.text], @"password" : self.passwordField.text, @"deviceToken" : [[SEUserDefaults shareInstance] getDeviceToken], @"pusherType" : @"IOS"} Success:^(NSString *responeObject) {
                
                [SENotificationCenter postNotificationName:LOGINSUCCESS object:nil];
                if ([self.delegate respondsToSelector:@selector(dismiss:)]) {
                    [self.delegate dismiss:nil];
                }
                
            } Failure:^(NSError *error) {
                
            }];
        }
            break;
        case LoginFindPasswordType:
        case LoginUserFindPasswordType:
        {
            if (![self checkCode]) return;
            
            if (![self checkPassword]) return;
            
            [EasyLoadingView showLoading];
            [UserModel verify_password:@{@"mobile": [NSString stringWithFormat:@"%@-%@",self.areaView.code,self.phoneField.text], @"verifyCode" : self.codeField.text, @"password": self.passwordField.text} Success:^(NSString *code) {
                
                if ([code isEqualToString:@"0"]) {
                    [EasyTextView showText:@"修改成功,请重新登录"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([self.delegate respondsToSelector:@selector(dismiss:)]) {
                            [self.delegate dismiss:nil];
                        }
                    });
                }
                
            } Failure:^(NSError *error) {
                
            }];
        }
            break;
//        case LoginEditPhoneType:
//        {
//            if (![self checkCode]) return;
//
//            [EasyLoadingView showLoading];
//            [UserModel changePhone:@{@"phone" : self.phoneField.text, @"captcha" : self.codeField.text} Success:^(UserModel *user) {
//
//                [EasyTextView showText:@"修改成功"];
//                self.user = user;
//                self.currentPhone.text = self.user.cell;
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    if ([self.delegate respondsToSelector:@selector(dismiss:)]) {
//                        [self.delegate dismiss:nil];
//                    }
//                });
//
//            } Failure:^(NSError *error) {
//
//            }];
//        }
//            break;
        case LoginEditPasswordType:
        {
            if (![self checkPassword]) return;
            
            if (![self checkNewPassword]) return;
            
            if (![self checkConfirmPassword]) return;
            
            if (![self.inputPWField.text isEqualToString:self.confirmNewField.text]) {
                [EasyTextView showText:@"两次输入密码不一致"];
                return;
            }
            
            [EasyLoadingView showLoading];
            [UserModel update_password:@{@"oldPassword": self.passwordField.text, @"newPassword" : self.confirmNewField.text} Success:^(NSString *code) {
                
                if ([code isEqualToString:@"0"]) {
                    [EasyTextView showText:@"修改成功"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([self.delegate respondsToSelector:@selector(dismiss:)]) {
                            [self.delegate dismiss:nil];
                        }
                    });
                }
                
            } Failure:^(NSError *error) {
                
            }];
        }
            break;
        case LoginSetPasswordType:
        {
            if (![self checkNewPassword]) return;
            
            if (![self checkConfirmPassword]) return;
            
            if (![self.inputPWField.text isEqualToString:self.confirmNewField.text]) {
                [EasyTextView showText:@"两次输入密码不一致"];
                return;
            }
            
            [EasyLoadingView showLoading];
            NSDictionary *param = @{@"password": self.inputPWField.text, @"mobile": self.mobile};
            [UserModel set_password:param Success:^(NSString *code) {
                
                if ([code isEqualToString:@"0"]) {
                    [EasyTextView showText:@"设置成功"];
                    if ([self.delegate respondsToSelector:@selector(dismiss:)]) {
                        [self.delegate dismiss:param];
                    }
                }
                
            } Failure:^(NSError *error) {
                
            }];
        }
            break;
        default:
            break;
    }
}

- (void)changeLoginType:(BaseButton *)sender{
    sender.selected = !sender.selected;
    self.type = sender.selected ? LoginCodeType : LoginPasswordType;
    [self createUI];
}

- (void)leftTouch:(BaseButton *)sender{
    if ([self.delegate respondsToSelector:@selector(loginViewLeftTouch)]) {
        [self.delegate loginViewLeftTouch];
    }
}

- (void)rightTouch:(BaseButton *)sender{
    if ([self.delegate respondsToSelector:@selector(loginViewRightTouch)]) {
        [self.delegate loginViewRightTouch];
    }
}

- (void)clauseTouch{
    WXRWebViewController *webVC = [[WXRWebViewController alloc] init];
    webVC.dataFrom = WXRWebViewControllerDataFromAgreenment;
    [[CommonUtils currentViewController].navigationController pushViewController:webVC animated:YES];
}

- (void)closeTouch{
    if ([self.delegate respondsToSelector:@selector(dismiss:)]) {
        [self.delegate dismiss:nil];
    }
}

- (void)timeTouch:(BaseButton *)sender{
    
    if (self.type == LoginRegisterType) {
        [UserModel send_signup_code:[self codeParam] Success:^(NSString *code) {
            if ([code isEqualToString:@"0"]) {
                [EasyTextView showText:VerCodeSentSuccess];
            }
        } Failure:^(NSError *error) {
            
        }];
    }else if (self.type == LoginCodeType){
        [UserModel send_signin_code:[self codeParam] Success:^(NSString *code) {
            if ([code isEqualToString:@"0"]) {
                [EasyTextView showText:VerCodeSentSuccess];
            }
        } Failure:^(NSError *error) {
            
        }];
    }
    [UMAnalyticsHelper event:login_hqyzm];
    
    __block int timeout = 29; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置（倒计时结束后调用）
                [self.timeBtn setTitle:SendVerificationCode forState:UIControlStateNormal];
                [self.timeBtn setTitleColor:[ThemeManager sharedInstance].themeColor forState:UIControlStateNormal];
                //设置不可点击
                self.timeBtn.userInteractionEnabled = YES;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                NSLog(@"____%@",strTime);
                [self.timeBtn setTitle:[NSString stringWithFormat:@"%@s%@",strTime,Retry] forState:UIControlStateNormal];
                self.timeBtn.userInteractionEnabled = NO;
                [self.timeBtn setTitleColor:TextDarkGrayColor forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - set
- (void)seePassword:(BaseButton *)sender{
    sender.selected = !sender.selected;
    self.passwordField.secureTextEntry = !sender.selected;
}

- (void)setMobileParam:(id)mobileParam{
    _mobileParam = mobileParam;
    
    self.areaView.code = [mobileParam jk_stringForKey:@"code"];
    self.phoneField.text =  [mobileParam jk_stringForKey:@"mobile"];
    [self timeTouch:self.timeBtn];
}

#pragma mark - UI
- (void)createUI{
    
    self.user = [[SEUserDefaults shareInstance] getUserModel];
    
    switch (self.type) {
        case LoginCheckPhoneType:
        {
            [self addLoginLayer];
            [self addPhoneAreaLayer];
            
            [self addSubview:self.phoneField];
            [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left).offset(AdaptX(20));
                make.right.mas_equalTo(self.mas_right).offset(-AdaptX(20));
                make.top.mas_equalTo(self.phoneAreaTagLabel.mas_bottom).offset(AdaptY(35));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            [self addSubview:self.loginBtn];
            [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.phoneField.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            self.topTagLabel.text = Login;
            [self.loginBtn setTitle:Next forState:UIControlStateNormal];
            self.detailLabel.text = LoginSummary;
        }
            break;
        case LoginCodeType:
        {
            [self addLoginLayer];
//            [self addPhoneAreaLayer];
            self.detailLabel.hidden = YES;
            
            [self addSubview:self.phoneField];
            [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left).offset(AdaptX(20));
                make.right.mas_equalTo(self.mas_right).offset(-AdaptX(20));
                make.top.mas_equalTo(self.topTagLabel.mas_bottom).offset(AdaptY(50));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            [self addSubview:self.codeField];
            [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.phoneField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.loginBtn];
            [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.codeField.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
//            [self addSubview:self.leftBtn];
//            [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(self.loginBtn.mas_left);
//                make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(MidPadding);
//            }];
//
//            [self addSubview:self.rightBtn];
//            [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(self.loginBtn.mas_right);
//                make.top.mas_equalTo(self.leftBtn.mas_top);
//            }];
            
            self.passwordField.hidden = YES;
            self.codeField.hidden = NO;
            self.topChangeBtn.hidden = NO;
            
            self.topTagLabel.text = Login;
//            [self.leftBtn setTitle:LocalizedString(@"忘记密码?") forState:UIControlStateNormal];
//            [self.rightBtn setTitle:LocalizedString(@"手机号注册") forState:UIControlStateNormal];
        }
            break;
        case LoginPasswordType:
        {
            [self addLoginLayer];
            [self addPhoneAreaLayer];

            [self addSubview:self.phoneField];
            [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left).offset(AdaptX(20));
                make.right.mas_equalTo(self.mas_right).offset(-AdaptX(20));
                make.top.mas_equalTo(self.phoneAreaTagLabel.mas_bottom).offset(AdaptY(35));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            [self addSubview:self.passwordField];
            [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.phoneField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.loginBtn];
            [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.passwordField.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            [self addSubview:self.leftBtn];
            [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.loginBtn.mas_left);
                make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(MidPadding);
            }];
            
            [self addSubview:self.rightBtn];
            [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.loginBtn.mas_right);
                make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(MidPadding);
            }];
            
            [self addSubview:self.clauseBtn];
            [self.clauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.mas_bottom).offset(-AdaptY(30));
                make.left.right.mas_equalTo(self);
            }];

            self.passwordField.hidden = NO;
            self.codeField.hidden = YES;
            self.topChangeBtn.hidden = NO;
            
            self.passwordField.placeholder = InputPassword;
            self.topTagLabel.text = LocalizedString(@"登录");
            [self.leftBtn setTitle:LocalizedString(@"忘记密码?") forState:UIControlStateNormal];
            [self.rightBtn setTitle:LocalizedString(@"手机号注册") forState:UIControlStateNormal];
        }
            break;
        case LoginRegisterType:
        {
            [self addLoginLayer];
            self.detailLabel.hidden = YES;
            self.closeBtn.hidden = YES;
            
            [self addSubview:self.phoneField];
            [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left).offset(AdaptX(20));
                make.right.mas_equalTo(self.mas_right).offset(-AdaptX(20));
                make.top.mas_equalTo(self.topTagLabel.mas_bottom).offset(AdaptY(50));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            [self addSubview:self.codeField];
            [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.phoneField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.passwordField];
            [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.codeField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.loginBtn];
            [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.passwordField.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            self.topChangeBtn.hidden = YES;
            
            self.passwordField.placeholder = LoginInviteSummary;
            self.passwordField.secureTextEntry = NO;
            self.topTagLabel.text = Login;
            [self.loginBtn setTitle:Login forState:UIControlStateNormal];
        }
            break;
        case LoginFindPasswordType:
        {
            [self addLoginLayer];
            [self addPhoneAreaLayer];

            [self addSubview:self.phoneField];
            [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left).offset(AdaptX(20));
                make.right.mas_equalTo(self.mas_right).offset(-AdaptX(20));
                make.top.mas_equalTo(self.phoneAreaTagLabel.mas_bottom).offset(AdaptY(35));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            [self addSubview:self.codeField];
            [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.phoneField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.passwordField];
            [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.codeField.mas_bottom).offset(AdaptY(20));
            }];
           
            [self addSubview:self.loginBtn];
            [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.passwordField.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            self.topChangeBtn.hidden = YES;
            
            self.phoneField.text = self.user.user.mobile.length != 0 ? self.user.user.mobile : @"";
            self.passwordField.placeholder = SetNewPassword;
            self.topTagLabel.text = LocalizedString(@"找回密码");
            [self.loginBtn setTitle:Done forState:UIControlStateNormal];
        }
            break;
        case LoginUserFindPasswordType:
        {
            [self addPhoneAreaLayer];
            
            [self addSubview:self.phoneField];
            [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.mas_left).offset(AdaptX(20));
                make.right.mas_equalTo(self.mas_right).offset(-AdaptX(20));
                make.top.mas_equalTo(self.phoneAreaTagLabel.mas_bottom).offset(AdaptY(35));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            [self addSubview:self.codeField];
            [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.phoneField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.passwordField];
            [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.codeField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.loginBtn];
            [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.passwordField.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            self.phoneField.text = self.user.user.mobile.length != 0 ? self.user.user.mobile : @"";
            self.passwordField.placeholder = SetNewPassword;
            [self.loginBtn setTitle:Done forState:UIControlStateNormal];
        }
            break;
            case LoginEditPhoneType:
        {
            
            [self addSubview:self.phoneField];
            [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.mas_right).offset(-AdaptX(40));
                make.left.mas_equalTo(self.mas_left).offset(AdaptX(40));
                make.top.mas_equalTo(self.currentPhone.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            [self addSubview:self.codeField];
            [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.phoneField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.loginBtn];
            [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.phoneField);
                make.top.mas_equalTo(self.codeField.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            self.phoneField.placeholder = @"请输入新手机号";
            [self.loginBtn setTitle:@"确认修改" forState:UIControlStateNormal];
            self.currentPhone.text = self.user.user.mobile;

        }
            break;
            case LoginEditPasswordType:
        {
            
            [self addSubview:self.passwordField];
            [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.mas_right).offset(-AdaptX(20));
                make.left.mas_equalTo(self.mas_left).offset(AdaptX(20));
                make.top.mas_equalTo(self.mas_top).offset(AdaptY(30) + NavbarH);
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            [self addSubview:self.inputPWField];
            [self.inputPWField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.passwordField);
                make.top.mas_equalTo(self.passwordField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.confirmNewField];
            [self.confirmNewField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.passwordField);
                make.top.mas_equalTo(self.inputPWField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.loginBtn];
            [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.passwordField);
                make.top.mas_equalTo(self.confirmNewField.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(AdaptY(46)));
            }];
            
            [self addSubview:self.rightBtn];
            [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.loginBtn.mas_right);
                make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(MidPadding);
            }];
            
            self.passwordField.placeholder = InputOldPassword;
            [self.loginBtn setTitle:Done forState:UIControlStateNormal];
            self.inputPWField.placeholder = SetNewPassword;
            self.confirmNewField.placeholder = SetNewPasswordAgain;
            [self.rightBtn setTitle:ForgetPasswordFindByMobile forState:UIControlStateNormal];
        }
            break;
        case LoginSetPasswordType:
        {
            [self addLoginLayer];
            
            [self addSubview:self.inputPWField];
            [self.inputPWField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.mas_right).offset(-AdaptX(20));
                make.left.mas_equalTo(self.mas_left).offset(AdaptX(20));
                make.height.equalTo(@(LINEHEIGHT));
                make.top.mas_equalTo(self.topTagLabel.mas_bottom).offset(AdaptY(50));
            }];
            
            [self addSubview:self.confirmNewField];
            [self.confirmNewField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.height.mas_equalTo(self.inputPWField);
                make.top.mas_equalTo(self.inputPWField.mas_bottom).offset(AdaptY(20));
            }];
            
            [self addSubview:self.loginBtn];
            [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.inputPWField);
                make.top.mas_equalTo(self.confirmNewField.mas_bottom).offset(AdaptY(40));
                make.height.equalTo(@(LINEHEIGHT));
            }];
            
            self.topChangeBtn.hidden = YES;
            
            self.topTagLabel.text = LocalizedString(@"设置密码");
            [self.loginBtn setTitle:Done forState:UIControlStateNormal];
            self.inputPWField.placeholder = SetNewPassword;
            self.confirmNewField.placeholder = SetNewPasswordAgain;
        }
            break;
        default:
            break;
    }
    
}

- (void)addLoginLayer{
    
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(StatusBarH + MidPadding);
        make.right.mas_equalTo(self.mas_right).offset(-MidPadding);
        make.size.mas_equalTo(CGSizeMake(AdaptX(44), AdaptX(44)));
    }];
    
    [self addSubview:self.topTagLabel];
    [self.topTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.closeBtn.mas_bottom).offset(AdaptY(20));
        make.left.mas_equalTo(self.mas_left).offset(AdaptX(20));
    }];
    
//    [self addSubview:self.topChangeBtn];
//    [self.topChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.topTagLabel.mas_bottom);
//        make.right.mas_equalTo(self.mas_right).offset(-AdaptX(20));
//    }];
    [self addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topTagLabel.mas_bottom).offset(2 * MidPadding);
        make.left.mas_equalTo(self.topTagLabel.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-2 * MidPadding);
    }];
}

- (void)addPhoneAreaLayer{
    
    [self addSubview:self.phoneAreaTagLabel];
    [self.phoneAreaTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.type != LoginUserFindPasswordType) {
            make.left.mas_equalTo(self.topTagLabel);
            make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(AdaptY(40));
        }else{
            make.left.mas_equalTo(self.mas_left).offset(AdaptX(20));
            make.top.mas_equalTo(self.mas_top).offset(NavbarH + AdaptY(30));
        }
    }];
    
    [self addSubview:self.areaBtn];
    [self.areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-AdaptX(20));
        make.centerY.mas_equalTo(self.phoneAreaTagLabel.mas_centerY);
    }];
}

#pragma mark - textfield delegate
- (void)textFieldDidChange:(UITextField *)sender{
    if (self.type == LoginCheckPhoneType && sender == self.phoneField) {
        
        if (sender.text.length == 0) {
            [self.loginBtn.layer insertSublayer:[UIColor setGradualChangingColor:self.loginBtn fromColor:LightGrayColor toColor:LightGrayColor] below:self.loginBtn.imageView.layer];
            self.loginBtn.userInteractionEnabled = NO;
        }else{
            [self.loginBtn.layer insertSublayer:[UIColor setGradualChangingColor:self.loginBtn fromColor:[ThemeManager sharedInstance].gradientColor toColor:[ThemeManager sharedInstance].themeColor] below:self.loginBtn.imageView.layer];
            self.loginBtn.userInteractionEnabled = YES;
        }
        
    }else if (self.type == LoginCodeType || self.type == LoginRegisterType ){
        if (sender == self.codeField) {
            if (sender.text.length == 0) {
                [self.loginBtn.layer insertSublayer:[UIColor setGradualChangingColor:self.loginBtn fromColor:LightGrayColor toColor:LightGrayColor] below:self.loginBtn.imageView.layer];
                self.loginBtn.userInteractionEnabled = NO;
            }else{
                [self.loginBtn.layer insertSublayer:[UIColor setGradualChangingColor:self.loginBtn fromColor:[ThemeManager sharedInstance].gradientColor toColor:[ThemeManager sharedInstance].themeColor] below:self.loginBtn.imageView.layer];
                self.loginBtn.userInteractionEnabled = YES;
            }
        }
    }
}

#pragma mark - init
- (BaseLabel *)topTagLabel{
    if (!_topTagLabel) {
        _topTagLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:[UIFont boldSystemFontOfSize:30] textColor:MainBlackColor textAlignment:NSTextAlignmentLeft];
    }
    return _topTagLabel;
}

- (BaseLabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (BaseButton *)topChangeBtn{
    if (!_topChangeBtn) {
        _topChangeBtn = [SEFactory buttonWithTitle:LocalizedString(@"切换手机验证码登录") image:nil frame:CGRectZero font:Font(14) fontColor:MainBlackColor];
        [_topChangeBtn setTitle:LocalizedString(@"切换密码登录") forState:UIControlStateSelected];
        [_topChangeBtn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateNormal)]];
        [_topChangeBtn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateSelected)]];
        [_topChangeBtn addTarget:self action:@selector(changeLoginType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topChangeBtn;
}

- (BaseLabel *)phoneAreaTagLabel{
    if (!_phoneAreaTagLabel) {
        _phoneAreaTagLabel = [SEFactory labelWithText:MobileAreaCode frame:CGRectZero textFont:Font(14) textColor:MainBlackColor textAlignment:NSTextAlignmentLeft];
    }
    return _phoneAreaTagLabel;
}

- (BaseButton *)areaBtn{
    if (!_areaBtn) {
        _areaBtn = [SEFactory buttonWithTitle:China image:ImageName(@"arrow_right_black") frame:CGRectZero font:Font(14) fontColor:MainBlackColor];
        [_areaBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        [_areaBtn addTarget:self action:@selector(areaTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _areaBtn;
}

- (BaseButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [SEFactory buttonWithImage:ImageName(@"close_black")];
        [_closeBtn addTarget:self action:@selector(closeTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (BaseButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [SEFactory buttonWithTitle:Login image:nil frame:CGRectMake(0, 0, MAINSCREEN_WIDTH - AdaptX(40), LINEHEIGHT) font:Font(16) fontColor:WhiteTextColor];
        ViewRadius(_loginBtn, AdaptX(5));
        [_loginBtn.layer insertSublayer:[UIColor setGradualChangingColor:_loginBtn fromColor:LightGrayColor toColor:LightGrayColor] below:_loginBtn.imageView.layer];
        _loginBtn.userInteractionEnabled = NO;
        [_loginBtn addTarget:self action:@selector(loginTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (BaseButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [SEFactory buttonWithTitle:LocalizedString(@"忘记密码") image:nil frame:CGRectZero font:Font(13) fontColor:MainBlackColor];
        [_leftBtn addTarget:self action:@selector(leftTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (BaseButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [SEFactory buttonWithTitle:LocalizedString(@"手机号注册") image:nil frame:CGRectZero font:Font(13) fontColor:MainBlackColor];
        [_rightBtn addTarget:self action:@selector(rightTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

//- (BaseButton *)clauseBtn{
//    if (!_clauseBtn) {
//        NSString *str = @"登录即表示同意《快比特服务条款》";
//        _clauseBtn = [SEFactory buttonWithTitle:str image:nil frame:CGRectZero font:Font(12) fontColor:TextDarkLightGrayColor];
//        [_clauseBtn addTarget:self action:@selector(clauseTouch) forControlEvents:UIControlEventTouchUpInside];
//
//        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
//        [attributeStr addAttribute:NSForegroundColorAttributeName
//                             value:MainYellowColor
//                             range:NSMakeRange(7, 9)];
//        [attributeStr addAttribute:NSForegroundColorAttributeName value:TextDarkLightGrayColor range:NSMakeRange(0, 7)];
//        [attributeStr addAttribute:NSFontAttributeName value:Font(12) range:NSMakeRange(0, str.length)];
//        _clauseBtn.titleLabel.attributedText = attributeStr;
//    }
//    return _clauseBtn;
//}

- (UnderLineTextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [[UnderLineTextField alloc] initWithFrame:CGRectZero];
        _phoneField.placeholder = InputMobile;
        _phoneField.textColor = MainBlackColor;
        _phoneField.font = Font(14);
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneField.limitNum = 11;
        [_phoneField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.areaView = [AreaPhoneHeaderView areaPhoneHeaderViewWithFrame:CGRectMake(3, 0, AdaptX(55), LINEHEIGHT) headStrBlock:^(id parameter) {
            
        }];
        
        self.areaView.code = @"86";
        _phoneField.leftView = self.areaView;
        _phoneField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _phoneField;
}

- (UnderLineTextField *)codeField{
    if (!_codeField) {
        _codeField = [[UnderLineTextField alloc] initWithFrame:CGRectZero];
        _codeField.placeholder = InputVerificationCode;
        _codeField.textColor = MainBlackColor;
        _codeField.font = Font(14);
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
        _codeField.rightView = self.timeBtn;
        _codeField.rightViewMode = UITextFieldViewModeAlways;
        [_codeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _codeField.limitNum = 6;
    }
    return _codeField;
}

- (BaseButton *)timeBtn{
    if (!_timeBtn) {
        _timeBtn = [SEFactory buttonWithTitle:GetVerificationCode frame:CGRectMake(0, 0, AdaptX(120), LINEHEIGHT) font:Font(15) fontColor:MainBlackColor];
        [_timeBtn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateNormal)]];
        _timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_timeBtn addTarget:self action:@selector(timeTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeBtn;
}

- (UnderLineTextField *)passwordField{
    if (!_passwordField) {
        _passwordField = [[UnderLineTextField alloc] initWithFrame:CGRectZero];
        _passwordField.placeholder = InputPassword;
        _passwordField.textColor = MainBlackColor;
        _passwordField.font = Font(14);
        _passwordField.secureTextEntry = YES;
        
//        BaseButton *seeBtn = [SEFactory buttonWithImage:ImageName(@"password_open") frame:CGRectMake(0, 0, LINEHEIGHT, LINEHEIGHT)];
//        seeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
////        [seeBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
//        [seeBtn setImage:ImageName(@"password_close") forState:UIControlStateSelected];
//        [seeBtn addTarget:self action:@selector(seePassword:) forControlEvents:UIControlEventTouchUpInside];
//
//        _passwordField.rightView = seeBtn;
//        _passwordField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _passwordField;
}

- (UnderLineTextField *)inputPWField{
    if (!_inputPWField) {
        _inputPWField = [[UnderLineTextField alloc] initWithFrame:CGRectZero];
        _inputPWField.placeholder = SetNewPassword;
        _inputPWField.textColor = MainBlackColor;
        _inputPWField.font = Font(14);
        _inputPWField.secureTextEntry = YES;
    }
    return _inputPWField;
}

- (UnderLineTextField *)confirmNewField{
    if (!_confirmNewField) {
        _confirmNewField = [[UnderLineTextField alloc] initWithFrame:CGRectZero];
        _confirmNewField.placeholder = SetNewPasswordAgain;
        _confirmNewField.textColor = MainBlackColor;
        _confirmNewField.font = Font(14);
        _confirmNewField.secureTextEntry = YES;
    }
    return _confirmNewField;
}

- (BaseLabel *)phoneTag{
    if (!_phoneTag) {
        _phoneTag = [SEFactory labelWithText:@"当前绑定手机号" frame:CGRectZero textFont:Font(12) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentCenter];
    }
    return _phoneTag;
}

- (BaseLabel *)currentPhone{
    if (!_currentPhone) {
        _currentPhone = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(18) textColor:WhiteTextColor textAlignment:NSTextAlignmentCenter];
    }
    return _currentPhone;
}

@end
