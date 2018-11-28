//
//  FlashShareViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/11/19.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "FlashShareViewController.h"
#import "ShareMenuView.h"
#import "NSString+JLAdd.h"
#import "DateManager.h"
#import "SEUserDefaults.h"
#import "UIImage+JLAdd.h"

#define ShareHeight AdaptY(120) + TabbarNSH

@interface FlashShareViewController()

/* bg */
@property (nonatomic, strong) BaseImageView *bgView;
/* logo */
@property (nonatomic, strong) BaseImageView *logoView;
/* name */
@property (nonatomic, strong) BaseLabel *nameLabel;
/* slogan */
@property (nonatomic, strong) BaseLabel *sloganLabel;
/* container */
@property (nonatomic, strong) BaseView *containerView;
/* time */
@property (nonatomic, strong) BaseLabel *timeLabel;
/* title */
@property (nonatomic, strong) BaseLabel *titleLabel;
/* content */
@property (nonatomic, strong) BaseLabel *contentLabel;
/* scroll */
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ShareMenuView *shareView;
/* code */
@property (nonatomic, strong) BaseImageView *codeImgView;
/* codeTag */
@property (nonatomic, strong) BaseLabel *codeTagLabel;
/* codeDetail */
@property (nonatomic, strong) BaseLabel *codeDetailLabel;

@end

@implementation FlashShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self setData];
}

- (void)setData{
    
    self.titleLabel.attributedText = [self.model.title getAttributedStrWithLineSpace:3 font:Font(16)];
    self.contentLabel.attributedText = [self.model.text getAttributedStrWithLineSpace:3 font:Font(13)];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[DateManager date_YMD_WithTimeIntervalSince1970:self.model.publishDate], [DateManager weekdayStringFromDate:[DateManager dateWithTimeStamp:self.model.publishDate]],[[DateManager date_HMS_WithTimeIntervalSince1970:self.model.publishDate] substringToIndex:5]];
}

#pragma mark - UI
- (void)createUI{
    
    CGFloat titleHeight = [self.model.title getSpaceLabelHeightWithFont:Font(16) withWidth:MAINSCREEN_WIDTH - AdaptX(70) lineSpace:3] + 20;
    CGFloat contentHeight = [self.model.text getSpaceLabelHeightWithFont:Font(13) withWidth:MAINSCREEN_WIDTH - AdaptX(70) lineSpace:3] + 15;
    CGFloat containerHeight = titleHeight + contentHeight + AdaptY(40) + AdaptY(30);
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-ShareHeight);
    }];
    
    [self.scrollView addSubview:self.bgView];
    
    [self.scrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_top).offset(AdaptY(180));
        make.left.mas_equalTo(self.view.mas_left).offset(AdaptX(20));
        make.right.mas_equalTo(self.view.mas_right).offset(-AdaptX(20));
        make.height.equalTo(@(containerHeight));
    }];
    
    [self.containerView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView.mas_top);
        make.left.mas_equalTo(self.containerView).offset(MaxPadding);
        make.height.equalTo(@(AdaptY(40)));
    }];
    
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom);
        make.left.mas_equalTo(self.timeLabel.mas_left);
        make.width.equalTo(@(MAINSCREEN_WIDTH - AdaptX(70)));
        make.height.equalTo(@(titleHeight));
    }];
    
    [self.containerView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(MidPadding);
        make.left.right.mas_equalTo(self.titleLabel);
        make.height.equalTo(@(contentHeight));
    }];
    
    [self.scrollView addSubview:self.codeImgView];
    [self.codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left).offset(AdaptX(42));
        make.top.mas_equalTo(self.containerView.mas_bottom).offset(AdaptY(50));
        make.size.mas_equalTo(CGSizeMake(AdaptX(80), AdaptX(80)));
    }];
    
    [self.scrollView addSubview:self.codeTagLabel];
    [self.codeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.codeImgView.mas_right).offset(AdaptX(20));
        make.top.mas_equalTo(self.codeImgView.mas_top).offset(AdaptY(18));
    }];
    
    [self.scrollView addSubview:self.codeDetailLabel];
    [self.codeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.codeTagLabel);
        make.top.mas_equalTo(self.codeTagLabel.mas_bottom).offset(MidPadding);
        make.right.mas_equalTo(self.containerView.mas_right);
    }];
    
    [self.scrollView addSubview:self.logoView];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.scrollView).offset(AdaptX(20));
        make.size.mas_equalTo(CGSizeMake(AdaptX(36), AdaptX(36)));
    }];
    
    [self.scrollView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoView.mas_top);
        make.left.mas_equalTo(self.logoView.mas_right).offset(AdaptX(9));
    }];

    [self.scrollView addSubview:self.sloganLabel];
    [self.sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.logoView.mas_bottom);
        make.left.mas_equalTo(self.nameLabel.mas_left);
    }];

    CGFloat totalHeight = AdaptY(180) * 2 + containerHeight < MAINSCREEN_HEIGHT ? MAINSCREEN_HEIGHT : AdaptY(180) * 2 + containerHeight;
    self.bgView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, totalHeight);
    self.scrollView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, totalHeight);
    
    [self.view addSubview:self.shareView];
    WeakSelf(self);
    self.shareView.backBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    self.shareView.shareBlock = ^(SSDKPlatformType type) {
        UIImage *current = [UIImage captureScreenScrollView:weakself.scrollView];
        [weakself.shareView shareWithImage:current type:type];
    };
}

#pragma mark - init
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - ShareHeight)];
        _scrollView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _scrollView;
}

- (BaseImageView *)bgView{
    if (!_bgView) {
        UIImage *image = [UIImage imageNamed:@"flash_share_bg"];
        
        // 设置左边端盖宽度
        NSInteger leftCapWidth = image.size.width * 0.5;
        // 设置上边端盖高度
        NSInteger topCapHeight = image.size.height * 0.5;
        
        UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
      
        _bgView = [[BaseImageView alloc] initWithImage:newImage];
    }
    return _bgView;
}

- (BaseImageView *)logoView{
    if (!_logoView) {
        _logoView = [[BaseImageView alloc] initWithImage:ImageName(@"logo")];
        ViewRadius(_logoView, AdaptX(6));
    }
    return _logoView;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:Rainbow frame:CGRectZero textFont:[UIFont boldSystemFontOfSize:16] textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (BaseLabel *)sloganLabel{
    if (!_sloganLabel) {
        _sloganLabel = [SEFactory labelWithText:DigitalFutureControl frame:CGRectZero textFont:Font(10) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _sloganLabel;
}

- (BaseView *)containerView{
    if (!_containerView) {
        _containerView = [[BaseView alloc] init];
        _containerView.backgroundColor = WhiteTextColor;
        ViewRadius(_containerView, AdaptX(10));
    }
    return _containerView;
}

- (BaseLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentLeft];
    }
    return _timeLabel;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(16) textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (BaseLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(13) textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (ShareMenuView *)shareView{
    if (!_shareView) {
        _shareView = [[ShareMenuView alloc] initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT-ShareHeight, MAINSCREEN_WIDTH, ShareHeight) shareType:ShareFlashType];
    }
    return _shareView;
}

- (BaseImageView *)codeImgView{
    if (!_codeImgView) {
        _codeImgView = [[BaseImageView alloc] initWithImage:[[SEUserDefaults shareInstance] getShareCode:CGSizeMake(AdaptX(80), AdaptX(80))]];
    }
    return _codeImgView;
}

- (BaseLabel *)codeTagLabel{
    if (!_codeTagLabel) {
        _codeTagLabel = [SEFactory labelWithText:FlashShareSlogan frame:CGRectZero textFont:[UIFont boldSystemFontOfSize:16] textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _codeTagLabel;
}

- (BaseLabel *)codeDetailLabel{
    if (!_codeDetailLabel) {
        _codeDetailLabel = [SEFactory labelWithText:FlashShareDownloadSlogan frame:CGRectZero textFont:Font(12) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
        _codeDetailLabel.numberOfLines = 2;
    }
    return _codeDetailLabel;
}

@end
