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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"title_main_dev_list".localizedString];
    [self initNav];
   
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initViewModel];
}
-(void)initNav{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"action_add".localizedString forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_add_nor"] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, - 36, 0, 36)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, -30)];
    

    
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
//            // 下拉刷新
//            @weakify(self)
//            tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//                //
//                [[_viewModel racGetMessgeList:false] subscribeNext:^(id x) {
//                    @strongify(self)
//                    [self.myTableView reloadData];
//                    [self.myTableView.mj_header endRefreshing];
//                }];
//            }];
//            // 设置自动切换透明度(在导航栏下面自动隐藏)
//            tableView.mj_header.automaticallyChangeAlpha = YES;
//            // 上拉刷新
//            tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//                [[_viewModel racGetMessgeList:true] subscribeNext:^(id x) {
//                    @strongify(self)
//                    [self.myTableView reloadData];
//                    [self.myTableView.mj_footer endRefreshing];
//                }];
//            }];
            tableView;
        });
    }
    [self.view addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
}

-(void)initViewModel{
   @weakify(self)
    if (_viewModel.visitorMode) {
        [[[_viewModel racSearchDevice]
         deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id x) {
            @strongify(self)
            if ([x integerValue] == 1) {
                [self.mTableView reloadData];
            }
        }];
    }
    else{
        
        [[_viewModel racGetDeviceList] subscribeNext:^(id x) {
            @strongify(self)
            if ([x integerValue] == 1) {
                [self.mTableView reloadData];
            }
        }];
    }
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
