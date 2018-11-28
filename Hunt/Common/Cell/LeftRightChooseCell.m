//
//  LeftRightChooseCell.m
//  wxer_manager
//
//  Created by levin on 2017/7/8.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "LeftRightChooseCell.h"

@interface LeftRightChooseCell ()

@property (nonatomic, strong) BaseButton *leftBtn;
@property (nonatomic, strong) BaseButton *rightBtn;


@property (nonatomic, copy) NSString *leftStr;
@property (nonatomic, copy) NSString *rightStr;

@end

@implementation LeftRightChooseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier leftStr:(NSString *)leftStr rightStr:(NSString *)rightStr{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftStr = leftStr;
        self.rightStr = rightStr;
        [self createUI];
    }
    return self;
}

- (instancetype)initTypeChooseCell:(UITableView *)tableView cellID:(NSString *)cellid leftStr:(NSString *)leftStr rightStr:(NSString *)rightStr{
    
    self = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!self) {
        
        self = [[LeftRightChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid leftStr:leftStr rightStr:rightStr];
    }
    return self;
}

+ (instancetype)typeChooseCell:(UITableView *)tableView cellID:(NSString *)cellid leftStr:(NSString *)leftStr rightStr:(NSString *)rightStr{
    return [[LeftRightChooseCell alloc] initTypeChooseCell:tableView cellID:cellid leftStr:leftStr rightStr:rightStr];
}

- (void)setExchangeModel:(Transaction *)exchangeModel{
    _exchangeModel = exchangeModel;
    if (!exchangeModel.isExchange) {
        self.rightBtn.selected = YES;
        self.leftBtn.selected = NO;
    }else{
        self.rightBtn.selected = NO;
        self.leftBtn.selected = YES;
    }
}

- (void)buttonTouch:(BaseButton *)sender{
    
    if (sender.tag == 1) {
        sender.selected = YES;
        self.rightBtn.selected = NO;
    }else{
        sender.selected = YES;
        self.leftBtn.selected = NO;
    }
    if (self.buttonTouch) {
        self.buttonTouch(sender.tag);
    }
}

- (void)createUI{
    
    self.leftBtn = [SEFactory buttonWithTitle:self.leftStr image:ImageName(@"selectbox_normal") frame:CGRectZero font:CELLCONTECTFONT fontColor:MainTextColor];
    self.leftBtn.selected = YES;
    self.leftBtn.tag = 1;
    [self.leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, -8)];
    [self.leftBtn setImage:[ThemeManager imageForKey:@"selectbox_on"] forState:UIControlStateSelected];
    [self.leftBtn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(AdaptX(15));
        make.top.bottom.mas_equalTo(self.contentView);
    }];
    
    self.rightBtn = [SEFactory buttonWithTitle:self.rightStr image:ImageName(@"selectbox_normal") frame:CGRectZero font:CELLCONTECTFONT fontColor:MainTextColor];
    self.rightBtn.tag = 2;
    [self.rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, -8)];
    [self.rightBtn setImage:[ThemeManager imageForKey:@"selectbox_on"] forState:UIControlStateSelected];
    [self.rightBtn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX);
        make.top.bottom.mas_equalTo(self.contentView);
    }];
}


@end
