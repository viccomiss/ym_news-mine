//
//  DatePickerView.m
//  BusinessManager
//
//  Created by 伏董 on 16/3/2.
//  Copyright © 2016年 YHSY. All rights reserved.
//

#import "DatePickerView.h"
#import "DateManager.h"

@interface DatePickerView ()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *controllerView;
@property (nonatomic, strong) UIView *referView;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSString *dateFormat;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property  (nonatomic, assign) BOOL limit;

@property (nonatomic,copy) void (^block)(NSString *str);

@end


@implementation DatePickerView

- (instancetype)initWithView:(UIView *)view withDatePickerMode:(UIDatePickerMode)mode withDateFormat:(NSString *)format limitTime:(BOOL)limit withBlock:(void (^)(NSString *))block{
    self = [super init];
    if (self) {
        self.limit = limit;
        self.frame = CGRectMake(0, MAINSCREEN_HEIGHT - (230 + AdaptY(40) + TabbarNSH), MAINSCREEN_WIDTH, 230 + AdaptY(40) + TabbarNSH);
        
        _referView = view;
        _dateFormat = format;
        _block = block;
        
        [self createUIWithMode:mode];
        
    }
    return self;
}


- (void)hide{
    
    [_referView resignFirstResponder];
}

- (void)createUIWithMode:(UIDatePickerMode)mode{
    
    _controllerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH,230 + AdaptY(40))];
    _controllerView.backgroundColor = WhiteTextColor;
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH,230)];
    [_datePicker setDatePickerMode:mode];
    [_datePicker addTarget:self action:@selector(datePickerClick:) forControlEvents:UIControlEventValueChanged];
    
    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    enterButton.frame = CGRectMake(20 * SCALE_WIDTH * 3 + (MAINSCREEN_WIDTH - 20 * SCALE_WIDTH * 4) / 2, _datePicker.easy_bottom, (MAINSCREEN_WIDTH - 20 * SCALE_WIDTH * 4) / 2, 30 * SCALE_HEIGHT);
    [enterButton py_addToThemeColorPool:@"backgroundColor"];
    [enterButton setTitle:Confirm forState:UIControlStateNormal];
    [enterButton addTarget:self action:@selector(enterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    enterButton.layer.masksToBounds = YES;
    enterButton.layer.cornerRadius = 3.0;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(20 * SCALE_WIDTH, _datePicker.easy_bottom,(MAINSCREEN_WIDTH - 20 * SCALE_WIDTH * 4) / 2, 30 *SCALE_HEIGHT);
    [cancelButton setBackgroundColor:FailureTextColor];
    [cancelButton setTitle:Cancel forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = 3.0;
    
    [_controllerView addSubview:_datePicker];
    [_controllerView addSubview:enterButton];
    [_controllerView addSubview:cancelButton];
    
    [self addSubview:_controllerView];
    
    _formatter = [[NSDateFormatter alloc] init];
    _formatter.dateFormat = _dateFormat;
}


#pragma mark -时间选择器触发事件
- (void)datePickerClick:(UIDatePicker *)picker{
    
    self.selectedDate = picker.date;
}

- (void)cancelButtonClicked:(UIButton *)button{

    [self hide];
}

- (void)enterButtonClicked:(UIButton *)button{
    if (self.limit) {
        if ([[NSDate date] timeIntervalSinceDate:_selectedDate] > 0) {
            [EasyLoadingView showLoadingText:@"选择日期不能早于当前时间"];
            return;
        } ;
    }
    NSString * dateString = [_formatter stringFromDate:_selectedDate];

    if (dateString.length == 0) {
        dateString = [_formatter stringFromDate:[NSDate date]];
    }
    
    _block(dateString);
    
    [self hide];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
