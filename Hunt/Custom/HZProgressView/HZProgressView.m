//
//  HZProgressView.m
//  Hunt
//
//  Created by 杨明 on 2018/8/20.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "HZProgressView.h"

@interface HZProgressView()

/* bg */
@property (nonatomic, strong) BaseImageView *bgView;
/* progress */
@property (nonatomic, strong) BaseView *proView;
/* left */
@property (nonatomic, strong) BaseLabel *leftLabel;
/* right */
@property (nonatomic, strong) BaseLabel *rightLabel;

@end

@implementation HZProgressView

- (instancetype)init{
    if (self == [super init]) {
        
        self.backgroundColor = [ThemeManager sharedInstance].lightThemeColor;
        ViewRadius(self, AdaptX(3));
        [self createUI];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    [self.proView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self.mas_width).multipliedBy(progress);
    }];
}

- (void)setState:(ProgressState)state{
    _state = state;
    switch (state) {
        case ProgressNegState:
        {
            self.bgView.image = ImageName(@"progress_bg");
        }
            break;
        default:
        {
            self.bgView.image = ImageName(@"");
        }
            break;
    }
}

- (void)setLeftTag:(NSString *)leftTag{
    _leftTag = leftTag;
    self.leftLabel.text = leftTag;
}

- (void)setRightTag:(NSString *)rightTag{
    _rightTag = rightTag;
    self.rightLabel.text = rightTag;
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self addSubview:self.proView];
    [self.proView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self);
        make.width.equalTo(@(100));
    }];
    
    [self addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.mas_left).offset(MinPadding);
    }];
    
    [self addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).offset(-MinPadding);
    }];
}

#pragma mark - init
- (BaseImageView *)bgView{
    if (!_bgView) {
        _bgView = [[BaseImageView alloc] init];
    }
    return _bgView;
}

- (BaseView *)proView{
    if (!_proView) {
        _proView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, 100, self.easy_height)];
        [_proView py_addToThemeColorPool:@"backgroundColor"];
    }
    return _proView;
}

- (BaseLabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(10) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
        _leftLabel.numberOfLines = 0;
    }
    return _leftLabel;
}

- (BaseLabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(10) textColor:WhiteTextColor textAlignment:NSTextAlignmentRight];
        _rightLabel.numberOfLines = 0;
    }
    return _rightLabel;
}

@end
