//
//  TitleAndContentCell.m
//  Hunt
//
//  Created by 杨明 on 2018/9/10.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "TitleAndContentCell.h"
#import "NSString+JLAdd.h"

static NSString *cellId = @"titleAndContentCellId";

#define ContentFont 13

@interface TitleAndContentCell()

/* tag */
@property (nonatomic, strong) BaseView *tagView;
/* title */
@property (nonatomic, strong) BaseLabel *titleLabel;
/* content */
@property (nonatomic, strong) BaseLabel *contentLabel;

@end

@implementation TitleAndContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initTitleAndContentCell:(UITableView *)tableView cellId:(NSString *)cellId{
    self = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!self) {
        self = [[TitleAndContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)titleAndContent:(UITableView *)tableView cellId:(NSString *)cellId{
    return [[TitleAndContentCell alloc] initTitleAndContentCell:tableView cellId:cellId];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setContentColor:(UIColor *)contentColor{
    _contentColor = contentColor;
    self.contentLabel.textColor = contentColor;
}

- (void)setHideTitle:(BOOL)hideTitle{
    _hideTitle = hideTitle;
    if (hideTitle) {
        self.tagView.hidden = YES;
        self.titleLabel.hidden = YES;
    }
}

- (void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
}

- (void)setContent:(NSString *)content{
    _content = content;
    
    if (content == nil) {
        self.titleLabel.hidden = YES;
        self.tagView.hidden = YES;
    }else{
        CGFloat height = [content getSpaceLabelHeightWithFont:Font(ContentFont) withWidth:MAINSCREEN_WIDTH - 2 * MaxPadding lineSpace:2];
        self.contentLabel.attributedText = [content getAttributedStrWithLineSpace:2 font:Font(ContentFont)];
        self.contentLabel.frame = CGRectMake(MaxPadding,self.hideTitle ? MaxPadding : AdaptY(38), MAINSCREEN_WIDTH - 2 * MaxPadding, height);
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(MaxPadding);
        make.top.mas_equalTo(self.contentView.mas_top).offset(AdaptY(17));
        make.size.mas_equalTo(CGSizeMake(AdaptX(3), AdaptY(10)));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagView.mas_right).offset(AdaptX(5));
        make.centerY.mas_equalTo(self.tagView.mas_centerY);
    }];
    
    [self.contentView addSubview:self.contentLabel];
}

#pragma mark - init
- (BaseView *)tagView{
    if (!_tagView) {
        _tagView = [[BaseView alloc] init];
        [_tagView py_addToThemeColorPool:@"backgroundColor"];
        ViewRadius(_tagView, AdaptX(2));
    }
    return _tagView;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:[UIFont boldSystemFontOfSize:13] textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (BaseLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(ContentFont) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
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
