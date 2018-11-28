//
//  CurrencyTradeRecordSectionHeaderView.m
//  Hunt
//
//  Created by 杨明 on 2018/8/22.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CurrencyTradeRecordSectionHeaderView.h"
#import "DateManager.h"

@interface CurrencyTradeRecordSectionHeaderView()

/* tag */
@property (nonatomic, strong) BaseLabel *tagLabel;
/* time */
@property (nonatomic, strong) BaseLabel *timeLabel;

@end

@implementation CurrencyTradeRecordSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (void)setModel:(Transaction *)model{
    _model = model;
    self.tagLabel.backgroundColor = model.type == TransactionBuyType ? BackRedColor : BackGreenColor;
    self.tagLabel.text = model.type == TransactionBuyType ? BuyInitials : SellInitials;
    self.timeLabel.text = [DateManager date_YMDHM_WithTimeIntervalSince1970:model.time];
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(AdaptX(18));
        make.size.mas_equalTo(CGSizeMake(AdaptX(20), AdaptX(20)));
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagLabel.mas_right).offset(MidPadding);
        make.centerY.mas_equalTo(self.tagLabel.mas_centerY);
    }];
}

#pragma mark - init
- (BaseLabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(10) textColor:WhiteTextColor textAlignment:NSTextAlignmentCenter];
        _tagLabel.backgroundColor = BackRedColor;
        ViewRadius(_tagLabel, AdaptX(10));
    }
    return _tagLabel;
}
- (BaseLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

@end
