//
//  CurrencyAssetsCell.m
//  Hunt
//
//  Created by 杨明 on 2018/8/18.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CurrencyAssetsCell.h"
#import "HZProgressView.h"
#import "NSString+JLAdd.h"
#import "SEUserDefaults.h"
#import "PNChart.h"

static NSString *cellId = @"CurrencyAssetsCellId";

@interface CurrencyAssetsCell()

/* back */
@property (nonatomic, strong) BaseView *backView;
/* icon */
@property (nonatomic, strong) BaseImageView *iconView;
/* name */
@property (nonatomic, strong) BaseLabel *nameLabel;
/* price */
@property (nonatomic, strong) BaseLabel *priceLabel;
/* percent */
@property (nonatomic, strong) BaseLabel *percentLabel;
/* totalPrice */
@property (nonatomic, strong) BaseLabel *totalLabel;
/* change */
@property (nonatomic, strong) BaseLabel *changeLabel;
/* progress */
@property (nonatomic, strong) HZProgressView *progressView;
/* pie */
@property (nonatomic, strong) PNPieChart *pieChart;

@end

@implementation CurrencyAssetsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

- (instancetype)initCurrencyAssetsCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!self) {
        self = [[CurrencyAssetsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)currencyAssetsCell:(UITableView *)tableView{
    return [[CurrencyAssetsCell alloc] initCurrencyAssetsCell:tableView];
}

- (void)setModel:(Asset *)model{
    _model = model;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.coin.logo] placeholderImage:ImageName(@"coin_default")];
    self.nameLabel.text = [NSString stringWithFormat:@"%ld %@",model.quantity,model.coin.symbol];
    self.priceLabel.text = [NSString stringWithFormat:@"x %@",[NSString numberFormatterToAllRMB:model.price]];
    self.totalLabel.text = [NSString stringWithFormat:@"≈%@",[NSString numberFormatterToAllRMB:model.price * model.quantity]];
    self.changeLabel.text = [NSString stringWithFormat:@"%.2f%%(%@)",model.changeRate,Today];
    self.changeLabel.textColor = [[SEUserDefaults shareInstance] getRiseOrFallColor:model.changeRate >= 0 ? RoseType : FallType];
    self.percentLabel.text = [NSString stringWithFormat:@"%.2f%%",model.marketCapProportion];
    
    CGFloat left = model.marketCapProportion < 0 ? 0 : model.marketCapProportion;
    CGFloat right = (1 - model.marketCapProportion / 100) < 0 ? 1 : 1 - model.marketCapProportion / 100;
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:left color:[ThemeManager sharedInstance].themeColor],[PNPieChartDataItem dataItemWithValue:right color:BackGroundColor]];
    [self.pieChart updateChartData:items];
    [self.pieChart strokeChart];
    
    self.progressView.leftTag = [NSString numberFormatterToAllRMB:model.cost];

    if (model.profit != 0 && model.cost != 0) {
        CGFloat percent = model.profit / model.cost;
        self.progressView.rightTag = [NSString numberFormatterToAllRMB:model.profit];
        self.progressView.progress = 1 - fabs(percent);
    }else{
        self.progressView.rightTag = [NSString numberFormatterToAllRMB:model.cost];
        self.progressView.progress = 1;
    }
    self.progressView.state = model.profit < 0 ? ProgressNegState : ProgressOriState;
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(AdaptX(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-AdaptX(15));
        make.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.backView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.backView).offset(AdaptX(15));
        make.size.mas_equalTo(CGSizeMake(AdaptX(20), AdaptX(20)));
    }];
    
    [self.backView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
        make.left.mas_equalTo(self.iconView.mas_right).offset(MidPadding);
    }];
    
    [self.backView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(MidPadding);
    }];
    
    [self.backView addSubview:self.pieChart];
    [self.pieChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
        make.right.mas_equalTo(self.backView.mas_right).offset(-MaxPadding);
        make.size.mas_equalTo(CGSizeMake(AdaptX(12), AdaptX(12)));
    }];
    
    [self.backView addSubview:self.percentLabel];
    [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
        make.right.mas_equalTo(self.pieChart.mas_left).offset(-AdaptX(5));
    }];
    
    [self.backView addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(AdaptY(10));
        make.left.mas_equalTo(self.iconView.mas_left);
    }];
    
    [self.backView addSubview:self.changeLabel];
    [self.changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.totalLabel.mas_centerY);
        make.right.mas_equalTo(self.backView.mas_right).offset(-AdaptX(15));
    }];
    
    [self.backView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-AdaptY(15));
        make.left.mas_equalTo(self.iconView.mas_left);
        make.right.mas_equalTo(self.changeLabel.mas_right);
        make.height.equalTo(@(AdaptY(25)));
    }];
}

#pragma mark - init
- (BaseView *)backView{
    if (!_backView) {
        _backView = [[BaseView alloc] init];
        ViewShadow(_backView, CGSizeMake(2, 3), [MainBlackColor colorWithAlphaComponent:0.03], 3, 3, AdaptX(5));
        _backView.backgroundColor = WhiteTextColor;
    }
    return _backView;
}

- (PNPieChart *)pieChart{
    if (!_pieChart) {
        PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:0 color:BackGroundColor] ;
        _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - AdaptX(30) - AdaptX(27), AdaptY(15), AdaptX(12), AdaptX(12)) items:@[item]];
        _pieChart.hideValues = YES;
        _pieChart.innerCircleRadius = 0;
    }
    return _pieChart;
}

- (BaseImageView *)iconView{
    if (!_iconView) {
        _iconView = [[BaseImageView alloc] init];
    }
    return _iconView;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (BaseLabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _priceLabel;
}

- (BaseLabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _totalLabel;
}

- (BaseLabel *)changeLabel{
    if (!_changeLabel) {
        _changeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _changeLabel;
}


- (BaseLabel *)percentLabel{
    if (!_percentLabel) {
        _percentLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentRight];
    }
    return _percentLabel;
}

- (HZProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[HZProgressView alloc] init];
    }
    return _progressView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
