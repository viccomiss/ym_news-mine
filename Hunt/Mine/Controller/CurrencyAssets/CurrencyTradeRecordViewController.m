//
//  CurrencyTradeRecordViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/22.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CurrencyTradeRecordViewController.h"
#import "CurrencyTradeRecordHeaderView.h"
#import "CurrencyTradeRecordSectionHeaderView.h"
#import "CurrencyTradeRecordCell.h"
#import "AddTradeRecordViewController.h"
#import "AssetDetailModel.h"

static NSString *sectionHeaderId = @"sectionHeaderId";

@interface CurrencyTradeRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

/* table */
@property (nonatomic, strong) BaseTableView *tableView;
/* dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;
/* header */
@property (nonatomic, strong) CurrencyTradeRecordHeaderView *headerView;
/* TransactionsModel */
@property (nonatomic, strong) TransactionsModel *model;
/* asset */
@property (nonatomic, strong) AssetDetailModel *assetDetailModel;

@end

@implementation CurrencyTradeRecordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    [self setRefresh];
}

#pragma mark - action
- (void)delTouch{
    
    [EasyAlertView alertViewWithPart:^EasyAlertPart *{
        return [EasyAlertPart shared].setTitle(@"").setSubtitle(ConfirmDelet).setAlertType(AlertViewTypeAlert) ;
    } config:^EasyAlertConfig *{
        return [EasyAlertConfig shared].settwoItemHorizontal(YES).setAnimationType(AlertAnimationTypeFade).setTintColor(WhiteTextColor).setBgViewEvent(NO).setSubtitleTextAligment(NSTextAlignmentCenter).setEffectType(AlertBgEffectTypeAlphaCover) ;
    } buttonArray:^NSArray<NSString *> *{
        return @[Cancel,Confirm] ;
    } callback:^(EasyAlertView *showview , long index) {
        if (index) {
            [Asset remove_asset:@{@"assetId" : self.assetId} Success:^(NSString *item) {
                
                if ([item isEqualToString:@"0"]) {
                    [EasyTextView showText:DelSuccess];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } Failure:^(NSError *error) {
                
            }];
        }
    }];
}

#pragma mark - request
- (void)loadData{
    
    [EasyLoadingView showLoading];
    [AssetDetailModel asset_asset:@{@"assetId" : self.assetId} Success:^(AssetDetailModel *item) {
        
        self.title = [NSString stringWithFormat:@"%@(%@)",item.asset.coin.name,item.asset.coin.ID];
        self.assetDetailModel = item;
        self.headerView.asset = item.asset;
        self.model = item.transactions;
        self.dataArray = [NSMutableArray arrayWithArray:self.model.list];
        [self.tableView reloadData];
        if (!self.model.hasMore) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
    } Failure:^(NSError *error) {
        
    }];
}

-(void)setRefresh{
    [[SERefresh sharedSERefresh] normalModelRefresh:self.tableView refreshType:RefreshTypeUpDrop firstRefresh:NO timeLabHidden:YES stateLabHidden:YES dropDownBlock:^{
      
    } upDropBlock:^{
        [self.tableView.mj_header endRefreshing];
        [self loadData:self.model.marker withLoadMore:YES];
    }];
}

-(void)loadData:(NSString *)marker withLoadMore:(BOOL)isMore{
    [TransactionsModel asset_transactions:@{@"assetId" : self.assetId,@"marker": marker.length == 0 ? @"" : marker, @"limit": @"10"} Success:^(TransactionsModel *item) {
        
        self.model = item;
        if (!self.model.hasMore) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        if (isMore) {
            [self.dataArray addObjectsFromArray:item.list];
        }else{
            [self.tableView.mj_header endRefreshing];
            self.dataArray = [NSMutableArray arrayWithArray:item.list];
        }
        
        [self.tableView reloadData];
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Transaction *model = self.dataArray[indexPath.section];
    model.coinId = self.assetDetailModel.asset.coin.symbol;
    model.assetPrice = self.assetDetailModel.asset.price;
    CurrencyTradeRecordCell *cell = [CurrencyTradeRecordCell currencyTradeRecordCell:tableView];
    cell.model = model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CurrencyTradeRecordSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeaderId];
    if (!header) {
        header = [[CurrencyTradeRecordSectionHeaderView alloc] initWithReuseIdentifier:sectionHeaderId];
    }
    Transaction *model = self.dataArray[section];
    header.model = model;
    return header;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(168);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptY(45);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Transaction *model = self.dataArray[indexPath.section];
    AddTradeRecordViewController *addVC = [[AddTradeRecordViewController alloc] init];
    addVC.transaction = model;
    addVC.asset = @{@"asset" : @{@"id" : self.assetDetailModel.asset.ID}};
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - UI
- (void)createUI{
    
    UIBarButtonItem *delItem = [[UIBarButtonItem alloc] initWithImage:[ImageName(@"nav_delect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(delTouch)];
    self.navigationItem.rightBarButtonItem = delItem;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    WeakSelf(self);
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.addBlock = ^{
        AddTradeRecordViewController *addVC = [[AddTradeRecordViewController alloc] init];
        addVC.coinId = weakself.assetDetailModel.asset.coin.ID;
        addVC.asset = @{@"asset" : @{@"id" : weakself.assetDetailModel.asset.ID}};
        [weakself.navigationController pushViewController:addVC animated:YES];
    };
}

#pragma mark - init
- (BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[CurrencyTradeRecordSectionHeaderView class] forHeaderFooterViewReuseIdentifier:sectionHeaderId];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (CurrencyTradeRecordHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[CurrencyTradeRecordHeaderView alloc] init];
    }
    return _headerView;
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
