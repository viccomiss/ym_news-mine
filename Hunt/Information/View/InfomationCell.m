//
//  InfomationCell.m
//  Hunt
//
//  Created by 杨明 on 2018/11/19.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "InfomationCell.h"
#import "DateManager.h"

static NSString *CellId = @"InfomationCellId";

@interface InfomationCell()

/* time */
@property (nonatomic, strong) BaseLabel *timeLabel;
/* title */
@property (nonatomic, strong) BaseLabel *titleLabel;
/* from */
@property (nonatomic, strong) BaseLabel *seeLabel;
/* cover */
@property (nonatomic, strong) BaseImageView *coverView;

@end

@implementation InfomationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initInfomationCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!self) {
        self = [[InfomationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)infomationCell:(UITableView *)tableView{
    return [[InfomationCell alloc] initInfomationCell:tableView];
}

- (void)setModel:(New *)model{
    _model = model;
    
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:model.coverImgIds.count ? model.coverImgIds.firstObject : nil] placeholderImage:ImageName(@"")];
    self.titleLabel.text = model.title;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[DateManager timeInterval:model.publishDate days:1 isMDHS:YES],model.originName];
    self.seeLabel.text = [NSString stringWithFormat:@"%ld%@",model.pv,Browse];
    self.titleLabel.textColor = model.selected ? LightTextGrayColor : MainTextColor;
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-MaxPadding);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(112), AdaptY(80)));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(MaxPadding);
        make.left.mas_equalTo(self.contentView.mas_left).offset(MaxPadding);
        make.right.mas_equalTo(self.coverView.mas_left).offset(-MaxPadding);
    }];
    
    [self.contentView addSubview:self.seeLabel];
    [self.seeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.coverView.mas_bottom);
        make.right.mas_equalTo(self.titleLabel.mas_right);
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.coverView.mas_bottom);
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(self.seeLabel.mas_left).offset(-MinPadding);
    }];
}

#pragma mark - init
- (BaseLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:[UIFont boldSystemFontOfSize:15] textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (BaseLabel *)seeLabel{
    if (!_seeLabel) {
        _seeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentRight];
    }
    return _seeLabel;
}

- (BaseImageView *)coverView{
    if (!_coverView) {
        _coverView = [[BaseImageView alloc] init];
        _coverView.backgroundColor = BackGroundColor;
        ViewRadius(_coverView, AdaptX(4));
    }
    return _coverView;
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
