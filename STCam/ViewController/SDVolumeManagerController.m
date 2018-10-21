//
//  SDVolumeManagerController.m
//  STCam
//
//  Created by guyunlong on 10/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "SDVolumeManagerController.h"
#import "PrefixHeader.h"
#import "CommonInfoCell.h"
#import "CommonSwitchCell.h"
@interface SDVolumeManagerController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)UITableView * mTableView;
@property(nonatomic,strong)NSMutableArray  * rowsArray;//列表数据
@end

@implementation SDVolumeManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initValue];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshDeviceAdvanceConfig];
}
-(void)initValue{
    _rowsArray = [NSMutableArray new];
    
    InfoModel * model0 = [InfoModel new];
    InfoModel * model1 = [InfoModel new];
    InfoModel * model2 = [InfoModel new];
   
    [model0 setTitle:@"action_volume_total".localizedString];
    [model1 setTitle:@"action_volume_left".localizedString];
    [model2 setTitle:@"action_record_recycle".localizedString];
  
    [_rowsArray addObject:model0];
    [_rowsArray addObject:model1];
    [_rowsArray addObject:model2];
    [self.mTableView reloadData];
    
}

-(void)refreshDeviceAdvanceConfig{
    
    @weakify(self)
    [[[self.viewModel racGetDiskCfg]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         if([x integerValue] == 1){
             @strongify(self)
            
             InfoModel * model0= self.rowsArray[0];
             [model0 setInfo:[self.viewModel.mSDInfoModel getTotalSizeDesc]];
             
             InfoModel * model1= self.rowsArray[1];
             [model1 setInfo:[self.viewModel.mSDInfoModel getFreeSizeDesc]];
             [self.mTableView reloadData];
         }
     }];
    
    
    
}

-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNav];
    _mTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView;
    });
    
    [self.view addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)initNav{
    [self setTitle:@"string_DevAdvancedSettings_TFManage".localizedString];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 28, 28);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(0, 0, 80, 28);
    refreshButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    [refreshButton addTarget:self action:@selector(refreshDeviceAdvanceConfig) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTitle:@"action_refresh".localizedString forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
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
    return [_rowsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    if (row <= 1) {
        CommonInfoCell * cell = [CommonInfoCell CommonInfoCellWith:tableView indexPath:indexPath];
        [cell setModel:_rowsArray[indexPath.row]];
        [cell setFrame:CGRectMake(0, 0, kScreenWidth, [CommonInfoCell cellHeight])];
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
        
        return cell;
    }
    else{
        CommonSwitchCell * cell = [CommonSwitchCell CommonSwitchCellWith:tableView indexPath:indexPath];
        [cell setModel:_rowsArray[indexPath.row]];
        [cell setFrame:CGRectMake(0, 0, kScreenWidth, [CommonInfoCell cellHeight])];
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
        cell.switchValueChangeBlock = ^(BOOL open) {
        
        };
        return cell;
    }
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row <= 1) {
         return [CommonInfoCell cellHeight];
    }
    else{
         return [CommonSwitchCell cellHeight];
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
   
    
}

@end
