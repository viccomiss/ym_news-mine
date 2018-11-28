//
//  CurrencyAssetsHeaderView.m
//  Hunt
//
//  Created by 杨明 on 2018/8/18.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CurrencyAssetsHeaderView.h"
#import "HZProgressView.h"
#import "NSString+JLAdd.h"
#import "SEUserDefaults.h"

@interface CurrencyAssetsHeaderView()

/* bg */
@property (nonatomic, strong) BaseImageView *bgView;
/* groupBtn */
@property (nonatomic, strong) BaseButton *groupBtn;
/* content */
@property (nonatomic, strong) BaseView *contentView;
/* record */
@property (nonatomic, strong) BaseButton *costRecordBtn;
/* totalTag */
@property (nonatomic, strong) BaseLabel *totalTagLabel;
/* total */
@property (nonatomic, strong) BaseLabel *totalLabel;
/* infoView */
@property (nonatomic, strong) BaseView *infoView;
/* price */
@property (nonatomic, strong) BaseLabel *priceLabel;
/* change */
@property (nonatomic, strong) BaseLabel *changeLabel;
/* add */
@property (nonatomic, strong) BaseButton *addBtn;
/* progress */
@property (nonatomic, strong) HZProgressView *progressView;

@end

@implementation CurrencyAssetsHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
}

- (void)themeChange:(NSNotification *)notification{
    self.bgView.image = [ThemeManager imageForKey:@"currency_bg"];
}

- (void)changeAlpha:(CGFloat)alpha{
//    self.groupBtn.alpha = alpha;
    self.contentView.alpha = alpha;
}

- (void)setAllAsset:(Asset *)allAsset{
    _allAsset = allAsset;
    
    self.totalLabel.text = [NSString numberFormatterToAllRMB:allAsset.marketCap];
    if (allAsset.changeAmount < 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"-%@",[NSString numberFormatterToAllRMB:-allAsset.changeAmount]];
    }else{
        self.priceLabel.text = [NSString numberFormatterToAllRMB:allAsset.changeAmount];
    }
    self.changeLabel.text = [NSString stringWithFormat:@"%.2f%%(%@)",allAsset.changeRate,Today];
    self.changeLabel.textColor = [[SEUserDefaults shareInstance] getRiseOrFallColor:allAsset.changeRate >= 0 ? RoseType : FallType];
    
    self.progressView.leftTag = [NSString stringWithFormat:@"%@\n%@",TotalInvestment,[NSString numberFormatterToAllRMB:allAsset.cost]];
    if (allAsset.profit != 0 && allAsset.cost != 0) {
        CGFloat percent = allAsset.profit / allAsset.cost;
       self.progressView.rightTag = [NSString stringWithFormat:@"%@(%@)\n%@",Profit,[NSString numberFormatterToPercent:percent],[NSString numberFormatterToAllRMB:allAsset.profit]];
        self.progressView.progress = 1 - fabs(percent);
    }else{
        self.progressView.rightTag = [NSString stringWithFormat:@"%@(%%0.0)\n%@",Profit,[NSString numberFormatterToAllRMB:allAsset.cost]];
        self.progressView.progress = 1;
    }
    self.progressView.state = allAsset.profit < 0 ? ProgressNegState : ProgressOriState;
}

#pragma mark - action
- (void)groupTouch:(BaseButton *)sender{
    
}

- (void)addTouch{
    if (self.addBlock) {
        self.addBlock();
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.equalTo(@(AdaptY(116) + NavbarH));
    }];
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(-AdaptY(112));
        make.left.mas_equalTo(self.bgView.mas_left).offset(AdaptX(15));
        make.right.mas_equalTo(self.bgView.mas_right).offset(-AdaptX(15));
        make.height.equalTo(@(AdaptY(190)));
    }];
    
//    [self.contentView addSubview:self.costRecordBtn];
//    [self.costRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.contentView);
//        make.right.mas_equalTo(self.contentView.mas_right).offset(-MidPadding);
//        make.height.equalTo(@(AdaptY(25)));
//    }];
    
//    [self.contentView addSubview:self.totalTagLabel];
//    [self.totalTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.contentView.mas_top).offset(AdaptY(26));
//        make.centerX.mas_equalTo(self.contentView.mas_centerX);
//    }];
    
    [self.contentView addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(AdaptY(25));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.left.mas_equalTo(self.contentView.mas_left).offset(MaxPadding);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-MaxPadding);
    }];
    
    [self.contentView addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.totalLabel.mas_bottom).offset(MidPadding);
        make.centerX.mas_equalTo(self.totalLabel.mas_centerX);
        make.height.equalTo(@(AdaptY(25)));
    }];
    
    [self.infoView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoView.mas_left).offset(MinPadding);
        make.centerY.mas_equalTo(self.infoView.mas_centerY);
    }];
    
    [self.infoView addSubview:self.changeLabel];
    [self.changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.infoView.mas_right).offset(-MinPadding);
        make.left.mas_equalTo(self.priceLabel.mas_right).offset(MinPadding);
        make.centerY.mas_equalTo(self.priceLabel.mas_centerY);
    }];
    
    [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(AdaptX(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-AdaptX(15));
        make.top.mas_equalTo(self.infoView.mas_bottom).offset(AdaptY(25));
        make.height.equalTo(@(AdaptY(35)));
    }];
    
    [self.contentView addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(AdaptX(40), AdaptX(40)));
    }];
    
//    [self addSubview:self.groupBtn];
//    [self.groupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.contentView.mas_top).offset(-MidPadding);
//        make.left.mas_equalTo(self.contentView.mas_left);
//    }];
    
}

#pragma mark - init
- (BaseImageView *)bgView{
    if (!_bgView) {
        _bgView = [[BaseImageView alloc] initWithImage:[ThemeManager imageForKey:@"currency_bg"]];
    }
    return _bgView;
}

- (BaseButton *)groupBtn{
    if (!_groupBtn) {
        //ImageName(@"arrow_down_white")
        _groupBtn = [SEFactory buttonWithTitle:DefaultCurrencyGroup image:nil frame:CGRectZero font:Font(15) fontColor:WhiteTextColor];
        [_groupBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
        [_groupBtn addTarget:self action:@selector(groupTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _groupBtn;
}

- (BaseView *)contentView{
    if (!_contentView) {
        _contentView = [[BaseView alloc] init];
        _contentView.backgroundColor = WhiteTextColor;
        ViewShadow(_contentView, CGSizeMake(0, 3), [MainBlackColor colorWithAlphaComponent:0.03], 3, AdaptX(5), AdaptX(5));
    }
    return _contentView;
}

- (BaseButton *)costRecordBtn{
    if (!_costRecordBtn) {
        _costRecordBtn = [SEFactory buttonWithTitle:CostRecord image:nil frame:CGRectZero font:Font(11) fontColor:MainTextColor];
        [_costRecordBtn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateNormal)]];
    }
    return _costRecordBtn;
}

- (BaseLabel *)totalTagLabel{
    if (!_totalTagLabel) {
        _totalTagLabel = [SEFactory labelWithText:@"总资产=2.0009 BTC" frame:CGRectZero textFont:Font(11) textColor:LightTextGrayColor textAlignment:NSTextAlignmentCenter];
    }
    return _totalTagLabel;
}

- (BaseLabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:[UIFont boldSystemFontOfSize:30] textColor:MainTextColor textAlignment:NSTextAlignmentCenter];
        _totalLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _totalLabel;
}

- (BaseView *)infoView{
    if (!_infoView) {
        _infoView = [[BaseView alloc] init];
        _infoView.backgroundColor = [[ThemeManager sharedInstance].themeColor colorWithAlphaComponent:0.05];
        ViewRadius(_infoView, AdaptY(25 / 2));
    }
    return _infoView;
}

- (BaseLabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(11) textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _priceLabel;
}

- (BaseLabel *)changeLabel{
    if (!_changeLabel) {
        _changeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(11) textColor:BackGreenColor textAlignment:NSTextAlignmentRight];
    }
    return _changeLabel;
}

- (BaseButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [SEFactory buttonWithImage:[ThemeManager imageForKey:@"currency_add"]];
        [_addBtn addTarget:self action:@selector(addTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (HZProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[HZProgressView alloc] init];
    }
    return _progressView;
}

@end
