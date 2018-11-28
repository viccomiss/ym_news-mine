//
//  TitleAndTextViewCell.m
//  wxer_manager
//
//  Created by levin on 2017/7/8.
//  Copyright © 2017年 congzhikeji. All rights reserved.
//

#import "TitleAndTextViewCell.h"

@interface TitleAndTextViewCell ()<UITextViewDelegate>

@property (nonatomic, strong) BaseTextView *textView;
/** copyBtn */
@property (nonatomic, strong) BaseButton *otherButton;
/* length */
@property (nonatomic, strong) BaseLabel *lengthLabel;

@end

@implementation TitleAndTextViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (instancetype)initTitleAndTextViewCell:(UITableView *)tableView cellID:(NSString *)cellid{
    self = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!self) {
        
        self = [[TitleAndTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return self;
}

+ (instancetype)titleAndTextViewCell:(UITableView *)tableView cellID:(NSString *)cellid{
    return [[TitleAndTextViewCell alloc] initTitleAndTextViewCell:tableView cellID:cellid];
}

- (void)otherTouch:(BaseButton *)sender{
    
    if (self.otherBlock) {
        self.otherBlock();
    }
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.textView.text = placeholder;
}

- (void)setOtherTitle:(NSString *)otherTitle{
    _otherTitle = otherTitle;
    self.otherButton.hidden = NO;
    [self.otherButton setTitle:otherTitle forState:UIControlStateNormal];
}

- (void)setCharacterLength:(BOOL)characterLength{
    _characterLength = characterLength;
    self.lengthLabel.hidden = !characterLength;
}

- (void)setNotesModel:(Transaction *)notesModel{
    _notesModel = notesModel;
    if (notesModel.notes.length == 0) {
        self.textView.text = self.placeholder;
        self.textView.textColor = FailureTextColor;
    }else{
        self.textView.text = notesModel.notes;
        self.textView.textColor = MainTextColor;
    }
}

- (void)createUI{
    
//    self.otherButton = [SEFactory buttonWithTitle:@"" image:nil frame:CGRectZero font:CELLCONTECTFONT fontColor:MainBlueColor];
//    self.otherButton.hidden = YES;
//    [self.otherButton addTarget:self action:@selector(otherTouch:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:self.otherButton];
//    [self.otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.contentView.mas_right).offset(-CELLMARGIN);
//        make.top.height.mas_equalTo(self.titleLabel);
//        make.width.equalTo(@(CELLTITLEWIDTH));
//    }];
    
    self.textView = [SEFactory textViewWithText:@"" frame:CGRectZero font:CELLCONTECTFONT];
    self.textView.delegate = self;
    self.textView.textColor = LightTextGrayColor;
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(CELLMARGIN);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-CELLMARGIN);
        make.top.mas_equalTo(self.contentView.mas_top).offset(AdaptY(5));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-AdaptY(5));
    }];
    
    self.lengthLabel = [SEFactory labelWithText:@"" frame:CGRectZero textFont:Font(12) textColor:LightTextGrayColor textAlignment:NSTextAlignmentRight];
    self.lengthLabel.hidden = YES;
    [self.contentView addSubview:self.lengthLabel];
    [self.lengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.textView).offset(-AdaptX(5));
        make.height.equalTo(@(AdaptY(15)));
    }];
}

-(void)textViewDidChange:(UITextView *)textView{
    textView.textColor = MainTextColor;
   
    if (self.notesModel) {
        if (textView.text.length > 200) {
            [EasyTextView showText:@"最多200个字符"];
            textView.text = [textView.text substringToIndex:200];
            return;
        }
        self.lengthLabel.text = [NSString stringWithFormat:@"%ld/200",textView.text.length];
        self.notesModel.notes = textView.text;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:self.placeholder]) {
        textView.text = @"";
    }
    textView.textColor = MainTextColor;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        textView.text = self.placeholder;
        textView.textColor = FailureTextColor;
    }
}

@end
