//
//  CurrencyTradeRecordHeaderView.m
//  Hunt
//
//  Created by 杨明 on 2018/8/22.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CurrencyTradeRecordHeaderView.h"
#import "HZProgressView.h"
#import "NSString+JLAdd.h"
#import "SEUserDefaults.h"

@interface CurrencyTradeRecordHeaderView()

/* priceBtn */
@property (nonatomic, strong) BaseButton *priceBtn;
/* amount */
@property (nonatomic, strong) BaseLabel *amountLabel;
/* total */
@property (nonatomic, strong) BaseLabel *totalLabel;
/* change */
@property (nonatomic, strong) BaseLabel *changeLabel;
/* progress */
@property (nonatomic, strong) HZProgressView *progressView;
/* buy */
@property (nonatomic, strong) BaseLabel *buyTagLabel;
/* buy */
@property (nonatomic, strong) BaseLabel *buyLabel;
/* sellTag */
@property (nonatomic, strong) BaseLabel *sellTagLabel;
/* sell */
@property (nonatomic, strong) BaseLabel *sellLabel;
/* addView */
@property (nonatomic, strong) BaseView *addView;
/* addBtn */
@property (nonatomic, strong) BaseButton *addBtn;

@end

@implementation CurrencyTradeRecordHeaderView

- (instancetype)init{
    if (self == [super init]) {
        
        self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, AdaptY(264));
        self.backgroundColor = WhiteTextColor;
        [self createUI];
    }
    return self;
}

#pragma mark - action
- (void)priceTouch{
    
}

- (void)addTouch{
    if (self.addBlock) {
        self.addBlock();
    }
}

- (void)setAsset:(Asset *)asset{
    _asset = asset;
    
    [self.priceBtn setTitle:[NSString stringWithFormat:@"%@%@",All,[NSString numberFormatterToAllRMB:asset.marketCap]] forState:UIControlStateNormal];
    self.amountLabel.text = [NSString stringWithFormat:@"%ld %@",asset.quantity,asset.coin.symbol];
    if (asset.changeAmount < 0) {
        self.totalLabel.text = [NSString stringWithFormat:@"-%@",[NSString numberFormatterToAllRMB:-asset.changeAmount]];
    }else{
        self.totalLabel.text = [NSString numberFormatterToAllRMB:asset.changeAmount];
    }
    self.changeLabel.text = [NSString stringWithFormat:@"%.2f%%(%@)",asset.changeRate,Today];
    self.changeLabel.textColor = [[SEUserDefaults shareInstance] getRiseOrFallColor:asset.changeRate >= 0 ? RoseType : FallType];
    
    self.progressView.leftTag = [NSString stringWithFormat:@"%@\n%@",NetCost,[NSString numberFormatterToAllRMB:asset.cost]];
    if (asset.profit != 0 && asset.cost != 0) {
        CGFloat percent = asset.profit / asset.cost;
        self.progressView.rightTag = [NSString stringWithFormat:@"%@(%@)\n%@",Profit,[NSString numberFormatterToPercent:percent],[NSString numberFormatterToAllRMB:asset.profit]];
        self.progressView.progress = 1 - fabs(percent);
    }else{
        self.progressView.rightTag = [NSString stringWithFormat:@"%@(%%0.0)\n%@",Profit,[NSString numberFormatterToAllRMB:asset.cost]];
        self.progressView.progress = 1;
    }
    self.progressView.state = asset.profit < 0 ? ProgressNegState : ProgressOriState;
    self.buyLabel.text = [NSString numberFormatterToAllRMB:asset.avgBuyPrice];
    self.sellLabel.text = [NSString numberFormatterToAllRMB:asset.avgSalePrice];
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.priceBtn];
    [self.priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(MidPadding);
    }];
    
    [self addSubview:self.amountLabel];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.priceBtn.mas_bottom).offset(MidPadding);
    }];
    
    [self addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_centerX).offset(-MinPadding / 2);
        make.top.mas_equalTo(self.amountLabel.mas_bottom).offset(MinPadding);
    }];
    
    [self addSubview:self.changeLabel];
    [self.changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX).offset(MinPadding/2);
        make.centerY.mas_equalTo(self.totalLabel.mas_centerY);
    }];
    
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.totalLabel.mas_bottom).offset(MidPadding);
        make.left.mas_equalTo(self.mas_left).offset(MaxPadding * 2);
        make.right.mas_equalTo(self.mas_right).offset(-MaxPadding * 2);
        make.height.equalTo(@(AdaptY(35)));
    }];
    
    [self addSubview:self.buyTagLabel];
    [self.buyTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.progressView.mas_bottom).offset(MaxPadding);
        make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(0.5);
    }];
    
    [self addSubview:self.buyLabel];
    [self.buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buyTagLabel.mas_bottom).offset(4);
        make.centerX.mas_equalTo(self.buyTagLabel.mas_centerX);
    }];
    
    [self addSubview:self.sellTagLabel];
    [self.sellTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buyTagLabel.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX).multipliedBy(1.5);
    }];
    
    [self addSubview:self.sellLabel];
    [self.sellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sellTagLabel.mas_bottom).offset(4);
        make.centerX.mas_equalTo(self.sellTagLabel.mas_centerX);
    }];
    
    [self addSubview:self.addView];
    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.equalTo(@(AdaptY(50)));
    }];
    
    [self.addView addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.addView.mas_centerY).offset(MidPadding);
        make.left.mas_equalTo(self.mas_left).offset(MaxPadding);
    }];
    
}

#pragma mark - init
- (BaseButton *)priceBtn{
    if (!_priceBtn) { //[ThemeManager imageForKey:@"arrow_down"]
        _priceBtn = [SEFactory buttonWithTitle:@"" image:nil frame:CGRectZero font:Font(11) fontColor:MainTextColor];
//        [_priceBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
        [_priceBtn setContentEdgeInsets:UIEdgeInsetsMake(MinPadding, MaxPadding, MinPadding, MaxPadding)];
        _priceBtn.backgroundColor = [[ThemeManager sharedInstance].themeColor colorWithAlphaComponent:0.05];
        ViewRadius(_priceBtn, AdaptY(25)/2);
        [_priceBtn addTarget:self action:@selector(priceTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceBtn;
}

- (BaseLabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:[UIFont boldSystemFontOfSize:30] textColor:MainTextColor textAlignment:NSTextAlignmentCenter];
    }
    return _amountLabel;
}

- (BaseLabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:[UIFont boldSystemFontOfSize:12] textColor:MainTextColor textAlignment:NSTextAlignmentRight];
    }
    return _totalLabel;
}

- (BaseLabel *)changeLabel{
    if (!_changeLabel) {
        _changeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(10) textColor:BackGreenColor textAlignment:NSTextAlignmentLeft];
    }
    return _changeLabel;
}

- (HZProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[HZProgressView alloc] init];
    }
    return _progressView;
}

- (BaseLabel *)buyTagLabel{
    if (!_buyTagLabel) {
        _buyTagLabel = [SEFactory labelWithText:BuyAveragePrice frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentCenter];
    }
    return _buyTagLabel;
}

- (BaseLabel *)buyLabel{
    if (!_buyLabel) {
        _buyLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:MainTextColor textAlignment:NSTextAlignmentCenter];
    }
    return _buyLabel;
}

- (BaseLabel *)sellTagLabel{
    if (!_sellTagLabel) {
        _sellTagLabel = [SEFactory labelWithText:SellAveragePrice frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentCenter];
    }
    return _sellTagLabel;
}

- (BaseLabel *)sellLabel{
    if (!_sellLabel) {
        _sellLabel = [SEFactory labelWithText:@"￥" frame:CGRectZero textFont:Font(12) textColor:MainTextColor textAlignment:NSTextAlignmentCenter];
    }
    return _sellLabel;
}

- (BaseView *)addView{
    if (!_addView) {
        _addView = [[BaseView alloc] init];
        _addView.backgroundColor = BackGroundColor;
    }
    return _addView;
}

- (BaseButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [SEFactory buttonWithTitle:AddTransactionRecord image:[ThemeManager imageForKey:@"add_small"] frame:CGRectZero font:Font(14) fontColor:MainTextColor];
        [_addBtn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR , @(UIControlStateNormal)]];
        [_addBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:MidPadding];
        [_addBtn setContentEdgeInsets:UIEdgeInsetsMake(0, MinPadding, 0, MinPadding)];
        [_addBtn addTarget:self action:@selector(addTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

@end
