//
//  InfomationListViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/11/19.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "InfomationListViewController.h"
#import "InfomationCell.h"
#import "InfomationDetailViewController.h"
#import "NewsListModel.h"

@interface InfomationListViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (nonatomic, strong) BaseTableView *tableView;
/* array */
@property (nonatomic, strong) NSMutableArray *dataArray;
/* model */
@property (nonatomic, strong) NewsListModel *model;

@end

@implementation InfomationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    [self setRefresh];
}

#pragma mark - request
-(void)setRefresh{
    [[SERefresh sharedSERefresh] normalModelRefresh:self.tableView refreshType:RefreshTypeDouble firstRefresh:YES timeLabHidden:YES stateLabHidden:YES dropDownBlock:^{
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_footer endRefreshing];
        [self loadData:@"" withLoadMore:NO];
    } upDropBlock:^{
        [self.tableView.mj_header endRefreshing];
        [self loadData:self.model.marker withLoadMore:YES];
    }];
}

-(void)loadData:(NSString *)marker withLoadMore:(BOOL)isMore{
    [NewsListModel usr_news_list:@{@"tag": self.tag, @"marker": marker.length == 0 ? @"" : marker, @"limit": @"10"} Success:^(NewsListModel *item) {
        
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
            
            if (self.dataArray.count == 0) {
                [self.noDataView showNoDataView:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT-NavbarH) type:NoTextType tagStr:@"" needReload:NO reloadBlock:nil];
                [self.tableView addSubview:self.noDataView];
            }else{
                self.noDataView.hidden = YES;
            }
        }
        
        //遍历已读
        NSArray *readArr = [New getNewsIds];
        for (NSString *newId in readArr) {
            for (New *new in self.dataArray) {
                if ([new.ID isEqualToString:newId]) {
                    new.selected = YES;
                }
            }
        }
        
        [self.tableView reloadData];
        
    } Failure:^(NSError *error) {
        
    }];
}


#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InfomationCell *cell = [InfomationCell infomationCell:tableView];
    New *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(110);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    New *model = self.dataArray[indexPath.row];
    model.selected = YES;
    InfomationDetailViewController *infoDetailVC = [[InfomationDetailViewController alloc] init];
    infoDetailVC.newsId = model.ID;
    [self.navigationController pushViewController:infoDetailVC animated:YES];
    [New saveNewsListIds:model.ID];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - init
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
