//
//  DeviceAdvanceSettingController.m
//  STCam
//
//  Created by guyunlong on 10/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "DeviceAdvanceSettingController.h"
#import "CommonSettingCell.h"
#import "PrefixHeader.h"
@interface DeviceAdvanceSettingController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray  * rowsArray;//列表数据
@property(nonatomic,strong)UITableView * mTableView;
@property(nonatomic,strong)UIAlertController  *changePushIntervalSheet;//推送间隔
@end

@implementation DeviceAdvanceSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initValue];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.viewModel){
        InfoModel * model0 = _rowsArray[0];
        [model0 setInfo:[_viewModel.mPushSettingModel getPushIntervalDesc]];
        
        [_mTableView reloadData];
    }
    
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
    [self setTitle:@"string_DevAdvancedSettings".localizedString];
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


-(void)initValue{
    _rowsArray = [NSMutableArray new];
    
    InfoModel * model0 = [InfoModel new];
    InfoModel * model1 = [InfoModel new];
    InfoModel * model2 = [InfoModel new];
    InfoModel * model3 = [InfoModel new];
    InfoModel * model4 = [InfoModel new];
    InfoModel * model5 = [InfoModel new];
    
    
    
    [model0 setTitle:@"string_DevAdvancedSettings_PushInterval".localizedString];
    [model1 setTitle:@"string_DevAdvancedSettings_MotionSensitivity".localizedString];
    [model2 setTitle:@"string_DevAdvancedSettings_PIRSensitivity".localizedString];
    [model3 setTitle:@"string_DevAdvancedSettings_IsSoundPlay".localizedString];
    [model4 setTitle:@"string_DevAdvancedSettings_AlmTimeLen".localizedString];
    [model5 setTitle:@"string_DevAdvancedSettings_TFManage".localizedString];
    
    
    
    [_rowsArray addObject:model0];
    [_rowsArray addObject:model1];
    [_rowsArray addObject:model2];
    [_rowsArray addObject:model3];
    [_rowsArray addObject:model4];
    [_rowsArray addObject:model5];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    CommonSettingCell * cell = [CommonSettingCell CommonSettingCellWith:tableView indexPath:indexPath];
    [cell setModel:_rowsArray[indexPath.row]];
    [cell setFrame:CGRectMake(0, 0, kScreenWidth, [CommonSettingCell cellHeight])];
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    
    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommonSettingCell cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![_viewModel.model IsConnect])
    {
        [self showHint:@"action_net_not_connect".localizedString];
        return;
    }
    
    NSInteger row = indexPath.row;
    if (0 == row) {
        [self presentViewController:self.changePushIntervalSheet animated:YES completion:nil];
    }
    
}
#pragma methods
-(void)changePushInterval:(NSInteger)index{
    [self.viewModel.mPushSettingModel setPushIntervalLevel:index];
    
    @weakify(self)
    [[[[self.viewModel racSetPushConfig] filter:^BOOL(id value) {
        return [value integerValue] == 1;
    }]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self)
         if ([x integerValue] == 1) {
             InfoModel * model0 = self.rowsArray[0];
             [model0 setInfo:[self.viewModel.mPushSettingModel getPushIntervalDesc]];
             [self.mTableView reloadData];
         }
     }];
    
}
#pragma getter
-(UIAlertController*)changePushIntervalSheet{
    if (!_changePushIntervalSheet) {
        @weakify(self)
        _changePushIntervalSheet = [UIAlertController alertControllerWithTitle:@"string_DevAdvancedSettings_PushInterval".localizedString message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        
        UIAlertAction *tenSecondAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"10%@",@"string_second".localizedString] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self changePushInterval:0];
        }];
        
        UIAlertAction *thirtenSecondAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"30%@",@"string_second".localizedString] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self changePushInterval:1];
        }];
        
        UIAlertAction *oneMinAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"1%@",@"string_miniute".localizedString] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self changePushInterval:2];
        }];
        UIAlertAction *fiveMinAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"5%@",@"string_miniute".localizedString] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self changePushInterval:3];
        }];
        UIAlertAction *tenMinAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"10%@",@"string_miniute".localizedString] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self changePushInterval:4];
        }];
        
        [_changePushIntervalSheet addAction:cancelAction];
        [_changePushIntervalSheet addAction:tenSecondAction];
        [_changePushIntervalSheet addAction:thirtenSecondAction];
        [_changePushIntervalSheet addAction:oneMinAction];
        [_changePushIntervalSheet addAction:fiveMinAction];
        [_changePushIntervalSheet addAction:tenMinAction];
        
    }
    return _changePushIntervalSheet;
}

@end
