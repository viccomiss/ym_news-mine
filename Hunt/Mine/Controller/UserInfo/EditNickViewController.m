//
//  EditNickViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/7.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "EditNickViewController.h"
#import "UserModel.h"
#import "SEUserDefaults.h"

#define LimitNum 10

@interface EditNickViewController ()<UITextFieldDelegate>

/* back */
@property (nonatomic, strong) BaseView *backView;
/* field */
@property (nonatomic, strong) BaseTextField *nickField;
/* user */
@property (nonatomic, strong) UserModel *user;

@end

@implementation EditNickViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.user = [[SEUserDefaults shareInstance] getUserModel];
    self.nickField.text = self.user.user.nickname.length == 0 ? self.user.user.mobile : self.user.user.nickname;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = EditNickName;
    [self createUI];
}

#pragma mark - action
- (void)saveTouch{
    
    if (self.nickField.text.length == 0) {
        [EasyTextView showText:InputNickName];
        return;
    }
    
    [EasyLoadingView showLoading];
    [UserModel update_nickname:@{@"nickname" : self.nickField.text} Success:^(NSString *code) {
        
        if ([code isEqualToString:@"0"]) {
            [EasyTextView showText:EditSuccess];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - UI
- (void)createUI{
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:Save style:UIBarButtonItemStylePlain target:self action:@selector(saveTouch)];
    self.navigationItem.rightBarButtonItem = save;
    
    [self.view addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH + MidPadding);
        make.left.right.mas_equalTo(self.view);
        make.height.equalTo(@(AdaptY(45)));
    }];
    
    [self.view addSubview:self.nickField];
    [self.nickField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(AdaptX(15));
        make.right.mas_equalTo(self.backView.mas_right).offset(-AdaptX(15));
        make.top.bottom.mas_equalTo(self.backView);
    }];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    int num = [self convertToInt:textField.text];
//    if (range.location < 8) {
//        if ((num + 1) / 2 >= 7) {
//            [textField.text stringByReplacingOccurrencesOfString:string withString:@""];
//            return NO;
//        }
//    }
//    return YES;
//}

-(void)textFieldDidChange:(UITextField *)textField{
    
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
//        int num = [self convertToInt:toBeString];
//        NSLog(@"num === %d",num);
        if (toBeString.length > LimitNum) {
//            char p[1000];
//            strcpy(p,(char *)[toBeString UTF8String]);
//            char t[14];
//            strncpy(t, p + 0, LimitNum);
//            textField.text = [NSString stringWithUTF8String:t];
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:LimitNum];
            if (rangeIndex.length == 1)
            {
                [EasyTextView showText:[NSString stringWithFormat:@"%@%d%@",CanNotExceed,LimitNum,Character]];
                textField.text = [toBeString substringToIndex:LimitNum];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, LimitNum)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
            
        }
    }
}

-  (int)convertToInt:(NSString*)strtemp {
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}
    

#pragma mark - init
- (BaseView *)backView{
    if (!_backView) {
        _backView = [[BaseView alloc] init];
        _backView.backgroundColor = WhiteTextColor;
    }
    return _backView;
}

- (BaseTextField *)nickField{
    if (!_nickField) {
        _nickField = [SEFactory textFieldWithPlaceholder:[NSString stringWithFormat:@"%@(%@%d%@)",InputNickName,CanNotExceed,LimitNum,Character] frame:CGRectZero font:Font(15) fontColor:MainBlackColor];
        _nickField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nickField.delegate = self;
        [_nickField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nickField;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
