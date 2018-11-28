//
//  MessageCell.m
//  Hunt
//
//  Created by 杨明 on 2018/8/10.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "MessageCell.h"
#import "NSString+JLAdd.h"

static NSString *cellId = @"messageCellId";

@interface MessageCell()

/* tag */
@property (nonatomic, strong) BaseButton *tagBtn;
/* name */
@property (nonatomic, strong) BaseLabel *nameLabel;
/* date */
@property (nonatomic, strong) BaseButton *dateBtn;
/* content */
@property (nonatomic, strong) BaseLabel *contentLabel;

@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initMessageCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!self) {
        self = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)messageCell:(UITableView *)tableView{
    return [[MessageCell alloc] initMessageCell:tableView];
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.tagBtn];
    [self.tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(MaxPadding);
        make.top.mas_equalTo(self.contentView.mas_top).offset(MaxPadding);
        make.size.mas_equalTo(CGSizeMake(AdaptX(28), AdaptX(16)));
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagBtn.mas_right).offset(MidPadding);
        make.centerY.mas_equalTo(self.tagBtn.mas_centerY);
    }];
    
    [self.contentView addSubview:self.dateBtn];
    [self.dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-MaxPadding);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
    }];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(- MaxPadding);
        make.left.mas_equalTo(self.contentView.mas_left).offset(MaxPadding);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(MaxPadding);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-MaxPadding);
    }];
    
    self.contentLabel.attributedText = [@"虹掌7月30日8:00行情播报，根据OKEx数据显示，BTC添加81 92.4102 美元，24H涨幅 0.18%；ETH现价 464.6652 美元， 24H跌幅0.17%；EOS现价8.3444美元，24H涨幅0.16%。" getAttributedStrWithLineSpace:3 font:Font(12)];
}

#pragma mark - init
- (BaseButton *)tagBtn{
    if (!_tagBtn) {
        _tagBtn = [SEFactory buttonWithTitle:System frame:CGRectMake(0, 0, AdaptX(28), AdaptY(16)) font:Font(9) fontColor:WhiteTextColor];
        ViewRadius(_tagBtn, AdaptX(2));
        [_tagBtn.layer insertSublayer:[UIColor setGradualChangingColor:_tagBtn fromColor:[ThemeManager sharedInstance].gradientColor toColor:[ThemeManager sharedInstance].themeColor] below:_tagBtn.titleLabel.layer];
    }
    return _tagBtn;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:LocalizedString(@"BTC五分钟内涨幅") frame:CGRectZero textFont:Font(13) textColor:MainBlackColor textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (BaseLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (BaseButton *)dateBtn{
    if (!_dateBtn) {
        _dateBtn = [SEFactory buttonWithTitle:@"07-29 15:01" image:ImageName(@"arrow_right") frame:CGRectZero font:Font(12) fontColor:LightTextGrayColor];
        [_dateBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    }
    return _dateBtn;
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
