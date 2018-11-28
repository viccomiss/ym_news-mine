//
//  CurrencyTradeRecordCell.m
//  Hunt
//
//  Created by 杨明 on 2018/8/22.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CurrencyTradeRecordCell.h"
#import "NSString+JLAdd.h"
#import "SEUserDefaults.h"

static NSString *cellId = @"CurrencyTradeRecordCellId";

@interface CurrencyTradeRecordCell()

/* back */
@property (nonatomic, strong) BaseView *backView;
/* amount */
@property (nonatomic, strong) BaseLabel *amountLabel;
/* edit */
@property (nonatomic, strong) BaseButton *editBtn;
/* buytag */
@property (nonatomic, strong) BaseLabel *buyUnitTagLabel;
/* buy */
@property (nonatomic, strong) BaseLabel *buyUnitLabel;
/* buytag */
@property (nonatomic, strong) BaseLabel *buyTotalTagLabel;
/* buy */
@property (nonatomic, strong) BaseLabel *buyTotalLabel;
/* buytag */
@property (nonatomic, strong) BaseLabel *currentTagLabel;
/* buy */
@property (nonatomic, strong) BaseLabel *currentLabel;
/* buytag */
@property (nonatomic, strong) BaseLabel *storeInTagLabel;
/* buy */
@property (nonatomic, strong) BaseLabel *storeInLabel;
/* buytag */
@property (nonatomic, strong) BaseLabel *noteTagLabel;
/* buy */
@property (nonatomic, strong) BaseLabel *noteLabel;
/* 涨幅 */
@property (nonatomic, strong) BaseLabel *changeLabel;

@end

@implementation CurrencyTradeRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

- (instancetype)initCurrencyTradeRecordCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!self) {
        self = [[CurrencyTradeRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)currencyTradeRecordCell:(UITableView *)tableView{
    return [[CurrencyTradeRecordCell alloc] initCurrencyTradeRecordCell:tableView];
}

- (void)setModel:(Transaction *)model{
    _model = model;
    
    self.amountLabel.text = [NSString stringWithFormat:@"%@ %ld %@",(model.type == TransactionBuyType ? CurrencyBuy : CurrencySale), model.quantity, model.coinId];
    self.noteLabel.text = model.notes.length != 0 ? model.notes : @"-";
    self.buyUnitLabel.text = [NSString numberFormatterToAllRMB:[model.price doubleValue]];
    self.buyTotalLabel.text = [NSString numberFormatterToAllRMB:model.cost];
    self.currentLabel.text = [NSString numberFormatterToAllRMB:model.assetPrice * model.quantity];
    
    CGFloat changeRate = (model.assetPrice * model.quantity - model.cost) / model.cost;
    self.changeLabel.text = [NSString numberFormatterToPercent:changeRate];
    self.changeLabel.textColor = [[SEUserDefaults shareInstance] getRiseOrFallColor:changeRate >= 0 ? RoseType : FallType];

    if (model.exchange) {
        self.storeInLabel.text = [NSString stringWithFormat:@"%@：%@",Exchange,model.exchange.name];
    }else{
        if (model.walletAddr.length != 0) {
            self.storeInLabel.text = [NSString stringWithFormat:@"%@：%@",Wallet,model.walletAddr];
        }else{
            self.storeInLabel.text = @"-";
        }
    }
    self.buyUnitTagLabel.text = model.type == TransactionSaleType ? SaleUnitPrice : BuyUnitPrice;
    self.buyTotalTagLabel.text = model.type == TransactionSaleType ? SaleTotalPurchase : TotalPurchase;
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(MaxPadding);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-MaxPadding);
        make.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.backView addSubview:self.amountLabel];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(MidPadding);
        make.top.mas_equalTo(self.backView);
        make.height.equalTo(@(AdaptY(34)));
    }];
    
    [self.backView addSubview:self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backView.mas_right).offset(-MaxPadding);
        make.centerY.mas_equalTo(self.amountLabel.mas_centerY);
    }];
    
    BaseView *line = [[BaseView alloc] init];
    line.backgroundColor = LineColor;
    [self.backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.amountLabel.mas_left);
        make.right.mas_equalTo(self.backView.mas_right).offset(-MidPadding);
        make.top.mas_equalTo(self.amountLabel.mas_bottom);
        make.height.equalTo(@(0.5));
    }];
    
    [self.backView addSubview:self.buyUnitTagLabel];
    [self.buyUnitTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.amountLabel.mas_left);
        make.top.mas_equalTo(line.mas_bottom).offset(MinPadding);
    }];
    
    [self.backView addSubview:self.buyTotalTagLabel];
    [self.buyTotalTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buyUnitTagLabel.mas_bottom).offset(MidPadding);
        make.left.mas_equalTo(self.amountLabel);
    }];
    
    [self.backView addSubview:self.currentTagLabel];
    [self.currentTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buyTotalTagLabel.mas_bottom).offset(MidPadding);
        make.left.mas_equalTo(self.amountLabel);
    }];
    
    [self.backView addSubview:self.storeInTagLabel];
    [self.storeInTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.currentTagLabel.mas_bottom).offset(MidPadding);
        make.left.mas_equalTo(self.amountLabel);
    }];
    
    [self.backView addSubview:self.noteTagLabel];
    [self.noteTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.storeInTagLabel.mas_bottom).offset(MidPadding);
        make.left.mas_equalTo(self.amountLabel);
    }];
    
    [self.backView addSubview:self.buyUnitLabel];
    [self.buyUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(AdaptX(108));
        make.centerY.mas_equalTo(self.buyUnitTagLabel.mas_centerY);
    }];
    
    [self.backView addSubview:self.buyTotalLabel];
    [self.buyTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(AdaptX(108));
        make.centerY.mas_equalTo(self.buyTotalTagLabel.mas_centerY);
    }];
    
    [self.backView addSubview:self.currentLabel];
    [self.currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(AdaptX(108));
        make.centerY.mas_equalTo(self.currentTagLabel.mas_centerY);
    }];
    
    [self.backView addSubview:self.changeLabel];
    [self.changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.currentLabel.mas_right).offset(MidPadding);
        make.centerY.mas_equalTo(self.currentLabel.mas_centerY);
    }];
    
    [self.backView addSubview:self.storeInLabel];
    [self.storeInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(AdaptX(108));
        make.centerY.mas_equalTo(self.storeInTagLabel.mas_centerY);
    }];
    
    [self.backView addSubview:self.noteLabel];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(AdaptX(108));
        make.centerY.mas_equalTo(self.noteTagLabel.mas_centerY);
    }];
    
}

#pragma mark - init
- (BaseView *)backView{
    if (!_backView) {
        _backView = [[BaseView alloc] init];
//        ViewShadow(_backView, CGSizeMake(3, 3), TextDarkGrayColor, 3, 3, AdaptX(5));
        ViewRadius(_backView, AdaptX(5));
        _backView.backgroundColor = WhiteTextColor;
    }
    return _backView;
}

- (BaseLabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _amountLabel;
}

- (BaseButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [SEFactory buttonWithTitle:Edit image:[ThemeManager imageForKey:@"arrow_right"] frame:CGRectZero font:Font(12) fontColor:MainTextColor];
        [_editBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:MinPadding];
        [_editBtn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateNormal)]];
    }
    return _editBtn;
}

- (BaseLabel *)buyUnitTagLabel{
    if (!_buyUnitTagLabel) {
        _buyUnitTagLabel = [SEFactory labelWithText:BuyUnitPrice frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _buyUnitTagLabel;
}

- (BaseLabel *)buyTotalTagLabel{
    if (!_buyTotalTagLabel) {
        _buyTotalTagLabel = [SEFactory labelWithText:TotalPurchase frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _buyTotalTagLabel;
}

- (BaseLabel *)currentTagLabel{
    if (!_currentTagLabel) {
        _currentTagLabel = [SEFactory labelWithText:CurrentValue frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _currentTagLabel;
}

- (BaseLabel *)storeInTagLabel{
    if (!_storeInTagLabel) {
        _storeInTagLabel = [SEFactory labelWithText:StoreIn frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _storeInTagLabel;
}

- (BaseLabel *)noteTagLabel{
    if (!_noteTagLabel) {
        _noteTagLabel = [SEFactory labelWithText:Remark frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _noteTagLabel;
}

- (BaseLabel *)buyUnitLabel{
    if (!_buyUnitLabel) {
        _buyUnitLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _buyUnitLabel;
}

- (BaseLabel *)buyTotalLabel{
    if (!_buyTotalLabel) {
        _buyTotalLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _buyTotalLabel;
}

- (BaseLabel *)currentLabel{
    if (!_currentLabel) {
        _currentLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _currentLabel;
}

- (BaseLabel *)storeInLabel{
    if (!_storeInLabel) {
        _storeInLabel = [SEFactory labelWithText:@"-" frame:CGRectZero textFont:Font(12) textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _storeInLabel;
}

- (BaseLabel *)noteLabel{
    if (!_noteLabel) {
        _noteLabel = [SEFactory labelWithText:@"-" frame:CGRectZero textFont:Font(12) textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _noteLabel;
}

- (BaseLabel *)changeLabel{
    if (!_changeLabel) {
        _changeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:BackGreenColor textAlignment:NSTextAlignmentLeft];
    }
    return _changeLabel;
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
