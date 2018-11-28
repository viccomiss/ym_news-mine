//
//  FlashCell.m
//  Hunt
//
//  Created by 杨明 on 2018/11/19.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "FlashCell.h"
#import "NSString+JLAdd.h"
#import "DateManager.h"

static NSString *CellId = @"FlashCellId";

@interface FlashCell()

/* tag */
@property (nonatomic, strong) BaseLabel *tagLabel;
/* time */
@property (nonatomic, strong) BaseLabel *timeLabel;
/* leftLine */
@property (nonatomic, strong) BaseView *line;
/* title */
@property (nonatomic, strong) BaseLabel *titleLabel;
/* container */
@property (nonatomic, strong) BaseLabel *containerLabel;
/* from */
@property (nonatomic, strong) BaseLabel *fromLabel;
/* share */
@property (nonatomic, strong) BaseButton *shareBtn;

@end

@implementation FlashCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.separatorLine = NO;
        [self createUI];
    }
    return self;
}

- (instancetype)initFlashCell:(UITableView *)tableView{
    self = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!self) {
        self = [[FlashCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)flashCell:(UITableView *)tableView{
    return [[FlashCell alloc] initFlashCell:tableView];
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    self.containerLabel.tag = indexPath.section * 100 + indexPath.row;
}

- (void)setModel:(flash *)model{
    _model = model;
    self.titleLabel.attributedText = [model.title getAttributedStrWithLineSpace:3 font:[UIFont boldSystemFontOfSize:15]];
    self.containerLabel.attributedText = [model.text getAttributedStrWithLineSpace:3 font:Font(14)];
    self.containerLabel.numberOfLines = model.selected ? 0 : 4;
    self.timeLabel.text = [[DateManager date_HMS_WithTimeIntervalSince1970:model.publishDate] substringToIndex:5];
}

#pragma mark - action
- (void)contentTap{
    if (self.contentBlock) {
        self.contentBlock(self.containerLabel.tag);
    }
}

- (void)shareTouch{
    if (self.shareBlock) {
        self.shareBlock();
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(AdaptX(20));
        make.top.bottom.mas_equalTo(self.contentView);
        make.width.equalTo(@(1));
    }];
    
    [self.contentView addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(AdaptY(20));
        make.centerX.mas_equalTo(self.line.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AdaptX(8), AdaptX(8)));
    }];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.tagLabel.mas_centerY);
        make.left.mas_equalTo(self.tagLabel.mas_right).offset(MidPadding);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(MidPadding);
        make.left.mas_equalTo(self.timeLabel);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-MaxPadding);
    }];
    
    [self.contentView addSubview:self.containerLabel];
    [self.containerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(MidPadding);
        make.left.right.mas_equalTo(self.titleLabel);
    }];
    
    [self.contentView addSubview:self.fromLabel];
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerLabel.mas_bottom).offset(MidPadding);
        make.left.mas_equalTo(self.timeLabel.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-MidPadding);
    }];
    
    [self.contentView addSubview:self.shareBtn];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-MidPadding * 2);
        make.bottom.mas_equalTo(self.fromLabel.mas_bottom);
        make.top.mas_equalTo(self.fromLabel.mas_top);
    }];
}

#pragma mark - init
- (BaseLabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [SEFactory labelWithText:@""];
        _tagLabel.backgroundColor = BackGroundColor;
        ViewRadius(_tagLabel, AdaptX(4));
    }
    return _tagLabel;
}

- (BaseView *)line{
    if (!_line) {
        _line = [[BaseView alloc] init];
        _line.backgroundColor = BackGroundColor;
    }
    return _line;
}

- (BaseLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [SEFactory labelWithText:@"16:36" frame:CGRectZero textFont:Font(12) textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
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

- (BaseLabel *)containerLabel{
    if (!_containerLabel) {
        _containerLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(13) textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
        _containerLabel.numberOfLines = 4;
        _containerLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTap)];
        tap.numberOfTapsRequired = 1;
        [_containerLabel addGestureRecognizer:tap];
    }
    return _containerLabel;
}

- (BaseLabel *)fromLabel{
    if (!_fromLabel) {
        _fromLabel = [SEFactory labelWithText:[NSString stringWithFormat:@"%@:%@",SourceKey,BeeNews] frame:CGRectZero textFont:Font(12) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _fromLabel;
}

- (BaseButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [SEFactory buttonWithTitle:Share image:[ThemeManager imageForKey:@"flash_share"] frame:CGRectZero font:Font(12) fontColor:[ThemeManager sharedInstance].themeColor];
        [_shareBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:4];
        [_shareBtn addTarget:self action:@selector(shareTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
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
