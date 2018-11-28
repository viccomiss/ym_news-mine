//
//  TopTagBottomFieldCell.m
//  Hunt
//
//  Created by 杨明 on 2018/8/21.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "TopTagBottomFieldCell.h"
#import "DatePickerView.h"
#import "DateManager.h"
#import "CurrencyHelper.h"

@interface TopTagBottomFieldCell()<UITextFieldDelegate>

/* tag */
@property (nonatomic, strong) BaseLabel *tagLabel;
/* field */
@property (nonatomic, strong) BaseTextField *textField;
/* arrow */
@property (nonatomic, strong) BaseButton *arrowBtn;
/* rightWeight */
@property (nonatomic, strong) BaseButton *weight1Btn;
/* rightWeight */
@property (nonatomic, strong) BaseButton *weight2Btn;

@end

@implementation TopTagBottomFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initTopTagBottomFieldCell:(UITableView *)tableView cellId:(NSString *)cellId{
    self = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!self) {
        self = [[TopTagBottomFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)topTagBottomFieldCell:(UITableView *)tableView cellId:(NSString *)cellId{
    return [[TopTagBottomFieldCell alloc] initTopTagBottomFieldCell:tableView cellId:cellId];
}

#pragma mark - set
- (void)setQuantutyModel:(Transaction *)quantutyModel{
    _quantutyModel = quantutyModel;
    self.textField.text = [NSString stringWithFormat:@"%ld",quantutyModel.quantity];
}

- (void)setPriceModel:(Transaction *)priceModel{
    _priceModel = priceModel;
    self.textField.text = [priceModel.price doubleValue] == 0 ? @"" : [NSString stringWithFormat:@"%@",priceModel.price];
}

- (void)setTotalPriceModel:(Transaction *)totalPriceModel{
    _totalPriceModel = totalPriceModel;
}

- (void)setTimeModel:(Transaction *)timeModel{
    _timeModel = timeModel;
    self.textField.text = [DateManager date_YMDHM_WithTimeIntervalSince1970:timeModel.time];
}

- (void)setExchangeModel:(Transaction *)exchangeModel{
    _exchangeModel = exchangeModel;
    self.textField.text = exchangeModel.exchange.name;
}

- (void)setWalletModel:(Transaction *)walletModel{
    _walletModel = walletModel;
    self.textField.text = walletModel.walletAddr;
}

- (void)setCoinModel:(Transaction *)coinModel{
    _coinModel = coinModel;
    self.textField.text = coinModel.coinId;
}

- (void)setWeight1Tag:(NSString *)weight1Tag{
    _weight1Tag = weight1Tag;
    [self.weight1Btn setTitle:weight1Tag forState:UIControlStateNormal];
    [self.weight1Btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
}

- (void)setWeight2Tag:(NSString *)weight2Tag{
    _weight2Tag = weight2Tag;
    [self.weight2Btn setTitle:weight2Tag forState:UIControlStateNormal];
    [self.weight2Btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType{
    _keyboardType = keyboardType;
    self.textField.keyboardType = keyboardType;
}

- (void)setTagStr:(NSString *)tagStr{
    _tagStr = tagStr;
    self.tagLabel.text = tagStr;
}

- (void)setHideArrow:(BOOL)hideArrow{
    _hideArrow = hideArrow;
    self.arrowBtn.hidden = hideArrow;
}

- (void)setDisField:(BOOL)disField{
    _disField = disField;
    self.textField.userInteractionEnabled = !disField;
}

- (void)setTimeField:(BOOL)timeField{
    _timeField = timeField;
    WeakSelf(self);
    self.textField.inputView = [[DatePickerView alloc] initWithView:self.textField withDatePickerMode:UIDatePickerModeDateAndTime withDateFormat:@"yyyy-MM-dd HH:mm" limitTime:NO withBlock:^(NSString *str) {
        weakself.textField.text = str;
        if (weakself.timeModel) {
            weakself.timeModel.time = [DateManager timeIntervalWithDate:[DateManager dateConvertFrom_YMDHM_String:str]];
        }
    }];
}

- (void)setShowWeight:(BOOL)showWeight{
    _showWeight = showWeight;
    if (showWeight) {
        self.arrowBtn.hidden = YES;
        [self.contentView addSubview:self.weight2Btn];
        [self.weight2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-AdaptX(15));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        [self.contentView addSubview:self.weight1Btn];
        [self.weight1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.weight2Btn.mas_left).offset(-AdaptX(15));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}

#pragma mark - action
- (void)weightTouch:(BaseButton *)sender{
    if (self.weightBlock) {
        self.weightBlock(sender.tag);
    }
}

- (void)textFieldDidChange:(BaseTextField *)sender{
    if (self.quantutyModel) {
        self.quantutyModel.quantity = [sender.text integerValue];
    }
    if (self.priceModel) {
        self.priceModel.price = sender.text;
    }
    if (self.totalPriceModel) {
        self.totalPriceModel.totalPrice = [sender.text floatValue];
    }
    if (self.walletModel) {
        self.walletModel.walletAddr = sender.text;
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.arrowBtn];
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-CELLMINMARGIN);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(25), AdaptX(25)));
    }];
        
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(AdaptX(15));
        make.top.mas_equalTo(self.contentView.mas_top).offset(AdaptY(5));
    }];
    
    [self.contentView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-AdaptY(5));
        make.top.mas_equalTo(self.tagLabel.mas_bottom).offset(AdaptY(5));
        make.left.mas_equalTo(self.contentView.mas_left).offset(MidPadding);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.6);
    }];
    
}

#pragma mark - init
- (BaseLabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(11) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _tagLabel;
}

- (BaseTextField *)textField{
    if (!_textField) {
        _textField = [SEFactory textFieldWithPlaceholder:@"" frame:CGRectZero font:Font(14)];
        _textField.delegate = self;
        _textField.textColor = MainBlackColor;
        _textField.clearButtonMode = UITextFieldViewModeNever;
        _textField.textAlignment = NSTextAlignmentLeft;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (BaseButton *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [SEFactory buttonWithImage:ImageName(@"arrow_right")];
    }
    return _arrowBtn;
}

- (BaseButton *)weight1Btn{
    if (!_weight1Btn) {
        _weight1Btn = [SEFactory buttonWithTitle:[CurrencyHelper currentCurrency] image:[ThemeManager imageForKey:@"arrow_down"] frame:CGRectZero font:Font(12) fontColor:MainTextColor];
        _weight1Btn.tag = 1;
        [_weight1Btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
        [_weight1Btn addTarget:self action:@selector(weightTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weight1Btn;
}

- (BaseButton *)weight2Btn{
    if (!_weight2Btn) {
        _weight2Btn = [SEFactory buttonWithTitle:PerUnit image:[ThemeManager imageForKey:@"arrow_down"] frame:CGRectZero font:Font(12) fontColor:MainTextColor];
        _weight2Btn.tag = 2;
        [_weight2Btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
        [_weight2Btn addTarget:self action:@selector(weightTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weight2Btn;
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
