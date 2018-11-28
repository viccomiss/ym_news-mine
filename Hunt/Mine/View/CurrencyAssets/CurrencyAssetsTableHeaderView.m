//
//  CurrencyAssetsTableHeaderView.m
//  Hunt
//
//  Created by 杨明 on 2018/8/20.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CurrencyAssetsTableHeaderView.h"

@interface CurrencyAssetsTableHeaderView()

/* weightBtn */
@property (nonatomic, strong) BaseButton *weightBtn;
/* balance */
@property (nonatomic, strong) BaseButton *balanceBtn;

@end

@implementation CurrencyAssetsTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = BackGroundColor;
        [self createUI];
    }
    return self;
}

#pragma mark - action
- (void)weightTouch{
    
}

- (void)balanceTouch:(BaseButton *)sender{
    sender.selected = !sender.selected;
    
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.weightBtn];
    [self.weightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(AdaptX(15));
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self addSubview:self.balanceBtn];
    [self.balanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-AdaptX(15));
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

#pragma mark - init
- (BaseButton *)weightBtn{
    if (!_weightBtn) {
        _weightBtn = [SEFactory buttonWithTitle:TotalAssets image:[ThemeManager imageForKey:@"arrow_down"] frame:CGRectZero font:Font(12) fontColor:TextDarkGrayColor];
        [_weightBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
        [_weightBtn addTarget:self action:@selector(weightTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weightBtn;
}

- (BaseButton *)balanceBtn{
    if (!_balanceBtn) {
        _balanceBtn = [SEFactory buttonWithTitle:ShowBalanceCurrency image:ImageName(@"selectbox_small_normal") frame:CGRectZero font:Font(12) fontColor:TextDarkGrayColor];
        [_balanceBtn setImage:[ThemeManager imageForKey:@"selectbox_small_on"] forState:UIControlStateSelected];
        [_balanceBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:4];
        [_balanceBtn addTarget:self action:@selector(balanceTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _balanceBtn;
}


@end
