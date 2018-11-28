//
//  TitleAndMultiLinesContentCell.m
//  Hunt
//
//  Created by 杨明 on 2018/9/12.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "TitleAndMultiLinesContentCell.h"
#import "NSString+JLAdd.h"
#import "JDFTooltips.h"
#import "CommonUtils.h"

static NSString *cellId = @"TitleAndMultiLinesContentCellId";

@interface TitleAndMultiLinesContentCell()

/* title */
@property (nonatomic, strong) BaseLabel *titleLabel;
/* content */
@property (nonatomic, strong) BaseLabel *contentLabel;
/* faq */
@property (nonatomic, strong) BaseButton *faqBtn;
/* faqStr */
@property (nonatomic, copy) NSString *faqStr;

@property (nonatomic, strong) JDFSequentialTooltipManager *tooltipManager;

@end

@implementation TitleAndMultiLinesContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initTitleAndMultiLinesContentCell:(UITableView *)tableView cellId:(NSString *)cellId{
    self = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!self) {
        self = [[TitleAndMultiLinesContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)titleAndMultiLinesContentCell:(UITableView *)tableView cellId:(NSString *)cellId{
    return [[TitleAndMultiLinesContentCell alloc] initTitleAndMultiLinesContentCell:tableView cellId:cellId];
}

#pragma mark - action
- (void)contentTouch{
    if (self.touchBlock) {
        self.touchBlock();
    }
}

- (void)faqTouch{
    
    self.tooltipManager = [[JDFSequentialTooltipManager alloc] initWithHostView:[CommonUtils currentViewController].view];
    [self.tooltipManager addTooltipWithTargetView:self.faqBtn hostView:[CommonUtils currentViewController].view tooltipText:self.faqStr arrowDirection:JDFTooltipViewArrowDirectionLeft width:AdaptX(220)];
    self.tooltipManager.showsBackdropView = YES;
    [self.tooltipManager showNextTooltip];
}

- (void)showFaqWithStr:(NSString *)str{
    self.faqBtn.hidden = NO;
    self.faqStr = str;
}

#pragma mark - set
- (void)setTitle:(NSString *)title{
    _title = title;
    
    self.titleLabel.text = title;
    CGFloat width = [title widthOfFontSize:13];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(MaxPadding);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@(width));
    }];
}

- (void)setContent:(NSString *)content{
    _content = content;
    
    CGFloat height = [content getSpaceLabelHeightWithFont:Font(13) withWidth:MAINSCREEN_WIDTH - MaxPadding * 3 - AdaptX(90) lineSpace:2];
    _contentLabel.attributedText = [content getAttributedStrWithLineSpace:2 font:Font(13) alignment:NSTextAlignmentRight];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.faqBtn.mas_right).offset(MaxPadding);
        make.centerY.mas_equalTo(self.contentView);
        make.height.equalTo(@(height + 2 * MaxPadding));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-MaxPadding);
    }];
}

- (void)setHighlightedTouch:(BOOL)highlightedTouch{
    _highlightedTouch = highlightedTouch;
    self.contentLabel.textColor = [ThemeManager sharedInstance].themeColor;
    self.contentLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTouch)];
    tap.numberOfTapsRequired = 1;
    [self.contentLabel addGestureRecognizer:tap];
}

#pragma mark - UI
- (void)createUI{
    
    [self.contentView addSubview:self.titleLabel];
   
    
    [self.contentView addSubview:self.faqBtn];
    [self.faqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(AdaptX(5));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(35), AdaptX(35)));
    }];
    
    
    [self.contentView addSubview:self.contentLabel];
}

#pragma mark - init
- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(13) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (BaseLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(13) textColor:MainTextColor textAlignment:NSTextAlignmentRight];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (BaseButton *)faqBtn{
    if (!_faqBtn) {
        _faqBtn = [SEFactory buttonWithTitle:@"   " image:ImageName(@"faq_tag") frame:CGRectZero];
        _faqBtn.hidden = YES;
        [_faqBtn addTarget:self action:@selector(faqTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faqBtn;
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
