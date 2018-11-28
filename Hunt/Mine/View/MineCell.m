//
//  MineCell.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/9.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "MineCell.h"

static NSString *CellId = @"MineCellId";

@interface MineCell()

/* name */
@property (nonatomic, strong) BaseLabel *nameLabel;
/* arrow */
@property (nonatomic, strong) BaseButton *arrowBtn;
/* tag */
@property (nonatomic, strong) BaseLabel *tagLabel;
/* summary */
@property (nonatomic, strong) BaseLabel *summaryLabel;
/* switch */
@property (nonatomic, strong) UISwitch *modeSwitch;
/* lineView */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation MineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = WhiteTextColor;
        [self createUI];
    }
    return self;
}

- (instancetype)initMineCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    if (!self) {
        self = [[MineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    return self;
}

+ (instancetype)mineCell:(UITableView *)tableView{
    return [[MineCell alloc] initMineCell:tableView];
}

- (void)setModel:(MineModel *)model{
    _model = model;
    
    self.nameLabel.text = LocalizedString(model.name);
    if (model.summaryColor) {
        self.summaryLabel.textColor = model.summaryColor;
    }else{
        self.summaryLabel.textColor = LightTextGrayColor;
    }
    
    
    switch (model.type) {
        case MineNormalCellType:
        {
            self.arrowBtn.hidden = NO;
            self.modeSwitch.hidden = YES;
            self.summaryLabel.hidden = YES;
        }
            break;
        case MineSummaryCellType:
        {
            self.summaryLabel.hidden = NO;
            self.modeSwitch.hidden = YES;
            self.arrowBtn.hidden = NO;
            if (model.attSummary) {
                self.summaryLabel.attributedText = model.attSummary;
            }
            if (model.summary.length != 0) {
                self.summaryLabel.text = model.summary;
            }
        }
            break;
        case MineMessageTagCellType:
        {
            self.summaryLabel.hidden = YES;
            self.modeSwitch.hidden = YES;
            self.arrowBtn.hidden = NO;
            if (model.notReadCount == 0) {
                self.tagLabel.hidden = YES;
            }else{
                self.tagLabel.hidden = NO;
                self.tagLabel.text = [NSString stringWithFormat:@"%ld",model.notReadCount];
            }
        }
            break;
        case MineSwitchCellType:
        {
            self.arrowBtn.hidden = YES;
            self.modeSwitch.hidden = NO;
            self.summaryLabel.hidden = YES;
            [self.modeSwitch setOn:model.klineType == RoseType ? YES : NO animated:YES];
        }
            break;
    }
}

- (void)setShowTag:(BOOL)showTag{
    _showTag = showTag;
    
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowBtn.mas_left);
        make.centerY.mas_equalTo(self.arrowBtn.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(@(AdaptX(8)));
        make.height.equalTo(@(AdaptX(8)));
    }];
    
    [self.summaryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.tagLabel.mas_left).offset(-AdaptX(5));
        make.centerY.mas_equalTo(self.arrowBtn.mas_centerY);
    }];
}

#pragma mark - action
- (void)switchAction:(UISwitch *)sender{
    if (self.switchBlock) {
        self.switchBlock(sender.on);
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(AdaptX(15));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.contentView addSubview:self.arrowBtn];
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(- MidPadding);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(25), AdaptX(25)));
    }];
    
    [self.contentView addSubview:self.summaryLabel];
    [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowBtn.mas_left);
        make.centerY.mas_equalTo(self.arrowBtn.mas_centerY);
    }];
    
    [self.contentView addSubview:self.modeSwitch];
    [self.modeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-2 * MidPadding);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

#pragma mark - init

- (UISwitch *)modeSwitch{
    if (!_modeSwitch) {
        _modeSwitch = [[UISwitch alloc]init];
        [_modeSwitch setTintColor:LineColor];
        [_modeSwitch py_addToThemeColorPool:@"onTintColor"];
        _modeSwitch.layer.cornerRadius = 15.5f;
        _modeSwitch.layer.masksToBounds = YES;
        [_modeSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _modeSwitch;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(16) textColor:MainBlackColor textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (BaseButton *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [SEFactory buttonWithImage:ImageName(@"arrow_right")];
        _arrowBtn.userInteractionEnabled = NO;
    }
    return _arrowBtn;
}

- (BaseLabel *)summaryLabel{
    if (!_summaryLabel) {
        _summaryLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(14) textColor:LightTextGrayColor textAlignment:NSTextAlignmentRight];
    }
    return _summaryLabel;
}

- (BaseLabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:WhiteTextColor textAlignment:NSTextAlignmentCenter];
        _tagLabel.backgroundColor = BackRedColor;
        ViewRadius(_tagLabel, AdaptX(4));
    }
    return _tagLabel;
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
