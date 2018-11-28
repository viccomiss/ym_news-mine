//
//  PhoneAreaCodeViewController.m
//  nuoee_krypto
//
//  Created by Mac on 2018/6/5.
//  Copyright © 2018年 nuoee. All rights reserved.
//

#import "PhoneAreaCodeViewController.h"
#import "MobileCountryModel.h"
#import "UITableView+SCIndexView.h"
#import "TitleAndFieldCell.h"

static NSString *cellId = @"areaCellId";

NSString *const CYPinyinGroupResultArray = @"CYPinyinGroupResultArray";

NSString *const CYPinyinGroupCharArray = @"CYPinyinGroupCharArray";

@interface PhoneAreaCodeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
/* sortArray */
@property (nonatomic, strong) NSMutableArray *sortArray;
/* nameArray */
@property (nonatomic, strong) NSMutableArray *nameArray;
/* resultArray */
@property (nonatomic, strong) NSArray *resultArray;

@end

@implementation PhoneAreaCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = CountryAndArea;
    [self createUI];
    [self loadData];
}

#pragma mark - request
- (void)loadData{
    
    [EasyLoadingView showLoading];
    [MobileCountryModel mobile_country:@{} Success:^(NSArray *list) {
        
        self.dataArray = [NSMutableArray arrayWithArray:list];
        for (MobileCountryModel *m in self.dataArray) {
            [self.nameArray addObject:m.name];
        }
        
        NSDictionary *dcit = [self sortObjectsAccordingToInitialWith:self.dataArray SortKey:@"name"];
        
        [self reloadTable:dcit];
        
    } Failure:^(NSError *error) {
        
    }];
}

- (void)reloadTable:(NSDictionary *)dcit{
    self.dataArray = [NSMutableArray arrayWithArray:dcit[CYPinyinGroupResultArray]];//排好顺序的PersonModel数组
    self.sortArray = [NSMutableArray arrayWithArray:dcit[CYPinyinGroupCharArray]];//排好顺序的首字母数组
    self.tableView.sc_indexViewDataSource = self.sortArray.copy;
    
    [self.tableView reloadData];
}

// 按首字母分组排序数组
-(NSDictionary *)sortObjectsAccordingToInitialWith:(NSArray *)willSortArr SortKey:(NSString *)sortkey {
    
    // 初始化UILocalizedIndexedCollation
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    NSLog(@"newSectionsArray %@ %@",newSectionsArray,collation.sectionTitles);
    
    NSMutableArray *firstChar = [NSMutableArray array];
    
    //将每个名字分到某个section下
    for (id Model in willSortArr) {
        //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [collation sectionForObject:Model collationStringSelector:NSSelectorFromString(sortkey)];
        
        //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:Model];
        
        //拿出每名字的首字母
        NSString * str= collation.sectionTitles[sectionNumber];
        [firstChar addObject:str];
        NSLog(@"sectionNumbersectionNumber %ld %@",sectionNumber,str);
    }
    
    //返回首字母排好序的数据
    NSArray *firstCharResult = [self SortFirstChar:firstChar];
    
    NSLog(@"firstCharResult== %@",firstCharResult);
    
    //对每个section中的数组按照name属性排序
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:NSSelectorFromString(sortkey)];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    
    //删除空的数组
    NSMutableArray *finalArr = [NSMutableArray new];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
            [finalArr addObject:newSectionsArray[index]];
        }
    }
    return @{CYPinyinGroupResultArray:finalArr,
             
             CYPinyinGroupCharArray:firstCharResult};
}

-(NSArray *)SortFirstChar:(NSArray *)firstChararry{
    
    //数组去重复
    
    NSMutableArray *noRepeat = [[NSMutableArray alloc]initWithCapacity:8];
    
    NSMutableSet *set = [[NSMutableSet alloc]initWithArray:firstChararry];
    
    [set enumerateObjectsUsingBlock:^(id obj , BOOL *stop){
        
        [noRepeat addObject:obj];
    }];
    
    //字母排序
    NSArray *resultkArrSort1 = [noRepeat sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //把”#“放在最后一位
    NSMutableArray *resultkArrSort2 = [[NSMutableArray alloc]initWithArray:resultkArrSort1];
    if ([resultkArrSort2 containsObject:@"#"]) {
        
        [resultkArrSort2 removeObject:@"#"];
        [resultkArrSort2 addObject:@"#"];
    }
    
    return resultkArrSort2;
}


#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rows = self.dataArray[section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TitleAndFieldCell *cell = [TitleAndFieldCell titleAndFieldCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
    NSArray *arr = self.dataArray[indexPath.section];
    MobileCountryModel *model = arr[indexPath.row];
    cell.title = model.name;
    cell.filed.text = model.code;
    cell.titleColor = MainTextColor;
    cell.titleFont = Font(14);
    cell.textColor = MainTextColor;
    cell.filed.font = Font(14);
    cell.filed.userInteractionEnabled = NO;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, AdaptY(40))];
    header.backgroundColor = BackGroundColor;
    
    BaseLabel *label = [SEFactory labelWithText:self.sortArray[section] frame:CGRectMake(MidPadding, 0, 120, AdaptY(40)) textFont:[UIFont boldSystemFontOfSize:20] textColor:MainTextColor textAlignment:NSTextAlignmentLeft];
    [header addSubview:label];
    return header;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.dataArray[indexPath.section];
    MobileCountryModel *model = arr[indexPath.row];
    if (self.areaBlock) {
        self.areaBlock(model.code,model.name);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptY(40);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptY(40);
}

#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
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
        _tableView.backgroundColor = WhiteTextColor;
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
