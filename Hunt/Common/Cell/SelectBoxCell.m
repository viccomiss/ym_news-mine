//
//  SelectBoxCell.m
//  Hunt
//
//  Created by 杨明 on 2018/8/6.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "SelectBoxCell.h"

static NSString *cellId = @"selectBoxCellId";

@interface SelectBoxCell()

/* box */
@property (nonatomic, strong) BaseButton *boxBtn;
/* label */
@property (nonatomic, strong) BaseLabel *nameLabel;

@end

@implementation SelectBoxCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initSelectBoxCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!self) {
        self = [[SelectBoxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)selectBoxCell:(UITableView *)tableView{
    return [[SelectBoxCell alloc] initSelectBoxCell:tableView];
}

- (void)setModel:(SelectBoxModel *)model{
    _model = model;
    
    self.nameLabel.text = model.name;
    self.boxBtn.selected = model.selected;
    [self.boxBtn setImage:[ThemeManager imageForKey:@"selectbox_on"] forState:UIControlStateSelected];
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.boxBtn];
    [self.boxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(AdaptX(15));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(25), AdaptX(25)));
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.boxBtn.mas_right).offset(MidPadding);
        make.centerY.mas_equalTo(self.boxBtn.mas_centerY);
    }];
}

#pragma mark - init
- (BaseButton *)boxBtn{
    if (!_boxBtn) {
        _boxBtn = [SEFactory buttonWithImage:ImageName(@"selectbox_normal")];
    }
    return _boxBtn;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(15) textColor:MainBlackColor textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
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
