//
//  AddTradeRecordViewController.m
//  Hunt
//
//  Created by 杨明 on 2018/8/21.
//  Copyright © 2018年 congzhi. All rights reserved.
//

#import "AddTradeRecordViewController.h"
#import "TopTagBottomFieldCell.h"
#import "LeftRightChooseCell.h"
#import "TitleAndTextViewCell.h"
#import "CurrencyHelper.h"
#import "DateManager.h"

@interface AddTradeRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

/* table */
@property (nonatomic, strong) BaseTableView *tableView;
/* header */
@property (nonatomic, strong) BaseView *headerView;
/* buy */
@property (nonatomic, strong) BaseButton *buyBtn;
/* sale */
@property (nonatomic, strong) BaseButton *saleBtn;

@end

@implementation AddTradeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = AddCurrencyRecord;
    [self createUI];
}

#pragma mark - action
- (void)buyTouch:(BaseButton *)sender{
    if (sender.selected) {
        return;
    }
    if (self.transaction.ID.length != 0) {
        //编辑状态不能更改 买 卖
        return;
    }
    [self chooseBuy];
    
    self.transaction.type = TransactionBuyType;
    
    [self.tableView reloadData];
}

- (void)chooseBuy{
    self.saleBtn.selected = NO;
    self.buyBtn.selected = YES;
    
    ViewBorderRadius(self.buyBtn, AdaptX(5), 1, BackGreenColor);
    self.buyBtn.backgroundColor = [BackGreenColor colorWithAlphaComponent:0.1];
    ViewBorderRadius(self.saleBtn, AdaptX(5), 0, [UIColor clearColor]);
    self.saleBtn.backgroundColor = BackGroundColor;
}

- (void)saleTouch:(BaseButton *)sender{
    if (sender.selected) {
        return;
    }
    
    if (self.transaction.ID.length != 0) {
        //编辑状态不能更改 买 卖
        return;
    }
    
    [self chooseSale];
    
    self.transaction.type = TransactionSaleType;
    
    [self.tableView reloadData];
}

- (void)chooseSale{
    self.buyBtn.selected = NO;
    self.saleBtn.selected = YES;
    
    ViewBorderRadius(self.buyBtn, AdaptX(5), 0, [UIColor clearColor]);
    self.buyBtn.backgroundColor = BackGroundColor;
    ViewBorderRadius(self.saleBtn, AdaptX(5), 1, BackRedColor);
    self.saleBtn.backgroundColor = [BackRedColor colorWithAlphaComponent:0.1];
}

- (void)saveTouch{
    
    if (self.transaction.coinId.length == 0) {
        [EasyTextView showText:ChooseCurrency];
        return;
    }
    
    if ([self.transaction.price doubleValue]<= 0) {
        [EasyTextView showText:self.buyBtn.selected ? PleaseEnterBuyPrice : PleaseEnterSellPrice];
        return;
    }
    
    if (self.transaction.time == 0) {
        [EasyTextView showText:PleaseSelectTime];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.transaction.coinId forKey:@"coinId"];
    [param setObject:[NSNumber numberWithInteger:self.transaction.quantity] forKey:@"quantity"];
    [param setObject:[NSNumber numberWithUnsignedInteger:self.transaction.type] forKey:@"type"];
    if (self.transaction.unitOrTotal == TransactionUnitType) {
        [param setObject:self.transaction.price forKey:@"price"];
    }else{
        [param setObject:[NSString stringWithFormat:@"%.f",self.transaction.totalPrice / self.transaction.quantity] forKey:@"price"];
    }
    [param setObject:[NSNumber numberWithInteger:self.transaction.time] forKey:@"time"];
    [param setObject:self.transaction.priceCurrency forKey:@"priceCurrency"];
    if (self.transaction.ID.length != 0) {
        //编辑
        [param setObject:self.transaction.ID forKey:@"id"];
    }
    if (self.transaction.exchange && self.transaction.isExchange) {
        [param setObject:[self.transaction.exchange mj_keyValues] forKey:@"exchange"];
    }
    if (!self.transaction.isExchange) {
        [param setObject:self.transaction.walletAddr.length == 0 ? @"" : self.transaction.walletAddr  forKey:@"walletAddr"];
    }
    if (self.transaction.notes.length != 0) {
        [param setObject:self.transaction.notes forKey:@"notes"];
    }
    if (self.asset != nil) {
        //关联资产ID
        [param setObject:self.asset forKey:@"asset"];
    }
    
    [EasyLoadingView showLoading];
    [Transaction asset_save_transaction:@{@"transaction" : [param mj_JSONString]} Success:^(NSString *code) {
        
        if ([code isEqualToString:@"0"]) {
            [EasyTextView showText:SaveSuccess];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } Failure:^(NSError *error) {
        
    }];
}

- (void)delTouch{
    [EasyAlertView alertViewWithPart:^EasyAlertPart *{
        return [EasyAlertPart shared].setTitle(@"").setSubtitle(ConfirmDelet).setAlertType(AlertViewTypeAlert) ;
    } config:^EasyAlertConfig *{
        return [EasyAlertConfig shared].settwoItemHorizontal(YES).setAnimationType(AlertAnimationTypeFade).setTintColor(WhiteTextColor).setBgViewEvent(NO).setSubtitleTextAligment(NSTextAlignmentCenter).setEffectType(AlertBgEffectTypeAlphaCover) ;
    } buttonArray:^NSArray<NSString *> *{
        return @[Cancel,Confirm] ;
    } callback:^(EasyAlertView *showview , long index) {
        if (index) {
            [Transaction asset_remove_transaction:@{@"transactionId" : self.transaction.ID} Success:^(NSString *item) {
                
                if ([item isEqualToString:@"0"]) {
                    [EasyTextView showText:DelSuccess];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } Failure:^(NSError *error) {
                
            }];
        }
    }];
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(self);
    switch (indexPath.section) {
        case 0:
        {
            TopTagBottomFieldCell *cell = [TopTagBottomFieldCell topTagBottomFieldCell:tableView cellId:[NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row]];
            switch (indexPath.row) {
                case 0:
                {
                    cell.tagStr = ChooseCoin;
                    cell.placeholder = ChooseCurrency;
                    cell.disField = YES;
                    cell.coinModel = self.transaction;
                }
                    break;
                case 1:
                {
                    cell.tagStr = Quantity;
                    cell.placeholder = PleaseEnterQuantity;
                    cell.hideArrow = YES;
                    cell.quantutyModel = self.transaction;
                    cell.keyboardType = UIKeyboardTypeDecimalPad;
                }
                    break;
                case 2:
                {
                    cell.tagStr = self.buyBtn.selected ? [NSString stringWithFormat:@"%@(%@)",BuyPricePerUnit,PerUnit] : [NSString stringWithFormat:@"%@(%@)",SellPricePerUnit,PerUnit];
                    cell.placeholder = self.buyBtn.selected ? PleaseEnterBuyPrice : PleaseEnterSellPrice;
                    cell.showWeight = YES;
                    cell.keyboardType = UIKeyboardTypeDecimalPad;
                    cell.priceModel = self.transaction;
                    cell.totalPriceModel = self.transaction;
                    cell.weight1Tag = self.transaction.priceCurrency;
                    WeakSelf(cell);
                    cell.weightBlock = ^(NSInteger tag) {
                        if (tag == 1) {
                            //单位
                            EasyAlertView *alertV = [EasyAlertView alertViewWithTitle:nil subtitle:Choose AlertViewType:AlertViewTypeSystemActionSheet config:nil];
                            [alertV addAlertItem:^EasyAlertItem *{
                                return [EasyAlertItem itemWithTitle:Cancel type:AlertItemTypeSystemCancel callback:nil];
                            }];
                            for (NSString *cur in [CurrencyHelper currencies]) {
                                [alertV addAlertItemWithTitle:cur type:AlertItemTypeSystemDefault callback:^(EasyAlertView *showview, long index) {
                                    weakself.transaction.priceCurrency = [CurrencyHelper currencies][index - 1];
                                    weakcell.weight1Tag = [CurrencyHelper currencies][index - 1];
                                }];
                            }
                            
                            [alertV showAlertView];
                        }else{
                            //单价
                            EasyAlertView *alertV = [EasyAlertView alertViewWithTitle:nil subtitle:Choose AlertViewType:AlertViewTypeSystemActionSheet config:nil];
                            [alertV addAlertItem:^EasyAlertItem *{
                                return [EasyAlertItem itemWithTitle:Cancel type:AlertItemTypeSystemCancel callback:nil];
                            }];
                            [alertV addAlertItemWithTitle:PerUnit type:AlertItemTypeSystemDefault callback:^(EasyAlertView *showview, long index) {
                                weakself.transaction.unitOrTotal = TransactionUnitType;
                                weakcell.priceModel = weakself.transaction;
                                weakcell.weight2Tag = PerUnit;
                                weakcell.tagStr = weakself.buyBtn.selected ? [NSString stringWithFormat:@"%@(%@)",BuyPricePerUnit,PerUnit] : [NSString stringWithFormat:@"%@(%@)",SellPricePerUnit,PerUnit];

                            }];
                            [alertV addAlertItemWithTitle:TotalUnit type:AlertItemTypeSystemDefault callback:^(EasyAlertView *showview, long index) {
                                weakself.transaction.unitOrTotal = TransactionTotalType;
                                if (weakself.transaction.price.length != 0) {
                                    weakself.transaction.totalPrice = [weakself.transaction.price doubleValue];
                                }
                                weakcell.weight2Tag = TotalUnit;
                                weakcell.tagStr = weakself.buyBtn.selected ? [NSString stringWithFormat:@"%@(%@)",BuyPricePerUnit,TotalUnit] : [NSString stringWithFormat:@"%@(%@)",SellPricePerUnit,TotalUnit];
                            }];
                            
                            [alertV showAlertView];
                        }
                    };
                }
                    break;
                case 3:
                {
                    cell.tagStr = Time;
                    cell.placeholder = PleaseSelectTime;
                    cell.timeField = YES;
                    cell.timeModel = self.transaction;
                }
                    break;
            }
            return cell;
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    LeftRightChooseCell *cell = [LeftRightChooseCell typeChooseCell:tableView cellID:[NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row] leftStr:Exchange rightStr:Wallet];
                    cell.exchangeModel = self.transaction;
                    cell.buttonTouch = ^(NSInteger tag) {
                        weakself.transaction.isExchange = tag == 1 ? YES : NO;
                        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                    };
                    return cell;
                }
                    break;
                case 1:
                {
                    TopTagBottomFieldCell *cell = [TopTagBottomFieldCell topTagBottomFieldCell:tableView cellId:[NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row]];
                    if (self.transaction.isExchange) {
                        cell.tagStr = PickExchange;
                        cell.disField = YES;
                        cell.placeholder = PleaseChooseExchange;
                        cell.hideArrow = NO;
                        cell.exchangeModel = self.transaction;

                    }else{
                        //钱包
                        cell.tagStr = Wallet;
                        cell.disField = NO;
                        cell.placeholder = PleaseCopyWalletAdress;
                        cell.hideArrow = YES;
                        cell.walletModel = self.transaction;
                        
                    }
                    return cell;
                }
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    TitleAndTextViewCell *cell = [TitleAndTextViewCell titleAndTextViewCell:tableView cellID:[NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row]];
                    cell.placeholder = OptionalLimited200Characters;
                    cell.notesModel = self.transaction;
                    return cell;
                }
                    break;
            }
        }
            break;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BaseView *header = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, AdaptY(34))];
    header.backgroundColor = BackGroundColor;
    BaseLabel *tag = [SEFactory labelWithText:[self headerStr][section] frame:CGRectZero textFont:Font(12) textColor:TextDarkGrayColor textAlignment:NSTextAlignmentLeft];
    [header addSubview:tag];
    [tag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(header.mas_left).offset(AdaptX(15));
        make.centerY.mas_equalTo(header.mas_centerY);
    }];
    return header;
}

- (NSArray *)headerStr{
    return @[CurrencyInfo, self.buyBtn.selected ? StoreIn : CurrencyForm, Remark];
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return AdaptY(100);
    }
    return AdaptY(51);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptY(34);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(self);
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if (self.transaction.ID.length != 0 || self.asset) {
                        return;
                    }
                }
                    break;
  
            }
        }
            break;
            
        case 1:
        {
            switch (indexPath.row) {
                case 1:
                {
                    if (self.transaction.isExchange) {
                        
                    }
                }
                    break;
            }
        }
            break;
    }
}

#pragma mark - UI
- (void)createUI{
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:Save style:UIBarButtonItemStylePlain target:self action:@selector(saveTouch)];
    
    if (self.transaction) {
       UIBarButtonItem *delItem = [[UIBarButtonItem alloc] initWithImage:[ImageName(@"nav_delect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(delTouch)];
        self.navigationItem.rightBarButtonItems = @[saveItem, delItem];
    }else{
        self.navigationItem.rightBarButtonItem = saveItem;
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(NavbarH);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:self.buyBtn];
    [self.headerView addSubview:self.saleBtn];

    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView.mas_left).offset(AdaptX(15));
        make.centerY.mas_equalTo(self.headerView.mas_centerY);
        make.height.equalTo(@(AdaptY(35)));
    }];
    
    [self.saleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.buyBtn.mas_right).offset(AdaptX(15));
        make.right.mas_equalTo(self.headerView.mas_right).offset(-AdaptX(15));
        make.centerY.height.mas_equalTo(self.buyBtn);
        make.width.mas_equalTo(self.buyBtn.mas_width);
    }];
    
    if (self.transaction == nil) {
        self.transaction = [[Transaction alloc] init];
        self.transaction.quantity = 1;
        self.transaction.isExchange = YES;
        self.transaction.time = [[DateManager nowTimeStampString] integerValue];
        self.transaction.priceCurrency = [CurrencyHelper currentCurrency];
        self.transaction.type = TransactionBuyType;
        self.transaction.coinId = self.coinId;
    }else{
        self.transaction.type == TransactionBuyType ? [self chooseBuy] : [self chooseSale];
        if (self.transaction.exchange || (!self.transaction.exchange && self.transaction.walletAddr.length == 0)) {
            self.transaction.isExchange = YES;
        }
    }
}

#pragma mark - init
- (BaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (BaseView *)headerView{
    if (!_headerView) {
        _headerView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, AdaptY(60))];
        _headerView.backgroundColor = WhiteTextColor;
    }
    return _headerView;
}

- (BaseButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [SEFactory buttonWithTitle:CurrencyBuy image:nil frame:CGRectZero font:Font(16) fontColor:LightTextGrayColor];
        [_buyBtn setTitleColor:BackGreenColor forState:UIControlStateSelected];
        _buyBtn.selected = YES;
        ViewBorderRadius(_buyBtn, AdaptX(5), 1, BackGreenColor);
        _buyBtn.backgroundColor = [BackGreenColor colorWithAlphaComponent:0.1];
        [_buyBtn addTarget:self action:@selector(buyTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}

- (BaseButton *)saleBtn{
    if (!_saleBtn) {
        _saleBtn = [SEFactory buttonWithTitle:CurrencySale image:nil frame:CGRectZero font:Font(16) fontColor:LightTextGrayColor];
        [_saleBtn setTitleColor:BackRedColor forState:UIControlStateSelected];
        _saleBtn.backgroundColor = BackGroundColor;
        [_saleBtn addTarget:self action:@selector(saleTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saleBtn;
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
