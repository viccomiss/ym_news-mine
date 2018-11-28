//
//  InformationViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/11/19.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "InformationViewController.h"
#import "InfomationListViewController.h"
#import "NewsTagModel.h"

@interface InformationViewController ()

/* dataArray */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self reloadNavigationBar:YES];
}

- (instancetype)init{
    if (self == [super init]) {
        
        [self loadTagsData];
    }
    return self;
}

#pragma mark - request
- (void)loadTagsData{
    
    [EasyLoadingView showLoading];
    [NewsTagModel usr_news_tags:@{} Success:^(NSArray * _Nonnull items) {
        
        self.dataArray = [NSMutableArray arrayWithArray:items];
        [self reloadData];
        
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - datasource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.dataArray.count;
}

- (NSInteger)numbersOfTitlesInMenuView:(WMMenuView *)menu{
    return self.dataArray.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    NewsTagModel *model = self.dataArray[index];
    InfomationListViewController *infoListVC = [[InfomationListViewController alloc] init];
    infoListVC.tag = model.tag;
    return infoListVC;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    NewsTagModel *model = self.dataArray[index];
    return model.name;
}

//当前所在控制器
- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    
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
