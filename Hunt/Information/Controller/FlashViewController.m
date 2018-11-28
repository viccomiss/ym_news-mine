//
//  FlashViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/11/19.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "FlashViewController.h"
#import "FlashCell.h"
#import "FlashModel.h"
#import "FlashShareViewController.h"
#import "DateManager.h"
#import "FlashHeaderView.h"

static NSString *headerCellId = @"flashHeaderCellId";

@interface FlashViewController ()<UITableViewDelegate,UITableViewDataSource>

/* tableView */
@property (nonatomic, strong) BaseTableView *tableView;
/* array */
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *sortArray;

/* model */
@property (nonatomic, strong) FlashModel *model;
/* cellHightDict */
@property (nonatomic, strong) NSMutableDictionary *cellHightDict;

@end

@implementation FlashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self setRefresh];
}

- (void)reloadTheme:(NSNotification *)notification{
    [self.tableView reloadData];
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
    [FlashModel usr_news_flash_list:@{@"marker": marker.length == 0 ? @"" : marker, @"limit": @"10"} Success:^(FlashModel *item) {
        
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
        
        self.sortArray = [NSMutableArray arrayWithArray:[self arraySplitSubArrays:self.dataArray]];
        
        [self.tableView reloadData];
        
    } Failure:^(NSError *error) {
        
    }];
}

- (NSMutableArray *)arraySplitSubArrays:(NSArray *)array {
    // 数组去重,根据数组元素对象中time字段去重
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    for(flash *obj in array)
    {
        [dic setValue:obj forKey:[DateManager dateWithTimeIntervalSince1970:obj.publishDate format:@"yyyy-MM-dd"]];
    }
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSString *dictKey in dic) {
        [tempArr addObject:dictKey];
    }
    
    NSArray *sortedArray = [tempArr sortedArrayUsingSelector:@selector(compare:)];
    
    NSLog(@"排序后:%@",sortedArray);
    
    // 字典重不会有重复值,allKeys返回的是无序的数组
    NSLog(@"去重后字典:%@",[dic allKeys]);
    
    NSMutableArray *temps = [NSMutableArray array];
    
    for (NSString *dictKey in sortedArray) {
        
        NSMutableArray *subTemps = [NSMutableArray array];
        for (flash *obj in array) {
            
            if ([dictKey isEqualToString:[DateManager dateWithTimeIntervalSince1970:obj.publishDate format:@"yyyy-MM-dd"]]) {
                [subTemps addObject:obj];
            }
        }
        
        [temps addObject:subTemps];
    }
    
    
    // 排序后,元素倒序的,逆向遍历
    //    NSEnumerator *enumerator = [temps reverseObjectEnumerator];
    //    temps = (NSMutableArray*)[enumerator allObjects];
    
    NSMutableArray *groupArray = [NSMutableArray array];
    [sortedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *parm = [NSMutableDictionary dictionary];
        [parm setObject:obj forKey:@"time"];
        [parm setObject:temps[idx] forKey:@"flashArray"];
        
        FlashGroupModel *model = [FlashGroupModel mj_objectWithKeyValues:parm];
        [groupArray insertObject:model atIndex:0];
    }];
    
    NSLog(@"temps:%@",groupArray);
    return groupArray;
}


#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sortArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FlashGroupModel *group = self.sortArray[section];
    return group.flashArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FlashCell *cell = [FlashCell flashCell:tableView];
    FlashGroupModel *group = self.sortArray[indexPath.section];
    flash *model = group.flashArray[indexPath.row];
    cell.indexPath = indexPath;
    cell.model = model;
    WeakSelf(self);
    WeakSelf(cell);
    cell.contentBlock = ^(NSInteger tag){
        NSLog(@"container tag === %ld",tag);
        model.selected = !model.selected;
//        CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
//        CGRect myViewFrame = [tableView convertRect:frame toView:weakself.view];
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    };
    cell.shareBlock = ^{
        FlashShareViewController *shareVC = [[FlashShareViewController alloc] init];
        shareVC.model = model;
        [weakself.navigationController pushViewController:shareVC animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    FlashGroupModel *group = self.sortArray[indexPath.section];
//    flash *model = group.flashArray[indexPath.row];
//    NSString *cellName = model.ID;
//    [self.cellHightDict setObject:@(cell.frame.size.height) forKey:[NSString stringWithFormat:@"%@%ld",cellName, (long)indexPath.row]];
//}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    FlashGroupModel *group = self.sortArray[indexPath.section];
//    flash *model = group.flashArray[indexPath.row];
//    NSString *cellName = model.ID;
//    CGFloat height = [[self.cellHightDict objectForKey:[NSString stringWithFormat:@"%@%ld",cellName,  (long)indexPath.row]] floatValue];
//    if (height == 0) {
//        return AdaptY(200);
//    }
//    return height;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FlashHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerCellId];
    FlashGroupModel *group = self.sortArray[section];
    view.model = group.flashArray[0];
    return view;
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptY(35);
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-TabbarNSH - TabbarH);
    }];
}

#pragma mark - init
- (NSMutableDictionary *)cellHightDict{
    if (!_cellHightDict) {
        _cellHightDict = [NSMutableDictionary new];
    }
    return _cellHightDict;
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
        _tableView.estimatedRowHeight = AdaptY(200);
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = BackGroundColor;
        [_tableView registerClass:[FlashHeaderView class] forHeaderFooterViewReuseIdentifier:headerCellId];
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
