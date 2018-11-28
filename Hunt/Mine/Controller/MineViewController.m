//
//  MineViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/5/30.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "MineViewController.h"
#import "MineCell.h"
#import "MineModel.h"
#import "MineHeaderView.h"
#import "LanguageViewController.h"
#import "CurrencyListViewController.h"
#import "SkinListViewController.h"
#import "UserInfoViewController.h"
#import "LoginViewController.h"
#import "InviteCodeViewController.h"
#import "MessageViewController.h"
#import "ContactViewController.h"
#import "AboutHuntViewController.h"
#import "SEUserDefaults.h"
#import "UserModel.h"
#import "LocalizedHelper.h"
#import "CurrencyAssetsViewController.h"
#import "CurrencyHelper.h"
#import "WXRWebViewController.h"
#import "AppInfo.h"
#import "AssetModel.h"
#import "NSString+JLAdd.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/* header */
@property (nonatomic, strong) MineHeaderView *headerView;
/* user */
@property (nonatomic, strong) UserModel *user;
/* asset */
@property (nonatomic, strong) Asset *asset;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCacheSize];
    
    self.user = [[SEUserDefaults shareInstance] getUserModel];
    [self.headerView reloadLoginState];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView reloadData];
    
    if ([[SEUserDefaults shareInstance] userIsLogin]) {
        [self loadAssetAll];
    }
    [UMAnalyticsHelper beginEvent:home_grzx];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [UMAnalyticsHelper endEvent:home_grzx];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    [self setData];
}

- (void)reloadTheme:(NSNotification *)notification{
    
}

- (void)setData{
    NSMutableArray *arr1 = [NSMutableArray array];
    //MessageCenter  , [NSNumber numberWithUnsignedInteger:MineNormalCellType]
    NSArray *nameArr1 = @[CurrencyAssets,SwitchColorOfCandlestick,CurrencySettings,Language,SkinSwitch];
    NSArray *type1 = @[[NSNumber numberWithUnsignedInteger:MineSummaryCellType],[NSNumber numberWithUnsignedInteger:MineSwitchCellType],[NSNumber numberWithUnsignedInteger:MineSummaryCellType],[NSNumber numberWithUnsignedInteger:MineSummaryCellType],[NSNumber numberWithUnsignedInteger:MineSummaryCellType]];
    for (int i = 0; i < nameArr1.count; i++) {
        MineModel *model = [[MineModel alloc] init];
        model.name = nameArr1[i];
        model.type = [type1[i] integerValue];
        [arr1 addObject:model];
    }
    
    NSMutableArray *arr2 = [NSMutableArray array];
    NSArray *nameArr2 = @[ContactUs,AboutUs];
    NSArray *type2 = @[[NSNumber numberWithUnsignedInteger:MineNormalCellType], [NSNumber numberWithUnsignedInteger:MineSummaryCellType]];
    for (int i = 0; i < nameArr2.count; i++) {
        MineModel *model = [[MineModel alloc] init];
        model.name = nameArr2[i];
        model.type = [type2[i] integerValue];
        [arr2 addObject:model];
    }
    
    NSMutableArray *arr3 = [NSMutableArray array];
    NSArray *nameArr3 = @[ClearCache];
    NSArray *type3 = @[[NSNumber numberWithUnsignedInteger:MineSummaryCellType]];
    for (int i = 0; i < nameArr3.count; i++) {
        MineModel *model = [[MineModel alloc] init];
        model.name = nameArr3[i];
        model.type = [type3[i] integerValue];
        [arr3 addObject:model];
    }
    
    [self.dataArray addObject:arr1];
    [self.dataArray addObject:arr2];
    [self.dataArray addObject:arr3];
    [self.tableView reloadData];
}

#pragma mark - request
- (void)loadAssetAll{
    
    [Asset asset_assets_overall:@{} Success:^(Asset *item) {
        
        self.asset = item;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
    } Failure:^(NSError *error) {
        
    }];
}


#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineCell *cell = [MineCell mineCell:tableView];
    NSArray *arr = self.dataArray[indexPath.section];
    MineModel *model = arr[indexPath.row];
    cell.switchBlock = ^(BOOL tag) {
//        [UserModel usr_setting_update:@{@"key": @"rgDisplay", @"value": tag ? [NSNumber numberWithUnsignedInteger:RoseType] : [NSNumber numberWithUnsignedInteger:FallType]} Success:^(id responseObject) {
//
//
//        } Failure:^(NSError *error) {
//
//        }];
        [[SEUserDefaults shareInstance] saveRGDisplay:tag ? RoseType : FallType];
        [UMAnalyticsHelper event:home_hzld];
    };
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if ([[SEUserDefaults shareInstance] userIsLogin]) {
                        NSString *marketStr = [NSString numberFormatterToAllRMB:self.asset.marketCap];
                        NSString *changeRateStr = [NSString stringWithFormat:@"%.2f%%(%@)",self.asset.changeRate,Today];
                        NSString *mergeStr = [NSString stringWithFormat:@"%@ %@",marketStr,changeRateStr];
                        NSRange marketRange = [mergeStr rangeOfString:marketStr];
                        NSRange changeRange = [mergeStr rangeOfString:changeRateStr];
                        
                        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:mergeStr];
                        [attStr addAttribute:NSForegroundColorAttributeName value:[[SEUserDefaults shareInstance] getRiseOrFallColor:self.asset.changeRate >= 0 ? RoseType : FallType] range:changeRange];
                        [attStr addAttribute:NSForegroundColorAttributeName value:MainTextColor range:marketRange];
                        
                        model.attSummary = attStr;
                    }else{
                        model.attSummary = nil;
                    }
                }
                    break;
//                case 1:
//                {
//
//                }
//                    break;
                case 1:
                {
                    model.klineType = [[SEUserDefaults shareInstance] getRGDisplayType];
                }
                    break;
                case 2:
                {
                    NSInteger index = [[CurrencyHelper currencies] indexOfObject:[CurrencyHelper currentCurrency]];
                    model.summary = [NSString stringWithFormat:@"%@%@",[CurrencyHelper currenciesNameArr][index],[CurrencyHelper currentCurrency]];
                }
                    break;
                case 3:
                {
                    model.summary = [[[LocalizedHelper standardHelper] currentLanguage] isEqualToString:@"en"] ? EnglishLanguage : SimChineseLanguage;
                }
                    break;
                case 4:
                {
                    model.summary = [ThemeManager loadThemeInfo] == ThemeBlueType ? ElegantBlue : VibrantOrange;
                    model.summaryColor = [ThemeManager sharedInstance].themeColor;
                }
                    break;
            }
        }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    if ([AppInfo shareInstance].appInfo.version.length != 0) {
                        cell.showTag = YES;
                    }
                    model.summary = [NSString stringWithFormat:@"V%@",[AppInfo currentVersion]];
                }
                    break;
            break;
            }
        case 2:
            switch (indexPath.row) {
                case 0:
                {

                }
                    break;
            }
            break;
    }
    cell.model = model;
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    if ([[SEUserDefaults shareInstance] userIsLogin]) {
                        CurrencyAssetsViewController *assetsVC = [[CurrencyAssetsViewController alloc] init];
                        [self.navigationController pushViewController:assetsVC animated:YES];
                        [UMAnalyticsHelper event:home_bzc];
                        
                    }else{
                        [EasyTextView showText:CurrentAccountNotLoggedIn];
                        [APIManager loginFailureShowLogin:YES];
                    }
                }
                    break;
//                case 1:
//                {
//                    MessageViewController *messageVC = [[MessageViewController alloc] init];
//                    [self.navigationController pushViewController:messageVC animated:YES];
//                }
//                    break;
                case 1:
                    
                    break;
                case 2:
                {
                    CurrencyListViewController *currencyVC = [[CurrencyListViewController alloc] init];
                    [self.navigationController pushViewController:currencyVC animated:YES];
                    [UMAnalyticsHelper event:home_jgxs];
                }
                    break;
                case 3:
                {
                    LanguageViewController *languageVC = [[LanguageViewController alloc] init];
                    [self.navigationController pushViewController:languageVC animated:YES];
                    [UMAnalyticsHelper event:home_dyy];
                }
                    break;
                case 4:
                {
                    SkinListViewController *skinVC = [[SkinListViewController alloc] init];
                    [self.navigationController pushViewController:skinVC animated:YES];
                    [UMAnalyticsHelper event:home_pfqh];
                }
                    break;
            }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    WXRWebViewController *contactVC = [[WXRWebViewController alloc] init];
                    contactVC.dataFrom = WXRWebViewControllerDataFromContactUs;
                    [self.navigationController pushViewController:contactVC animated:YES];
                    [UMAnalyticsHelper event:home_jgfq];
                }
                    break;
                case 1:
                {
                    AboutHuntViewController *aboutVC = [[AboutHuntViewController alloc] init];
                    [self.navigationController pushViewController:aboutVC animated:YES];
                    [UMAnalyticsHelper event:home_gyhz];
                }
                    break;
            }
        }
            break;
        case 2:
        {
            //清除缓存
            [self clearCache];
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(55);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return MidPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - clear
//获取缓存
-(void)getCacheSize{
    dispatch_queue_t queue = dispatch_queue_create("getCache", DISPATCH_QUEUE_SERIAL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(queue, ^{
            float tmpSize = [[SDImageCache sharedImageCache]getSize];
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_async(mainQueue, ^{
                NSArray *arr = self.dataArray[2];
                MineModel *model = arr[0];
                model.summary = [NSString stringWithFormat:@"%.2fM",tmpSize/1000.0/1000];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
            });
        });
        
    });
}

//清理缓存
-(void)clearCache{
    [EasyLoadingView showLoading];
    dispatch_queue_t queue = dispatch_queue_create("clearCache", DISPATCH_QUEUE_SERIAL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //图片缓存
        dispatch_async(queue, ^{
            
            [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_async(mainQueue, ^{
                    NSArray *arr = self.dataArray[2];
                    MineModel *model = arr[0];
                    model.summary = @"0.00M";
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
                    [EasyLoadingView hidenLoading];
                    [EasyTextView showText:CacheClearDone];
                });
            }];
        });
        
        //浏览器缓存
        dispatch_async(queue, ^{
            //清除cookies
            NSHTTPCookie *cookie;
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (cookie in [storage cookies]){
                [storage deleteCookie:cookie];
            }
            //清除UIWebView的缓存
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            NSURLCache * cache = [NSURLCache sharedURLCache];
            [cache removeAllCachedResponses];
            [cache setDiskCapacity:0];
            [cache setMemoryCapacity:0];
            
        });
    });
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, AdaptY(80))];
    
    WeakSelf(self);
    self.headerView.loginBlock = ^{
        
        if (weakself.user.session.ID.length == 0) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            BaseNavigationController *loginNav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
            [weakself presentViewController:loginNav animated:YES completion:nil];
        }else{
            UserInfoViewController *infoVC = [[UserInfoViewController alloc] init];
            [weakself.navigationController pushViewController:infoVC animated:YES];
        }
    };
    
    self.headerView.inviteBlock = ^{
        InviteCodeViewController *inviteVC = [[InviteCodeViewController alloc] init];
        [weakself.navigationController pushViewController:inviteVC animated:YES];
        [UMAnalyticsHelper event:home_wdyqm];
    };
}

#pragma mark - init
- (MineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[MineHeaderView alloc] init];
    }
    return _headerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = BackGroundColor;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
