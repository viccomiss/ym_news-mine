//
//  WeightMenuView.m
//  Hunt
//
//  Created by 杨明 on 2018/7/30.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "WeightMenuView.h"
#import "WeightMenuButton.h"
#import "NSString+JLAdd.h"

#define itemWidth AdaptX(MAINSCREEN_WIDTH / 6)

@interface WeightMenuView()

/* titles */
@property (nonatomic, strong) NSArray *titles;
/* sels */
@property (nonatomic, strong) NSMutableArray *buttonArray;
/* menuType */
@property (nonatomic, assign) WeightMenuType menuType;

@end

@implementation WeightMenuView

- (instancetype)initWithMenuType:(WeightMenuType)menuType titleArray:(NSArray *)titles{
    if (self == [super init]) {
        
        self.backgroundColor = WhiteTextColor;
        self.menuType = menuType;
        self.titles = titles;
        [self createUI];
    }
    return self;
}

#pragma mark - action
- (void)menuTouch:(WeightMenuButton *)sender{
    for (WeightMenuButton *b in self.buttonArray) {
        if (b.tag == sender.tag) {
            if (b.type == WeightMenuBtnNormalType) {
                b.type = WeightMenuBtnDownType;
                b.selected = YES;
            }else if (b.type == WeightMenuBtnDownType){
                b.type = WeightMenuBtnUpType;
                b.selected = YES;
            }else{
                b.type = WeightMenuBtnNormalType;
                b.selected = NO;
            }
            sender = b;
        }else{
            b.type = WeightMenuBtnNormalType;
            b.selected = NO;
        }
    }
    
    if (self.weightMenuBlock) {
        self.weightMenuBlock(sender.type, sender.tag);
    }
}

#pragma mark - UI
- (void)createUI{
    
    CGFloat widthLast = 0;
    switch (self.menuType) {
        case WeightMenuFourType:
        {
            for (int i = 0; i < 2; i++) {
                WeightMenuButton *btn = [[WeightMenuButton alloc] init];
                btn.titleLabel.font = Font(11);
                [btn setTitle:self.titles[i] forState:UIControlStateNormal];
                CGFloat w = [self.titles[i] widthOfFontSize:11];
                [btn setTitleColor:LightTextGrayColor forState:UIControlStateNormal];
                btn.type = WeightMenuBtnNormalType;
                [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
                [btn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateSelected)]];
                btn.tag = i;
                [btn addTarget:self action:@selector(menuTouch:) forControlEvents:UIControlEventTouchUpInside];
                [btn setContentMode:UIViewContentModeLeft];
                [self addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.mas_left).offset(MaxPadding * (i + 1) + widthLast * i);
                    make.centerY.height.mas_equalTo(self);
                    make.width.equalTo(@(w + 10));
                }];
                widthLast = w + 10;
                
                [self.buttonArray addObject:btn];
            }
            
            for (int i = 3; i > 1; i--) {
                WeightMenuButton *btn = [[WeightMenuButton alloc] init];
                btn.titleLabel.font = Font(11);
                [btn setTitle:self.titles[i] forState:UIControlStateNormal];
                CGFloat w = [self.titles[i] widthOfFontSize:11];
                [btn setTitleColor:LightTextGrayColor forState:UIControlStateNormal];
                btn.type = WeightMenuBtnNormalType;
                [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
                [btn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateSelected)]];
                btn.tag = i;
                [btn addTarget:self action:@selector(menuTouch:) forControlEvents:UIControlEventTouchUpInside];
                [btn setContentMode:UIViewContentModeRight];
                [self addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.mas_right).offset(-MaxPadding * (4 - i) + widthLast * (i - 3));
                    make.centerY.height.mas_equalTo(self);
                    make.width.equalTo(@(w + 10));
                }];
                widthLast = w + 10;
                
                [self.buttonArray addObject:btn];
            }
        }
            break;
        case WeightMenuThreeType:
        {
            for (int i = 0; i < 1; i++) {
                WeightMenuButton *btn = [[WeightMenuButton alloc] init];
                btn.titleLabel.font = Font(11);
                [btn setTitle:self.titles[i] forState:UIControlStateNormal];
                CGFloat w = [self.titles[i] widthOfFontSize:11];
                [btn setTitleColor:LightTextGrayColor forState:UIControlStateNormal];
                btn.type = WeightMenuBtnNormalType;
                [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
                [btn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateSelected)]];
                btn.tag = i;
                [btn addTarget:self action:@selector(menuTouch:) forControlEvents:UIControlEventTouchUpInside];
                [btn setContentMode:UIViewContentModeLeft];
                [self addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.mas_left).offset(MaxPadding * (i + 1) + widthLast * i);
                    make.centerY.height.mas_equalTo(self);
                    make.width.equalTo(@(w + 10));
                }];
                widthLast = w + 10;
                
                [self.buttonArray addObject:btn];
            }
            
            for (int i = 2; i > 0; i--) {
                WeightMenuButton *btn = [[WeightMenuButton alloc] init];
                btn.titleLabel.font = Font(11);
                [btn setTitle:self.titles[i] forState:UIControlStateNormal];
                CGFloat w = [self.titles[i] widthOfFontSize:11];
                [btn setTitleColor:LightTextGrayColor forState:UIControlStateNormal];
                btn.type = WeightMenuBtnNormalType;
                [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
                [btn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateSelected)]];
                btn.tag = i;
                [btn addTarget:self action:@selector(menuTouch:) forControlEvents:UIControlEventTouchUpInside];
                [btn setContentMode:UIViewContentModeRight];
                [self addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.mas_right).offset(-MaxPadding * (3 - i) + widthLast * (i - 2));
                    make.centerY.height.mas_equalTo(self);
                    make.width.equalTo(@(w + 10));
                }];
                widthLast = w + 10;
                
                [self.buttonArray addObject:btn];
            }
        }
            break;
        case WeightMenuTwoType:
        {
            for (int i = 0; i < 2; i++) {
                WeightMenuButton *btn = [[WeightMenuButton alloc] init];
                btn.titleLabel.font = Font(11);
                [btn setTitle:self.titles[i] forState:UIControlStateNormal];
                CGFloat w = [self.titles[i] widthOfFontSize:11];
                [btn setTitleColor:LightTextGrayColor forState:UIControlStateNormal];
                btn.type = WeightMenuBtnNormalType;
                [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
                [btn py_addToThemeColorPoolWithSelector:@selector(setTitleColor:forState:) objects:@[PYTHEME_THEME_COLOR, @(UIControlStateSelected)]];
                btn.tag = i;
                [btn addTarget:self action:@selector(menuTouch:) forControlEvents:UIControlEventTouchUpInside];
                [btn setContentMode:UIViewContentModeLeft];
                [self addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (i == 0) {
                        make.left.mas_equalTo(self.mas_left).offset(MaxPadding );
                    }else{
                        make.right.mas_equalTo(self.mas_right).offset(-MaxPadding);
                    }
                    make.centerY.height.mas_equalTo(self);
                    make.width.equalTo(@(w + 10));
                }];
                
                if (i == self.failIndex) {
                    btn.failer = YES;
                }
                
                [self.buttonArray addObject:btn];
            }
        }
            break;
        default:
            break;
    }
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = LineColor;
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.equalTo(@(0.5));
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = LineColor;
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self);
        make.height.equalTo(@(0.5));
    }];
}

#pragma mark - init
- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

@end
