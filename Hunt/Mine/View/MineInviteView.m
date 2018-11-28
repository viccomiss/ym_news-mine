//
//  MineInviteView.m
//  Hunt
//
//  Created by 杨明 on 2018/8/5.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "MineInviteView.h"

@interface MineInviteView()

/* tag */
@property (nonatomic, strong) BaseLabel *tagLabel;
/* inviteBtn */
@property (nonatomic, strong) BaseButton *inviteBtn;
/* codeView */
@property (nonatomic, strong) BaseImageView *codeView;
/* code */
@property (nonatomic, strong) BaseLabel *codeLabel;
/* codetag */
@property (nonatomic, strong) BaseLabel *codeTagLabel;

@end

@implementation MineInviteView

- (instancetype)init{
    if (self == [super init]) {
        
        self.backgroundColor = WhiteTextColor;
        [self createUI];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)themeChange:(NSNotification *)notification{
    
    self.codeView.image = [ThemeManager imageForKey:@"invite_back"];
}

- (void)setUser:(UserModel *)user{
    _user = user;
    
    self.codeLabel.text = user.user.code;
}

#pragma mark - action
- (void)tap{
    if (self.inviteBlock) {
        self.inviteBlock();
    }
}

#pragma mark - UI
- (void)createUI{
    
    [self addSubview:self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(AdaptX(15));
        make.top.mas_equalTo(self.mas_top);
        make.height.equalTo(@(AdaptY(44)));
    }];
    
    [self addSubview:self.inviteBtn];
    [self.inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-2 * MidPadding);
        make.centerY.mas_equalTo(self.tagLabel.mas_centerY);
    }];
    
    [self addSubview:self.codeView];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-AdaptX(15));
        make.left.mas_equalTo(self.mas_left).offset(AdaptX(15));
        make.right.mas_equalTo(self.mas_right).offset(-AdaptX(15));
        make.top.mas_equalTo(self.mas_top).offset(AdaptY(44));
    }];
    
    [self addSubview:self.codeLabel];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.codeView.mas_left).offset(2 * MidPadding);
        make.bottom.mas_equalTo(self.codeView.mas_centerY).offset(AdaptY(5));
    }];
    
    [self addSubview:self.codeTagLabel];
    [self.codeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.codeLabel);
        make.top.mas_equalTo(self.codeLabel.mas_bottom).offset(AdaptY(5));
    }];
}

#pragma mark - init
- (BaseLabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [SEFactory labelWithText:MyInvitationCode frame:CGRectZero textFont:[UIFont boldSystemFontOfSize:15] textColor:MainBlackColor textAlignment:NSTextAlignmentLeft];
    }
    return _tagLabel;
}

- (BaseButton *)inviteBtn{
    if (!_inviteBtn) {
        _inviteBtn = [SEFactory buttonWithTitle:GenerateInvitationCARDS image:ImageName(@"arrow_right") frame:CGRectZero font:Font(12) fontColor:DarkBlackColor];
        [_inviteBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        _inviteBtn.userInteractionEnabled = NO;
    }
    return _inviteBtn;
}

- (BaseImageView *)codeView{
    if (!_codeView) {
        _codeView = [[BaseImageView alloc] initWithImage:[ThemeManager imageForKey:@"invite_back"]];
        ViewRadius(_codeView, AdaptX(5));
    }
    return _codeView;
}

- (BaseLabel *)codeLabel{
    if (!_codeLabel) {
        _codeLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(25) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _codeLabel;
}

- (BaseLabel *)codeTagLabel{
    if (!_codeTagLabel) {
        _codeTagLabel = [SEFactory labelWithText:InviteFriendsCarveUpCandy frame:CGRectZero textFont:Font(11) textColor:WhiteTextColor textAlignment:NSTextAlignmentLeft];
    }
    return _codeTagLabel;
}


@end
