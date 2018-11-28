//
//  NoDataView.m
//  SuperEducation
//
//  Created by yangming on 2017/5/31.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "NoDataView.h"

@interface NoDataView ()

@property (nonatomic, strong) BaseImageView *coverView;
@property (nonatomic, strong) BaseLabel *tagLabel;
@property (nonatomic, strong) BaseButton *reloadButton;
@property (nonatomic, copy) BaseBlock reloadBlock;
/* tagStr */
@property (nonatomic, copy) NSString *tagStr;


@end

@implementation NoDataView

- (instancetype)init{
    if (self == [super init]) {
        
        self.backgroundColor = BackGroundColor;
    }
    return self;
}

- (void)showNoDataView:(CGRect)frame type:(NoDataType)type tagStr:(NSString *)tagStr needReload:(BOOL)needReload reloadBlock:(void(^)(void))reloadBlock{
    
    self.tagStr = tagStr;
    self.frame = frame;
    
    if (self.frame.size.height < AdaptX(150)) {
        self.hidden = YES;
    }else{
        
        self.hidden = NO;
        [self.superview bringSubviewToFront:self];
        
        [self createUI];
        
        self.reloadBlock = reloadBlock;
        self.reloadButton.hidden = !needReload;
        
        [self reloadDataWithType:type];
    }
}

//刷新数据
- (void)reloadDataWithType:(NoDataType)type{
    
    NSString *imageStr = @"";
    NSString *str = @"";
    NSString *btnTitle = @"";
    switch (type) {
        case NoTextType:
        {
            str = NoDataTag;
            imageStr = @"search_no";
        }
            break;
        case NoNetworkType:
        {
            str = @"请检查网络";
            imageStr = @"no_network";
        }
            break;
        case NoFlashType:
        {
            str = @"暂无快讯";
            imageStr = @"no_flash";
        }
            break;
        case NoUnWarnType:
        {
            str = @"暂无未触发预警";
            imageStr = @"no_warn";
        }
            break;
        case NoHistoryType:
        {
            str = @"暂无历史预警";
            imageStr = @"no_warn";
        }
            break;
        case NoSearchType:
        {
            str = NoSearchTag;
            imageStr = @"search_no";
        }
            break;
        case NoMessageType:{
            str = @"暂无消息";
            imageStr = @"no_message";
        }
            break;
    }
    
    UIImage *image = ImageName(imageStr);
    self.coverView.image = image;
    
    self.coverView.frame = CGRectMake((self.frame.size.width - AdaptX(150))/2, (self.frame.size.height - AdaptX(150)) / 2 - AdaptY(50), AdaptX(150), AdaptX(150));
    
    self.tagLabel.text = str;
}

#pragma mark - action
- (void)reloadTouch:(BaseButton *)sender{
    
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.coverView];
    self.coverView.frame = CGRectMake((self.frame.size.width - AdaptX(150))/2, (self.frame.size.height - AdaptX(150)) / 2 - AdaptY(50), AdaptX(150), AdaptX(150));
    
    [self addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverView.mas_bottom).offset(15 * SCALE_HEIGHT);
        make.left.right.mas_equalTo(self);
        make.height.equalTo(@(20 * SCALE_HEIGHT));
    }];
    
    [self addSubview:self.reloadButton];
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.tagLabel.mas_bottom).offset(15 * SCALE_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(120 * SCALE_WIDTH, 42 * SCALE_HEIGHT));
    }];
}

- (BaseImageView *)coverView{
    if (!_coverView) {
        _coverView = [[BaseImageView alloc] init];
    }
    return _coverView;
}

- (BaseLabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(15 * SCALE_WIDTH) textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentCenter];;
    }
    return _tagLabel;
}

- (BaseButton *)reloadButton{
    if (!_reloadButton) {
        _reloadButton = [SEFactory buttonWithTitle:@"重新加载" image:nil frame:CGRectZero font:Font(15 * SCALE_WIDTH) fontColor:WhiteTextColor];
        [_reloadButton py_addToThemeColorPool:@"backgroundColor"];
        ViewRadius(_reloadButton, 4 * SCALE_WIDTH);
        [_reloadButton addTarget:self action:@selector(reloadTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadButton;
}

@end
