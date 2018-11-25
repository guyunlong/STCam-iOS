//
//  AddDeviceAPToStaController.m
//  STCam
//
//  Created by cc on 2018/10/23.
//  Copyright © 2018 South. All rights reserved.
//

#import "AddDeviceAPToStaController.h"
#import "PrefixHeader.h"
#import "DevListViewModel.h"
#import "SearchDeviceCell.h"
#import "AddDeviceApToStaNextController.h"
#import "WifiManager.h"
@interface AddDeviceAPToStaController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)UIAlertController  *joinAPAlertController;//提示加入ap网络
@property(nonatomic,strong)DevListViewModel *viewModel;
@property(nonatomic,strong)UILabel * titleLb;
@property(nonatomic,strong)UITableView * mTableView;
@end

@implementation AddDeviceAPToStaController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[WifiManager ssid] hasPrefix:@"IPCAM_AP"]) {
         [self presentViewController:self.joinAPAlertController animated:YES completion:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewModel =[DevListViewModel sharedDevListViewModel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshApDevList) name:AppDidBecomeActive object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf0f0f0"]];
    [self initNav];
    
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, kPadding, kScreenWidth, 25*kWidthCoefficient)];
    [_titleLb setTextAlignment:NSTextAlignmentCenter];
    [_titleLb setText:@"action_selectdevice".localizedString];
    [self.view addSubview:_titleLb];
    
    
    
    _mTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setBackgroundColor:[UIColor colorWithHexString:@"0xf0f0f0"]];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView;
    });
    [self.view addSubview:_mTableView];
    
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom).with.offset(kPadding/2);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
    }];
    
    
}
-(void)initNav{
    [self setTitle:@"action_add_ap_sta".localizedString];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 28, 28);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(0, 0, 80, 28);
    refreshButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    [refreshButton addTarget:self action:@selector(refreshApDevList) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTitle:@"action_refresh".localizedString forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
}
-(void)back{
    DevListViewModel * viewModel = [DevListViewModel sharedDevListViewModel];
    for (DeviceModel* model in viewModel.searchDeviceArray) {
        [model threadDisconnect];
    }
    [viewModel.searchDeviceArray removeAllObjects];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)refreshApDevList{
    [self showHudInView:self.view hint:@""];
    @weakify(self)
    [[[_viewModel racSearchDeviceinMainView:NO]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self)
         [self hideHud];
         if ([x integerValue] == 1) {
             [self.mTableView reloadData];
         }
         
     }];
}
-(void)gotoWifiSetting{
    NSString * urlString = @"App-Prefs:root=WIFI";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        }
    }
}
#pragma getter
-(UIAlertController*)joinAPAlertController{
    if (!_joinAPAlertController) {
        @weakify(self)
        _joinAPAlertController = [UIAlertController alertControllerWithTitle:@"string_Info_APToSTA".localizedString message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self gotoWifiSetting];
        }];
        
        [_joinAPAlertController addAction:cancelAction];
        [_joinAPAlertController addAction:okAction];
        
    }
    return _joinAPAlertController;
}

#pragma mark -
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_viewModel.searchDeviceArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SearchDeviceCell cellHeight];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchDeviceCell * cell = [SearchDeviceCell SearchDeviceCellWith:tableView indexPath:indexPath];
    
    [cell setModel:_viewModel.searchDeviceArray[indexPath.row]];
    [cell setFrame:CGRectMake(0, 0, kScreenWidth,[SearchDeviceCell cellHeight])];
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddDeviceApToStaNextController * ctl = [AddDeviceApToStaNextController new];
    [ctl setModel:_viewModel.searchDeviceArray[indexPath.row]];
    [self.navigationController pushViewController:ctl animated:YES];
}


@end
