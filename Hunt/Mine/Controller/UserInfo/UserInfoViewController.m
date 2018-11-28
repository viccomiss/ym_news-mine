//
//  UserInfoViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/7.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "UserInfoViewController.h"
#import "TitleAndFieldCell.h"
#import "TitleAndImageCell.h"
#import "TitleAndArrowCell.h"
#import "UserModel.h"
#import "EditNickViewController.h"
#import "EditPasswordViewController.h"
#import "WXRImagePicker.h"
#import "SEUserDefaults.h"
#import "UserModel.h"
#import "NSString+Regular.h"

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/* user */
@property (nonatomic, strong) UserModel *user;
/* logout */
@property (nonatomic, strong) BaseButton *logoutBtn;

@end

@implementation UserInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reloadUser];
}

- (void)reloadUser{
    self.user = [[SEUserDefaults shareInstance] getUserModel];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = UserInfo;
    [self createUI];
}

- (void)logout{
    
    [EasyAlertView alertViewWithPart:^EasyAlertPart *{
        return [EasyAlertPart shared].setTitle(@"").setSubtitle(LogoutAlert).setAlertType(AlertViewTypeAlert) ;
    } config:^EasyAlertConfig *{
        return [EasyAlertConfig shared].settwoItemHorizontal(YES).setAnimationType(AlertAnimationTypeFade).setTintColor(WhiteTextColor).setBgViewEvent(NO).setSubtitleTextAligment(NSTextAlignmentCenter).setEffectType(AlertBgEffectTypeAlphaCover) ;
    } buttonArray:^NSArray<NSString *> *{
        return @[Confirm,Cancel] ;
    } callback:^(EasyAlertView *showview , long index) {
        if (!index) {
            [EasyLoadingView showLoading];
            [APIManager loginFailureShowLogin:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [EasyLoadingView hidenLoading];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            TitleAndImageCell *cell = [TitleAndImageCell titleAndImageCellCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
            cell.title = Avatar;
            cell.imgSize = CGSizeMake(AdaptX(50), AdaptX(50));
            ViewRadius(cell.imgView, AdaptX(50) / 2);
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.user.user.avatar] placeholderImage:ImageName(@"avatar_default")];
            return cell;
        }
            break;
        case 1:
        {
            TitleAndArrowCell *cell = [TitleAndArrowCell titleAndArrowCellCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
            cell.title = NickName;
            cell.placeholder = InputNickName;
            cell.disableField = YES;
            cell.username = self.user;
            return cell;
        }
            break;
        case 2:
        {
            TitleAndFieldCell *cell = [TitleAndFieldCell titleAndFieldCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
            cell.title = Mobile;
            cell.placeholder = Mobile;
            cell.filed.text = [NSString phoneNumberDes:self.user.user.mobile];
            cell.filed.userInteractionEnabled = NO;
            return cell;
        }
            break;
//        case 3:
//        {
//            TitleAndArrowCell *cell = [TitleAndArrowCell titleAndArrowCellCell:tableView cellID:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
//            cell.title = EditPassword;
//            cell.disableField = YES;
//            return cell;
//        }
//            break;
    }
    return nil;
}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect cropperRect =  CGRectMake(0, (MAINSCREEN_HEIGHT - MAINSCREEN_WIDTH) / 2, MAINSCREEN_WIDTH, MAINSCREEN_WIDTH);
                [[WXRImagePicker shareImagePicker]showImagePickerWithCropable:YES cropFrame:cropperRect pickPath:PickImagePathPhotoAndCamera block:^(UIImage *editedImage,NSDictionary *info) {
                    NSData *data = UIImageJPEGRepresentation(editedImage, 0.6);
                    [UserModel updateHeaderImv:@{@"namespace": @"img", @"fileName": @"avatar",@"fileSize": [NSString stringWithFormat:@"%lu",(unsigned long)data.length]} imageData:data Success:^(id responeObject) {
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self reloadUser];
                        });
                        
                    } Failure:^(NSError *error) {
                        
                    }];
                }];
            });
            
        }
            break;
        case 1:
        {
            EditNickViewController *editVC = [[EditNickViewController alloc] init];
            [self.navigationController pushViewController:editVC animated:YES];
        }
            break;
        case 2:
            
            break;
        case 3:
        {
            EditPasswordViewController *passwordVC = [[EditPasswordViewController alloc] init];
            [self.navigationController pushViewController:passwordVC animated:YES];
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return AdaptY(80);
    }
    return AdaptY(45);
}


#pragma mark - UI
- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    self.tableView.tableFooterView = [self footerView];
}

- (BaseView *)footerView{
    BaseView *foot = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, AdaptY(60))];
    
    [foot addSubview:self.logoutBtn];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(foot);
        make.height.equalTo(@(AdaptY(45)));
    }];
    
    return foot;
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

- (BaseButton *)logoutBtn{
    if (!_logoutBtn) {
        _logoutBtn = [SEFactory buttonWithTitle:Logout frame:CGRectZero font:Font(15) fontColor:WhiteTextColor];
        _logoutBtn.backgroundColor = BackRedColor;
        [_logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutBtn;
}

#pragma mark - init


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
