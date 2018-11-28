//
//  BasePageViewController.m
//  SuperEducation
//
//  Created by JackyLiang on 2017/9/27.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "BasePageViewController.h"

#define kWMMenuViewHeight   44.0

@interface BasePageViewController ()


@end

@implementation BasePageViewController

- (instancetype)init {
    if (self = [super init]) {
        self.titleColorNormal = TextDarkGrayColor;
        [self py_addToThemeColorPool:@"titleColorSelected"];
        [self.menuView py_addToThemeColorPool:@"lineColor"];
        self.titleSizeSelected = 13 * FontSizeScale;
        self.titleSizeNormal = 13 * FontSizeScale;
        self.menuHeight = AdaptY(40);
        self.progressHeight = 2;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.automaticallyCalculatesItemWidths = YES;
        self.menuBGColor = WhiteTextColor;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self reloadNavigationBar:NO];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    if (self.addBottomLine) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self.menuView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.menuView);
            make.height.equalTo(@(0.5));
        }];
    }
    
    [SENotificationCenter addObserver:self selector:@selector(skinChange:) name:SKINCHANGESUCCESS object:nil];
}

- (void)skinChange:(NSNotification *)notification{
    UIColor *color = notification.object;
    
    self.titleColorSelected = color;
    self.menuView.lineColor = color;
    [self reloadData];
}

//添加logo nav
- (void)addLogoNavView{
    
    BaseImageView *logoView = [[BaseImageView alloc] initWithFrame:CGRectMake((MAINSCREEN_WIDTH - 139) / 2, (NavbarH - StatusBarH - 30) / 2, 139, 30)];
    logoView.image = ImageName(@"logo");
    [self.navigationBar addSubview:logoView];
}

- (void)backTouch{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
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
