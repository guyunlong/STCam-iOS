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
@property(nonatomic,strong)UIButton  * formatButton;//格式化按钮
@property(nonatomic,strong)UIAlertController  *formatConfirmAlertController;//确认格式化按钮
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
    [self showHudInView:self.view hint:nil];
    @weakify(self)
    [[[self.viewModel racGetDiskCfg]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         if([x integerValue] == 1){
             @strongify(self)
             [self hideHud];
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
    
    _formatButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, kScreenHeight-200*kWidthCoefficient, kScreenWidth-4*kPadding, kButtonHeight)];
    [_formatButton setTitle:@"action_sd_format".localizedString forState:UIControlStateNormal];
    [_formatButton setAppThemeType:ButtonStyleStyleAppTheme];
    [self.view addSubview:_formatButton];
    [_formatButton addTarget:self action:@selector(formatButtonClick) forControlEvents:UIControlEventTouchUpInside];
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
    [refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- method

-(void)formatButtonClick{
    [self presentViewController:self.formatConfirmAlertController animated:YES completion:nil];
}

-(void)changeAlarmRecordConfig{
    
    [[[self.viewModel racSetRecCfg] filter:^BOOL(id value) {
        return [value integerValue] == 1;
    }]
     
     subscribeNext:^(id x) {
         
     }];
    
}
-(void)formattfCard{
    [self showHudInView:self.view hint:nil];
    @weakify(self)
    [[[self.viewModel racFormattfCard]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self)
         [self hideHud];;
         if ([x integerValue] == 1) {
             [self showHint:@"action_Success".localizedString];
         }
         else if([x integerValue] == 2){
             [self showHint:@"action_Success_Reboot".localizedString];
         }
         else if([x integerValue] == 10000){
             [self showHint:@"action_Success_Reboot".localizedString];
         }
         else{
             [self showHint:@"action_Failed".localizedString];
         }
         
     }];
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
        [cell setOpen:(_viewModel.mRecConfigModel.Rec_RecStyle == 1)];
        [cell setModel:_rowsArray[indexPath.row]];
       
        [cell setFrame:CGRectMake(0, 0, kScreenWidth, [CommonInfoCell cellHeight])];
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
        @weakify(self)
        cell.switchValueChangeBlock = ^(BOOL open) {
            @strongify(self)
            self.viewModel.mRecConfigModel.Rec_RecStyle = open?1:0;
            [self changeAlarmRecordConfig];
        
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
#pragma getter

-(UIAlertController*)formatConfirmAlertController{
    if (!_formatConfirmAlertController) {
        @weakify(self)
        _formatConfirmAlertController = [UIAlertController alertControllerWithTitle:@"action_format_sd_ask".localizedString message:nil preferredStyle:UIAlertControllerStyleAlert];
       
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self formattfCard];
            
        }];
        
        [_formatConfirmAlertController addAction:cancelAction];
        [_formatConfirmAlertController addAction:okAction];
        
    }
    return _formatConfirmAlertController;
}

@end
