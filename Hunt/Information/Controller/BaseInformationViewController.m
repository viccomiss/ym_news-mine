//
//  BaseInformationViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/11/19.
//  Copyright © 2018 congzhi. All rights reserved.
//

#import "BaseInformationViewController.h"
#import "InformationViewController.h"
#import "FlashViewController.h"

@interface BaseInformationViewController ()<UIScrollViewDelegate>

/* seg */
@property (nonatomic, strong) UISegmentedControl *segControl;
/* scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation BaseInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self reloadNavigationBar:YES];
    [self createUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - action
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender{
    
    NSInteger selecIndex = sender.selectedSegmentIndex;
    switch(selecIndex){
        case 0:
            sender.selectedSegmentIndex=0;
            [self.scrollView setContentOffset:CGPointMake(0 , 0) animated:YES];
            
            
            break;
            
        case 1:
            sender.selectedSegmentIndex = 1;
            [self.scrollView setContentOffset:CGPointMake(MAINSCREEN_WIDTH , 0) animated:YES];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - UI
- (void)createUI{
    
    self.segControl = [[UISegmentedControl alloc] initWithItems:@[Infomation,Flash]];
    self.segControl.frame = CGRectMake(0, 0, AdaptX(120), AdaptY(28));
    self.segControl.selectedSegmentIndex = 0;
    [self.segControl py_addToThemeColorPool:@"tintColor"];
    [self.segControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:self.segControl];
    
    [self.view addSubview:self.scrollView];
    
    InformationViewController *infomationVC = [[InformationViewController alloc] init];
    [self addChildViewController:infomationVC];
    [self.scrollView addSubview:infomationVC.view];
    
    FlashViewController *flashVC = [[FlashViewController alloc] init];
    [self addChildViewController:flashVC];
    flashVC.view.frame = CGRectMake(MAINSCREEN_WIDTH, self.view.easy_y, MAINSCREEN_WIDTH, self.view.easy_height);
    [self.scrollView addSubview:flashVC.view];
    
}

#pragma mark - init
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(2 * MAINSCREEN_WIDTH, _scrollView.easy_height);
    }
    return _scrollView;
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
