//
//  DevListViewController.m
//  STCam
//
//  Created by guyunlong on 8/27/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "DevListViewController.h"
#import "PrefixHeader.h"
#import "DevListViewModel.h"
#import "DevListCell.h"
#import <Masonry/Masonry.h>
#import "MASConstraint.h"
#import "LiveVidController.h"
#import "MJRefresh.h"
#import "DeviceSettingController.h"
#import "GenerateShareQRCodeController.h"
#import "AddDeviceController.h"
#import "AddDeviceApToStaNextController.h"
#import "RecordListController.h"
@interface DevListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong)UITableView * mTableView;
@end

@implementation DevListViewController
-(id)initWithViewModel:(DevListViewModel*)viewModel{
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshDeviceList:NO];
        [self monitorRefreshViewKVO];
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"title_main_dev_list".localizedString];
    [self initNav];
    
}

/**
 监听viewModel 中的refreshView变量
 */
-(void)monitorRefreshViewKVO{
   
    @weakify(self)
    [[[RACObserve(self.viewModel, refreshView) filter:^BOOL(id value) {
        return [value integerValue] != 0;
    }]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
        @strongify(self);
        [self.mTableView reloadData];
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.mTableView reloadData];
}
-(void)initNav{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if(_viewModel.userMode == TUserMode_Login){
        [btn setTitle:@"action_add".localizedString forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_add_nor"] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, - 36, 0, 36)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, -30)];
    }
    else if(_viewModel.userMode == TUserMode_Visitor){
         [btn setTitle:@"action_search".localizedString forState:UIControlStateNormal];
    }
    [btn addTarget:self action:@selector(navBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    

    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}
-(void)loadView{
    [super loadView];
    
    if (!_mTableView) {
        _mTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
           
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView setUserInteractionEnabled:true];
            tableView.dataSource = self;
            tableView.delegate = self;
            [tableView setBackgroundColor:[UIColor colorWithHexString:@"0xf7f7f7"]];
            // 下拉刷新
            @weakify(self)
            tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                //
                @strongify(self)
                [self refreshDeviceList:YES];
            }];
            // 设置自动切换透明度(在导航栏下面自动隐藏)
            tableView.mj_header.automaticallyChangeAlpha = YES;
           
            tableView;
        });
    }
    [self.view addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
}

-(void)refreshDeviceList:(BOOL)refresh{
    
   @weakify(self)
    if (_viewModel.userMode == TUserMode_Visitor) {
        [[[_viewModel racSearchDeviceinMainView:YES]
         deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id x) {
            @strongify(self)
            if ([x integerValue] == 1) {
                [self.mTableView reloadData];
            }
            if (refresh) {
                [self.mTableView.mj_header endRefreshing];
            }
        }];
    }
    else if (_viewModel.userMode == TUserMode_Login){
        
        [[_viewModel racGetDeviceList] subscribeNext:^(id x) {
            @strongify(self)
            if ([x integerValue] == 1) {
                [self.mTableView reloadData];
                
            }
            if (refresh) {
                [self.mTableView.mj_header endRefreshing];
            }
        }];
    }
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navBtnClicked{
    if(_viewModel.userMode == TUserMode_Login){
        AddDeviceController * ctl = [AddDeviceController new];
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if(_viewModel.userMode == TUserMode_Visitor){
        [self refreshDeviceList:NO];
    }
}
#pragma mark -
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_viewModel.deviceArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DevListCell * cell = [DevListCell DevListCellWith:tableView indexPath:indexPath];
    
    [cell setModel:_viewModel.deviceArray[indexPath.row]];
    
    @weakify(self)
    cell.btnClickBlock = ^(DeviceListBtnType type){
        
        @strongify(self)
        DeviceModel * blockModel = self.viewModel.deviceArray[indexPath.row];
        if (type != DeviceListBtnType_Setting) {
            if (![blockModel isOnline]) {
                [self showHint:@"device_status_offline".localizedString];
                return ;
            }
            else if(![blockModel IsConnect]){
                [self showHint:@"action_net_not_connect".localizedString];
                return;
            }
        }
        if(type == DeviceListBtnType_Setting){
            
            DeviceSettingController * ctl = [DeviceSettingController new];
            DeviceSettingViewModel * viewModel = [DeviceSettingViewModel new];
            [viewModel setModel:self.viewModel.deviceArray[indexPath.row]];
            [ctl setViewModel:viewModel];
            ctl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctl animated:YES];
        }
        else if(type == DeviceListBtnType_Share){
            
            GenerateShareQRCodeController * ctl = [GenerateShareQRCodeController new];
            [ctl setModel:self.viewModel.deviceArray[indexPath.row]];
            ctl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctl animated:YES];
        }
        else if(type == DeviceListBtnType_Playback){
            if (!blockModel.ExistSD) {
                [self showHint:@"action_not_exist_sd".localizedString];
                return;
            }
            RecordListController * ctl = [RecordListController new];
            RecordListViewModel * viewModel = [RecordListViewModel new];
            [viewModel setModel:blockModel];
            [ctl setViewModel:viewModel];
            ctl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctl animated:YES];
        }
    };
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DevListCell cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeviceModel * model = _viewModel.deviceArray[indexPath.row];
    if (![model isOnline]) {
        [self showHint:@"device_status_offline".localizedString];
        return ;
    }
    else if(![model IsConnect]){
        [self showHint:@"action_net_not_connect".localizedString];
        return;
    }
    
    
    LiveVidController * ctl = [LiveVidController new];
    LiveVidViewModel * viewModel = [LiveVidViewModel new];
    [viewModel setModel:model];
    ctl.hidesBottomBarWhenPushed = YES;
    [ctl setViewModel:viewModel];
    [self.navigationController pushViewController:ctl animated:YES];
   
}

@end
