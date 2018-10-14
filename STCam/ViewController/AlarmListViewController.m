//
//  AlarmListViewController.m
//  STCam
//
//  Created by guyunlong on 8/27/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "AlarmListViewController.h"
#import "PrefixHeader.h"
#import "AlarmListViewModel.h"
#import "AlarmListCell.h"
#import "YBImageBrowser.h"
#import "MJRefresh.h"

@interface AlarmListViewController ()<UITableViewDataSource, UITableViewDelegate,YBImageBrowserDataSource>
@property(nonatomic,strong)AlarmListViewModel * viewModel;
@property(nonatomic,strong)UITableView * mTableView;
@property(nonatomic,strong)UIAlertController *deleteConfirmController; //删除确认框
@end

@implementation AlarmListViewController

-(void)loadView{
    [super loadView];
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
                [self getAlarmList:YES];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"action_alarm".localizedString];
    [self initNav];
    _viewModel = [AlarmListViewModel new];
    
    [self getAlarmList:NO];
    
}

-(void)getAlarmList:(BOOL)refresh{
    @weakify(self)
    [[_viewModel racGetAlarmList] subscribeNext:^(id x) {
        @strongify(self)
        if ([x integerValue] == 1) {
            [self.mTableView reloadData];
        }
        if (refresh) {
            [self.mTableView.mj_header endRefreshing];
        }
    }];
}

-(void)deleteAlarmList:(BOOL)all model:(AlarmImageModel*)model{
    @weakify(self);
    [[[[_viewModel racDeleteAlarm:all model:model] flattenMap:^RACStream *(id value) {
        @strongify(self)
        return [self.viewModel racGetAlarmList];
    }]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.mTableView reloadData];
     }]
    ;
}

-(void)initNav{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"action_clear".localizedString forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    [btn addTarget:self action:@selector(clearBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma click event
-(void)clearBtnClicked{
    //[self.deleteConfirmController ]
    
    if ([self.viewModel.alarmArray count] == 0) {
        [self showHint:@"string_emptyimage".localizedString];
        return;
    }
    [self presentViewController:self.deleteConfirmController animated:YES completion:nil];
}

#pragma mark - tableView

- (id)sourceObjAtIdx:(NSInteger)idx {
    AlarmListCell *cell = (AlarmListCell *)[self.mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    return cell ? cell.alarmImageView : nil;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"action_delete".localizedString;
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里实现删除操作
    
     [self deleteAlarmList:NO model:_viewModel.alarmArray[indexPath.row]];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_viewModel.alarmArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    AlarmListCell * cell = [AlarmListCell AlarmListCellWith:tableView indexPath:indexPath];
    [cell setModel:_viewModel.alarmArray[indexPath.row]];
    [cell setFrame:CGRectMake(0, 0, kScreenWidth,[AlarmListCell cellHeight] )];
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AlarmListCell cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [indexPath row];
    //    ImageDisplayController * ctl = [[ImageDisplayController alloc] init];
    //    [ctl setModel:_mediaArray[row]];
    //    [self.navigationController pushViewController:ctl animated:YES];
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSource = self;
    browser.currentIndex = row;
    [browser show];
    
    
    
}
// 实现 <YBImageBrowserDataSource> 协议方法配置数据源
- (NSUInteger)yb_numberOfCellForImageBrowserView:(YBImageBrowserView *)imageBrowserView {
    return [_viewModel.alarmArray count];
}
- (id<YBImageBrowserCellDataProtocol>)yb_imageBrowserView:(YBImageBrowserView *)imageBrowserView dataForCellAtIndex:(NSUInteger)index {
    YBImageBrowseCellData *data = [YBImageBrowseCellData new];
    AlarmImageModel * model = _viewModel.alarmArray[index];
    data.url = [NSURL URLWithString:model.Img];
    
    data.sourceObject = [self sourceObjAtIdx:index];
    return data;
}
#pragma getter
-(UIAlertController*)deleteConfirmController{
    if (!_deleteConfirmController) {
        @weakify(self)
        _deleteConfirmController = [UIAlertController  alertControllerWithTitle:nil message:@"action_clear_alarm_image".localizedString preferredStyle:UIAlertControllerStyleAlert];
        
        [_deleteConfirmController addAction:[UIAlertAction actionWithTitle:@"action_ok".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self deleteAlarmList:YES model:nil];
            
        }]];
        [_deleteConfirmController addAction:[UIAlertAction actionWithTitle:@"action_cancel".localizedString style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //@strongify(self)
            
        }]];
    }
    return _deleteConfirmController;
}
@end
