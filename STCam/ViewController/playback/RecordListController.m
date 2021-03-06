//
//  RecordListController.m
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "RecordListController.h"
#import "PrefixHeader.h"
#import "MJRefresh.h"
#import "RecordListCell.h"
#import "PlayBackController.h"
#import "CoreDataManager.h"
@interface RecordListController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)UITableView * mTableView;
@end

@implementation RecordListController

-(void)viewWillAppear:(BOOL)animated{
    if ([_viewModel.recordFileArray count] == 0) {
        [self getRecordFileList:NO];
    }
    else{
        [self.mTableView reloadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNav];
    
    if (!_mTableView) {
        _mTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView setUserInteractionEnabled:true];
            tableView.dataSource = self;
            tableView.delegate = self;
            // 下拉刷新
            @weakify(self)
            tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                //
                @strongify(self)
                [self getRecordFileList:NO];
            }];
            // 上拉刷新
            tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
               @strongify(self)
                [self getRecordFileList:YES];
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

-(void)getRecordFileList:(BOOL)loadMore{
    @weakify(self)
    [[[self.viewModel racGetRecordFileList:loadMore]
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(id x) {
            @strongify(self)
            [self.mTableView.mj_header endRefreshing];
            [self.mTableView.mj_footer endRefreshing];
            [self.mTableView reloadData];
        }
     ];
}
-(void)initNav{
    [self setTitle:@"string_record_list".localizedString];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 28, 28);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.recordFileArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordListCell * cell = [RecordListCell RecordListCellWith:tableView indexPath:indexPath];
    [cell setModel:_viewModel.recordFileArray[indexPath.row]];
    [cell setFrame:CGRectMake(0, 0, kScreenWidth,[RecordListCell cellHeight] )];
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RecordListCell cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![_viewModel.model IsConnect]) {
        [self showHint:@"string_ConnectFail".localizedString];
        return;
    }
    
    PlayBackController * ctl = [PlayBackController new];
    PlayBackViewModel * viewModel = [PlayBackViewModel new];
    [viewModel setVideoModel:_viewModel.recordFileArray[indexPath.row]];
    [viewModel setDeviceModel:_viewModel.model];
    [[CoreDataManager sharedManager] saveSDVideo:_viewModel.recordFileArray[indexPath.row]];
    [ctl setViewModel:viewModel];
    [self.navigationController pushViewController:ctl animated:YES];
    
    
}

@end
