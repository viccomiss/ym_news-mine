//
//  MessageViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/10.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = MessageCenter;
    [self createUI];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArray.count;
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [MessageCell messageCell:tableView];
    return cell;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(106);
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
