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
@property(nonatomic,strong)UIAlertController  *changeMotionConfigSheet;//图像侦测灵明度
@property(nonatomic,strong)UIAlertController  *changePIRConfigSheet;//PIR灵明度
@property(nonatomic,strong)UIAlertController  *deviceAudioConfigSheet;//设备提示音开关
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
        
        InfoModel * model1 = _rowsArray[1];
        [model1 setInfo:[_viewModel.motionCfgModel getMotionDesc]];
        
        InfoModel * model2 = _rowsArray[2];
        [model2 setInfo:[_viewModel.mPushSettingModel getPIRSensitiveDesc]];
        
        [_mTableView reloadData];
        @weakify(self)
        [[[self.viewModel racGetAudioCfg]
          deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id x) {
             if([x integerValue] == 1){
                 @strongify(self)
                 NSString * soundDesc = self.viewModel.AUDIO_IsPlayPromptSound?@"action_open".localizedString:@"action_close".localizedString;
                 InfoModel * model3 = self.rowsArray[3];
                 [model3 setInfo:soundDesc];
                 [self.mTableView reloadData];
             }
         }];
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
    else if(1 == row){
         [self presentViewController:self.changeMotionConfigSheet animated:YES completion:nil];
    }
    else if(2 == row){
        [self presentViewController:self.changePIRConfigSheet animated:YES completion:nil];
    }
    else if(3 == row){
        [self presentViewController:self.deviceAudioConfigSheet animated:YES completion:nil];
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

-(void)changeMotionConfig:(NSInteger)index{
    switch (index) {
        case 0:
            _viewModel.motionCfgModel.MD_Active = 0;
            break;
        case 1:
            _viewModel.motionCfgModel.MD_Sensitive = 200;//low
            _viewModel.motionCfgModel.MD_Active = 1;
            break;
        case 2:
            _viewModel.motionCfgModel.MD_Sensitive = 150;//middle
            _viewModel.motionCfgModel.MD_Active = 1;
            break;
        case 3:
            _viewModel.motionCfgModel.MD_Sensitive = 100;//high
            _viewModel.motionCfgModel.MD_Active = 1;
            break;
        default:
            break;
    }
    [self.viewModel.mPushSettingModel setPushIntervalLevel:index];
    
    @weakify(self)
    [[[[self.viewModel racSetMotionCfg] filter:^BOOL(id value) {
        return [value integerValue] == 1;
    }]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self)
         if ([x integerValue] == 1) {
             InfoModel * model1 = self.rowsArray[1];
             [model1 setInfo:[self.viewModel.motionCfgModel getMotionDesc]];
             [self.mTableView reloadData];
         }
     }];
    
}

-(void)setPirConfig:(NSInteger)index{
    [self.viewModel.mPushSettingModel setPIRSensitive:index];
    
    @weakify(self)
    [[[self.viewModel racSetPushConfig]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self)
         if ([x integerValue] == 1) {
             InfoModel * model2 = self.rowsArray[2];
             [model2 setInfo:[self.viewModel.mPushSettingModel getPIRSensitiveDesc]];
             [self.mTableView reloadData];
         }
         
         
     }];
}
-(void)changeSoundPlayConfig:(BOOL)open{
    [self.viewModel setAUDIO_IsPlayPromptSound:open];
    
    @weakify(self)
    [[[[self.viewModel racSetAudioCfg] filter:^BOOL(id value) {
        return [value integerValue] == 1;
    }]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self)
         if ([x integerValue] == 1) {
             NSString * soundDesc = self.viewModel.AUDIO_IsPlayPromptSound?@"action_open".localizedString:@"action_close".localizedString;
             InfoModel * model3 = self.rowsArray[3];
             [model3 setInfo:soundDesc];
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


//changeMotionConfigSheet
-(UIAlertController*)changeMotionConfigSheet{
    if (!_changeMotionConfigSheet) {
        @weakify(self)
        _changeMotionConfigSheet = [UIAlertController alertControllerWithTitle:@"string_DevAdvancedSettings_PushInterval".localizedString message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        
        UIAlertAction *lowdAction = [UIAlertAction actionWithTitle:@"action_level_low".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self changeMotionConfig:1];
        }];
        
        UIAlertAction *middleAction = [UIAlertAction actionWithTitle:@"action_level_middle".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self changeMotionConfig:2];
        }];
        
        UIAlertAction *highAction = [UIAlertAction actionWithTitle:@"action_level_high".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self changeMotionConfig:3];
        }];
        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"action_close".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self changeMotionConfig:0];
        }];
       
        
        [_changeMotionConfigSheet addAction:cancelAction];
        [_changeMotionConfigSheet addAction:lowdAction];
        [_changeMotionConfigSheet addAction:middleAction];
        [_changeMotionConfigSheet addAction:highAction];
        [_changeMotionConfigSheet addAction:closeAction];
        
    }
    return _changeMotionConfigSheet;
}

-(UIAlertController*)changePIRConfigSheet{
    if (!_changePIRConfigSheet) {
        @weakify(self)
        _changePIRConfigSheet = [UIAlertController alertControllerWithTitle:@"string_DevAdvancedSettings_PIRSensitivity".localizedString message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        
        UIAlertAction *lowdAction = [UIAlertAction actionWithTitle:@"action_level_low".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self setPirConfig:0];
           
        }];
        
        UIAlertAction *middleAction = [UIAlertAction actionWithTitle:@"action_level_middle".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self setPirConfig:1];
        }];
        
        UIAlertAction *highAction = [UIAlertAction actionWithTitle:@"action_level_high".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self setPirConfig:2];
        }];
        
        [_changePIRConfigSheet addAction:lowdAction];
        [_changePIRConfigSheet addAction:middleAction];
        [_changePIRConfigSheet addAction:highAction];
        [_changePIRConfigSheet addAction:cancelAction];
        
    }
    return _changePIRConfigSheet;
}


-(UIAlertController*)deviceAudioConfigSheet{
    if (!_deviceAudioConfigSheet) {
        @weakify(self)
        _deviceAudioConfigSheet = [UIAlertController alertControllerWithTitle:@"string_DevAdvancedSettings_IsSoundPlay".localizedString message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        
        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"action_close".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self changeSoundPlayConfig:NO];
        }];
        
        UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"action_open".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self changeSoundPlayConfig:YES];
            
        }];
        
        [_deviceAudioConfigSheet addAction:openAction];
        [_deviceAudioConfigSheet addAction:closeAction];
        [_deviceAudioConfigSheet addAction:cancelAction];
        
    }
    return _deviceAudioConfigSheet;
}
@end
