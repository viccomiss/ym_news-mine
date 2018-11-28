//
//  ShareScreenView.m
//  Hunt
//
//  Created by 杨明 on 2018/8/30.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "ShareScreenView.h"
#import "ShareMenuView.h"
#import "UIImage+JLAdd.h"
#import "SEUserDefaults.h"
#import "CommonUtils.h"
#import "DateManager.h"

#define ShareHeight (AdaptY(120) + TabbarNSH)

@interface ShareScreenView()

/* share */
@property (nonatomic, strong) ShareMenuView *shareView;
/* img */
@property (nonatomic, strong) BaseImageView *imgView;
/* content */
@property (nonatomic, strong) BaseView *contentView;
/* bottomView */
@property (nonatomic, strong) BaseView *bottomView;
/* logo */
@property (nonatomic, strong) BaseImageView *logoView;
/* name */
@property (nonatomic, strong) BaseLabel *nameLabel;
/* summary */
@property (nonatomic, strong) BaseLabel *summaryLabel;
/* code */
@property (nonatomic, strong) BaseImageView *codeView;
/* timeLabel */
@property (nonatomic, strong) BaseLabel *timeLabel;

@end

@implementation ShareScreenView

+ (instancetype)shared{
    static ShareScreenView *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ShareScreenView alloc] init];
    });
    return helper;
}


- (instancetype)init{
    if (self == [super init]) {
        
        
    }
    return self;
}

- (void)shareScreenShow{
    
    self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    self.alpha = 0;
    self.backgroundColor = [MainTextColor colorWithAlphaComponent:0.5];
    [[CommonUtils currentViewController].view addSubview:self];
    
    [self createUI];
}

- (void)createUI{
    
    //计算图片宽度
    CGFloat imgWidth = MAINSCREEN_WIDTH / MAINSCREEN_HEIGHT * (MAINSCREEN_HEIGHT - ShareHeight - StatusBarH - AdaptY(90));
    
    CGFloat bottomHeight = imgWidth * AdaptY(90) / MAINSCREEN_WIDTH;
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(imgWidth));
        make.top.mas_equalTo(self.mas_top).offset(StatusBarH);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-ShareHeight);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-AdaptY(90));
    }];
    self.imgView.image = [[UIImage alloc] imageWithScreenshot];
    
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.imgView);
        make.size.mas_equalTo(CGSizeMake(imgWidth - 3 * MaxPadding, AdaptY(40)));
    }];
    self.timeLabel.text = [DateManager stringConvert_YMDHMS_FromDate:[NSDate date]];
    CGAffineTransform transform= CGAffineTransformMakeRotation(-M_PI_2 / 3);
    self.timeLabel.transform = transform;

    
    [self.contentView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.imgView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(imgWidth, bottomHeight));
    }];
    
    [self.bottomView addSubview:self.logoView];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.left.mas_equalTo(self.bottomView.mas_left).offset(MaxPadding);
        make.size.mas_equalTo(CGSizeMake(AdaptX(30), AdaptX(30)));
    }];
    
    [self.bottomView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoView.mas_top);
        make.left.mas_equalTo(self.logoView.mas_right).offset(MidPadding);
    }];
    
    [self.bottomView addSubview:self.summaryLabel];
    [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.logoView.mas_bottom);
        make.left.mas_equalTo(self.nameLabel.mas_left);
    }];
    
    [self.bottomView addSubview:self.codeView];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bottomView.mas_right).offset(-MaxPadding);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AdaptX(40), AdaptX(40)));
    }];
    
    WeakSelf(self);
    [self addSubview:self.shareView];
    self.shareView.backBlock = ^{
        [UIView animateWithDuration:0.3 animations:^{
            weakself.alpha = 0;
            weakself.shareView.frame = CGRectMake(0,  MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, ShareHeight);
        } completion:^(BOOL finished) {
            [weakself removeFromSuperview];
        }];
    };
    self.shareView.shareBlock = ^(SSDKPlatformType type) {
        UIImage *img = [UIImage getImage:weakself.contentView size:CGSizeMake(imgWidth, MAINSCREEN_HEIGHT - ShareHeight - TabbarNSH - StatusBarH - AdaptY(90) + bottomHeight)];
        [weakself.shareView shareWithImage:img type:type];
    };
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self.shareView.frame = CGRectMake(0, MAINSCREEN_HEIGHT - ShareHeight, MAINSCREEN_WIDTH, ShareHeight);
    }];

}

#pragma mark - init
- (BaseView *)contentView{
    if (!_contentView) {
        _contentView = [[BaseView alloc] init];
    }
    return _contentView;
}

- (BaseView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[BaseView alloc] init];
        _bottomView.backgroundColor = MainTextColor;
    }
    return _bottomView;
}

- (BaseImageView *)logoView{
    if (!_logoView) {
        _logoView = [[BaseImageView alloc] initWithImage:ImageName(@"logo")];
    }
    return _logoView;
}

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [SEFactory labelWithText:Rainbow frame:CGRectZero textFont:Font(12) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (BaseLabel *)summaryLabel{
    if (!_summaryLabel) {
        _summaryLabel = [SEFactory labelWithText:DigitalFutureControl frame:CGRectZero textFont:Font(10) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _summaryLabel;
}

- (BaseImageView *)codeView{
    if (!_codeView) {
        _codeView = [[BaseImageView alloc] initWithImage:[[SEUserDefaults shareInstance] getShareCode:CGSizeMake(AdaptX(40), AdaptX(40))]];
    }
    return _codeView;
}

- (BaseImageView *)imgView{
    if (!_imgView) {
        _imgView = [[BaseImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}

- (ShareMenuView *)shareView{
    if (!_shareView) {
        _shareView = [[ShareMenuView alloc] initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, ShareHeight) shareType:ShareMarketType];
    }
    return _shareView;
}

- (BaseLabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(13) textColor:MainTextColor textAlignment:NSTextAlignmentCenter];
        ViewBorderRadius(_timeLabel, AdaptX(5), 1, MainTextColor);
        _timeLabel.backgroundColor = [LightGrayColor colorWithAlphaComponent:0.1];
    }
    return _timeLabel;
}

@end
