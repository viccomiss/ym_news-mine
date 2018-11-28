//
//  CurrencyAssetsViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/18.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CurrencyAssetsViewController.h"
#import "CurrencyAssetsHeaderView.h"
#import "CurrencyAssetsCell.h"
#import "CurrencyAssetsTableHeaderView.h"
#import "AddTradeRecordViewController.h"
#import "CurrencyTradeRecordViewController.h"
#import "AssetModel.h"

#define WEIGHTHEIGHT AdaptY(40)
#define CONTENTHEADERHEIGHT AdaptY(301) + StatusBarH + WEIGHTHEIGHT
#define HEADERHEIGHT AdaptY(258) + StatusBarH  //AdaptY(301) + StatusBarH

@interface CurrencyAssetsViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

/* tableView */
@property (nonatomic, strong) BaseTableView *tableView;
/* header */
@property (nonatomic, strong) CurrencyAssetsHeaderView *headerView;
/* dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;
/* table header */
@property (nonatomic, strong) CurrencyAssetsTableHeaderView *tableHeaderView;
/* scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/* AssetModel */
@property (nonatomic, strong) AssetModel *model;

@end

@implementation CurrencyAssetsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = MineCurrentAssets;
//    self.rightImg = @"search_nav_white";
    [self createUI];
}

#pragma mark - request
- (void)loadData{
    
    [EasyLoadingView showLoading];
    [AssetModel asset_assets:@{} Success:^(AssetModel *item) {
        
        self.model = item;
        self.headerView.allAsset = item.overall;
        CGFloat height = AdaptY(126) * item.assets.count + HEADERHEIGHT;
        self.scrollView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, height < MAINSCREEN_HEIGHT + HEADERHEIGHT - 2 * NavbarH ? MAINSCREEN_HEIGHT + HEADERHEIGHT - 2 * NavbarH : height);
        [self.tableView reloadData];
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.assets.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CurrencyAssetsCell *cell = [CurrencyAssetsCell currencyAssetsCell:tableView];
    cell.model = self.model.assets[indexPath.section];
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Asset *model = self.model.assets[indexPath.section];
    CurrencyTradeRecordViewController *recordVC = [[CurrencyTradeRecordViewController alloc] init];
    recordVC.assetId = model.ID;
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(111);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptY(15);
}

#pragma mark - scrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        //切换导航条
        CGFloat offsetY = scrollView.contentOffset.y;
               
        //悬停
        if (offsetY <= 0) {

            [self.view bringSubviewToFront:self.headerView];
        }
        
        if(offsetY <= HEADERHEIGHT && offsetY > 0) {
            
            [self.view bringSubviewToFront:self.scrollView];
        }
        CGFloat alpha = (HEADERHEIGHT - NavbarH - offsetY) / (HEADERHEIGHT - NavbarH);
        [self.headerView changeAlpha:alpha];
    }
}

#pragma mark - UI
- (void)createUI{
    
    WeakSelf(self);
    
    [self.view addSubview:self.scrollView];
//    [self.scrollView addSubview:self.tableHeaderView];
    [self.scrollView addSubview:self.tableView];
    
    [self.view addSubview:self.headerView];
    self.headerView.addBlock = ^{
        AddTradeRecordViewController *addVC = [[AddTradeRecordViewController alloc] init];
        [weakself.navigationController pushViewController:addVC animated:YES];
    };
    
}

#pragma mark - init
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, HEADERHEIGHT - NavbarH, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = BackGroundColor;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavbarH, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - NavbarH)];
//        _scrollView.backgroundColor = BackGroundColor;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (CurrencyAssetsHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[CurrencyAssetsHeaderView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, HEADERHEIGHT)];
    }
    return _headerView;
}

- (CurrencyAssetsTableHeaderView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[CurrencyAssetsTableHeaderView alloc] initWithFrame:CGRectMake(0, HEADERHEIGHT - NavbarH, MAINSCREEN_WIDTH, WEIGHTHEIGHT)];
    }
    return _tableHeaderView;
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
