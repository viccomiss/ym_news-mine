//
//  FlashHeaderView.m
//  Hunt
//
//  Created by 杨明 on 2018/11/26.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "FlashHeaderView.h"
#import "DateManager.h"

@interface FlashHeaderView()

/* time */
@property (nonatomic, strong) BaseLabel *timeLabel;

@end

@implementation FlashHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = BackGroundColor;
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(MaxPadding);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    return self;
}

- (void)setModel:(flash *)model{
    _model = model;
    NSString *tag = @"";
    
    NSDate* dat = [DateManager dateConvertFrom_YMDHMS_String:[NSString stringWithFormat:@"%@ 23:59:59",[DateManager stringConvert_YMD_FromDate:[NSDate date]]]];
    NSTimeInterval currentTime=[dat timeIntervalSince1970];
    // 时间差
    NSTimeInterval time = currentTime - model.publishDate / 1000;
    NSInteger hours = time/3600;
    if (hours < 24) {
        tag = @"今日 ";
    }
    if (hours >= 24 && hours < 48) {
        tag = @"昨日 ";
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@%@ %@",tag,[[DateManager date_YMD_WithTimeIntervalSince1970:model.publishDate] substringFromIndex:5], [DateManager weekdayStringFromDate:[DateManager dateWithTimeStamp:model.publishDate]]];
}

- (BaseLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

@end
