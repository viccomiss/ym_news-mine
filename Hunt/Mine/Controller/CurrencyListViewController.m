//
//  CurrencyListViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/6.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "CurrencyListViewController.h"
#import "SelectBoxCell.h"
#import "SelectBoxModel.h"
#import "UserModel.h"
#import "SEUserDefaults.h"
#import "CurrencyHelper.h"

@interface CurrencyListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/* user */
@property (nonatomic, strong) UserModel *user;

@end

@implementation CurrencyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = CurrencyShow;
    [self createUI];
    [self setData];
}

- (void)setData{
    
    for (int i = 0; i < [CurrencyHelper currenciesNameArr].count; i++) {
        SelectBoxModel *m = [[SelectBoxModel alloc] init];
        m.name = [NSString stringWithFormat:@"%@(%@)",[CurrencyHelper currenciesNameArr][i],[CurrencyHelper currencies][i]];
        if ([[CurrencyHelper currentCurrency] isEqualToString:[CurrencyHelper currencies][i]]) {
            m.selected = YES;
        }
        [self.dataArray addObject:m];
    }
    [self.tableView reloadData];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectBoxCell *cell = [SelectBoxCell selectBoxCell:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectBoxModel *model = self.dataArray[indexPath.row];
    for (SelectBoxModel *m in self.dataArray) {
        if ([m.name isEqualToString:model.name]) {
            m.selected = YES;
        }else{
            m.selected = NO;
        }
    }
    [self.tableView reloadData];
    
//    [EasyLoadingView showLoading];
//    [UserModel usr_setting_update:@{@"key" : @"currency", @"value": [CurrencyHelper currencies][indexPath.row]} Success:^(NSString *code) {
//
//        if ([code isEqualToString:@"0"]) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [EasyTextView showText:EditSuccess];
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        }
//
//    } Failure:^(NSError *error) {
//
//    }];
    [CurrencyHelper setCurrency:[CurrencyHelper currencies][indexPath.row]];
    switch (indexPath.row) {
        case 0:
            [UMAnalyticsHelper event:home_pfqh_yyl];
            break;
        case 1:
            [UMAnalyticsHelper event:home_pfqh_hlc];
            break;
            
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(50);
}


#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
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
