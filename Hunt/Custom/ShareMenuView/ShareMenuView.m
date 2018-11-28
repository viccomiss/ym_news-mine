//
//  ShareMenuView.m
//  Hunt
//
//  Created by 杨明 on 2018/8/9.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "ShareMenuView.h"
#import "Constant.h"
#import "NSDictionary+JKSafeAccess.h"

@interface ShareMenuView()

/* array */
@property (nonatomic, strong) NSMutableArray *btnArray;
/* type */
@property (nonatomic, assign) ShareType type;

@end

@implementation ShareMenuView

- (instancetype)initWithFrame:(CGRect)frame shareType:(ShareType)type{
    if (self == [super initWithFrame:frame]) {
        
        self.type = type;
        self.backgroundColor = WhiteTextColor;
        [self createUI];
    }
    return self;
}

#pragma mark - action
- (void)shareTouch:(BaseButton *)sender{
    if (self.shareBlock) {
        self.shareBlock(sender.tag);
    }
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (!error) {
        [EasyTextView showText:SaveSuccess];
    }
}

//分享红包
- (void)shareRedEnvelopeWithData:(NSDictionary *)data type:(SSDKPlatformType)type{
    
    NSString *intro = [data jk_stringForKey:@"intro"];
    NSString *title = [data jk_stringForKey:@"title"];
    NSString *url = [data jk_stringForKey:@"url"];
    NSString *img = [data jk_stringForKey:@"img"];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:intro images:[UIImage imageNamed:img] url:[NSURL URLWithString:url] title:title type:SSDKContentTypeWebPage];
    [ShareSDK share:type //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
         NSLog(@"state ==== %ld",state);
     }];
    [shareParams SSDKEnableUseClientShare];
}

//分享豆腐块
//- (void)shareBundleWithId:(Bundle *)bundle type:(SSDKPlatformType)type{
//
//    [EasyLoadingView showLoading];
//    [APIManager SafePOST:URI_USR_COURSE_SHARE_BUNDLE parameters:@{@"bundleId": bundle.ID} success:^(NSURLResponse *respone, id responseObject) {
//        
//        NSDictionary *result = [responseObject jk_dictionaryForKey:@"result"];
//        NSString *intro = [result jk_stringForKey:@"intro"];
//        NSString *title = [result jk_stringForKey:@"title"];
//        NSString *url = [result jk_stringForKey:@"url"];
//        NSString *img = [result jk_stringForKey:@"img"];
//
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:intro images:img url:[NSURL URLWithString:url] title:title type:SSDKContentTypeWebPage];
//        [ShareSDK share:type //传入分享的平台类型
//             parameters:shareParams
//         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
//             NSLog(@"state ==== %ld",state);
//         }];
//        [shareParams SSDKEnableUseClientShare];
//
//    } failure:^(NSURLResponse *respone, NSError *error) {
//
//    }];
//}

//分享图片
- (void)shareWithImage:(UIImage *)img type:(SSDKPlatformType)type{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    if (type == SSDKPlatformTypeAny) {
        [self loadImageFinished:img];
        return;
    }
    
    [shareParams SSDKSetupShareParamsByText:nil images:img url:nil title:nil type:SSDKContentTypeImage];
    
    //进行分享
    [ShareSDK share:type //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
         NSLog(@"state ==== %ld",state);
     }];
}

- (void)backTouch{
    if (self.backBlock) {
        self.backBlock();
    }
}

#pragma mark - UI
- (void)createUI{

    NSArray *titles;
    NSArray *imgs;
    NSArray *types;
    NSString *backStr = @"";
    if (self.type == ShareBundleType) {
        titles = @[MakePoster,WechatFriends,Moments];
        imgs = @[@"share_poster",@"share_wechat",@"share_friends"];
        types = @[[NSNumber numberWithUnsignedInteger:SSDKPlatformTypePoster],[NSNumber numberWithUnsignedInteger:SSDKPlatformSubTypeWechatSession],[NSNumber numberWithUnsignedInteger:SSDKPlatformSubTypeWechatTimeline]];
        backStr = ShareBundleToFriends;
    }else if (self.type == ShareNewsType){
        titles = @[WechatFriends,Moments,ShareLink];
        imgs = @[@"share_wechat",@"share_friends",@"share_link"];
        types = @[[NSNumber numberWithUnsignedInteger:SSDKPlatformSubTypeWechatSession],[NSNumber numberWithUnsignedInteger:SSDKPlatformSubTypeWechatTimeline],[NSNumber numberWithUnsignedInteger:SSDKPlatformTypeCopyLink]];
        backStr = ShareNewsToFriends;
    }else{
        
        if (self.type == ShareCodeType) {
            backStr = InvitationCardEquippedSentFriends;
        }else if (self.type == ShareMarketType){
            backStr = ShareMarketToFriends;
        }else if (self.type == ShareFlashType){
            backStr = ShareFlashToFriends;
        }
        
        titles = @[WechatFriends,Moments,SaveLocal];
        imgs = @[@"share_wechat",@"share_friends",@"share_folder"];
        types = @[[NSNumber numberWithUnsignedInteger:SSDKPlatformSubTypeWechatSession],[NSNumber numberWithUnsignedInteger:SSDKPlatformSubTypeWechatTimeline],[NSNumber numberWithUnsignedInteger:SSDKPlatformTypeAny]];
    }
    
    BaseButton *backBtn = [SEFactory buttonWithTitle:backStr image:ImageName(@"arrow_left") frame:CGRectZero font:Font(12) fontColor:TextDarkGrayColor];
    [backBtn addTarget:self action:@selector(backTouch) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    [backBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(AdaptX(15));
        make.top.mas_equalTo(self.mas_top).offset(AdaptY(15));
        make.height.equalTo(@(AdaptY(20)));
    }];

    
    CGFloat width = MAINSCREEN_WIDTH / titles.count;
    for (int i = 0; i < titles.count; i++) {
        BaseButton *btn = [SEFactory buttonWithTitle:titles[i] image:ImageName(imgs[i]) frame:CGRectZero font:Font(12) fontColor:MainBlackColor];
        [btn addTarget:self action:@selector(shareTouch:) forControlEvents:UIControlEventTouchUpInside];
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:2 * MidPadding];
        btn.tag = [types[i] integerValue];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(width * i);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-TabbarNSH);
            make.top.mas_equalTo(backBtn.mas_bottom).offset(AdaptY(15));
            make.width.equalTo(@(width));
        }];
        [self.btnArray addObject:btn];
    }
}

#pragma mark - init
- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}


@end
