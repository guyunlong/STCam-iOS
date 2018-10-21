//
//  DeviceSettingController.m
//  STCam
//
//  Created by guyunlong on 10/14/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "DeviceSettingController.h"
#import "PrefixHeader.h"
#import "STFileManager.h"
#import "CommonSettingCell.h"
#import "ChangeDevicePwdController.h"
#import "DeviceAdvanceSettingController.h"
@interface DeviceSettingController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)UIImageView * devThumbView;//设备缩略图
@property(nonatomic,strong)UILabel * snLabel;
@property(nonatomic,strong)UILabel * uidLabel;
@property(nonatomic,strong)UITableView * mTableView;
@property(nonatomic,strong)UIButton  * deleteButton;//删除按钮
@property(nonatomic,strong)NSMutableArray  * rowsArray;//列表数据
@property(nonatomic,strong)UIAlertController  *changeDeviceNameAlert;//修改设备名称
@property(nonatomic,strong)UIAlertController  *changePushSheet;//推送开关
@end

@implementation DeviceSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initValue];
    [self.mTableView reloadData];
}

-(void)initValue{
    _rowsArray = [NSMutableArray new];
    
    InfoModel * model0 = [InfoModel new];
    InfoModel * model1 = [InfoModel new];
    InfoModel * model2 = [InfoModel new];
    InfoModel * model3 = [InfoModel new];
    InfoModel * model4 = [InfoModel new];
    
    
    
    [model0 setTitle:@"device_name".localizedString];
    [model1 setTitle:@"action_device_pwd".localizedString];
    [model2 setTitle:@"action_push".localizedString];
    [model3 setTitle:@"string_DevAdvancedSettings".localizedString];
    [model4 setTitle:@"action_version".localizedString];
    
   
    
    [_rowsArray addObject:model0];
    [_rowsArray addObject:model1];
    [_rowsArray addObject:model2];
    [_rowsArray addObject:model3];
    [_rowsArray addObject:model4];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.viewModel){
        STFileManager * manager = [STFileManager sharedManager];
        if (![manager fileExistsForUrl:@"Thumbnail"]) {
            [manager createDirectoryNamed:@"Thumbnail"];
        }
        NSString * fileName = [manager localPathForFile:[NSString stringWithFormat:@"%@.png",self.viewModel.model.SN] inDirectory:@"Thumbnail"];
        UIImage * image  =[UIImage imageWithContentsOfFile:fileName];
        if (image) {
            [_devThumbView setImage:image];
            _devThumbView.contentMode = UIViewContentModeScaleToFill;
        }
        else{
            [_devThumbView setImage:[UIImage imageNamed:@"imagethumb"]];
        }
        
        [_snLabel setText:[NSString stringWithFormat:@"SN:%@",self.viewModel.model.SN]];
        if ([self.viewModel.model.IPUID length] == 20) {
             [_uidLabel setText:[NSString stringWithFormat:@"UID:%@",self.viewModel.model.IPUID]];
            [_snLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.devThumbView.mas_centerY).with.offset(-kPadding/3);
            }];
           
        }
        else{
            [_uidLabel setHidden:YES];
            [_snLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.devThumbView.mas_centerY);
            }];
        }
        
        InfoModel * model0 = [_rowsArray objectAtIndex:0];
        [model0 setInfo:_viewModel.model.DevName];
        [self.mTableView reloadData];
        
        
        InfoModel * model1 = [_rowsArray objectAtIndex:1];
        NSMutableString * info  = [NSMutableString new];
        NSInteger length = [self.viewModel.model.Pwd length];
        for (int i = 0; i<length; ++i) {
            [info appendString:@"*"];
        }
        [model1 setInfo:info];
        
        @weakify(self)
        [[[_viewModel racGetPushSetting]
          deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id x) {
             @strongify(self)
             InfoModel * model2 = [self.rowsArray objectAtIndex:2];
             [model2 setInfo:[self.viewModel.mPushSettingModel getPushActiveDes]];
             [self.mTableView reloadData];
         }];
       
    }
    
}
-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNav];
    _devThumbView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadding, kPadding, 100*kWidthCoefficient, 50*kWidthCoefficient)];
    [self.view addSubview:_devThumbView];
    
    _snLabel = [UILabel new];
    [self.view addSubview:_snLabel];
    
    _uidLabel = [UILabel new];
    [self.view addSubview:_uidLabel];
    
    [_snLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.bottom.mas_equalTo(self.devThumbView.mas_centerY).with.offset(-kPadding/3);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-kPadding);
        make.height.equalTo(@24);
        make.left.mas_equalTo(self.devThumbView.mas_right).with.offset(kPadding);
    }];
    
    [_uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.devThumbView.mas_centerY).with.offset(kPadding/3);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-kPadding);
        make.height.equalTo(@24);
        make.left.mas_equalTo(self.devThumbView.mas_right).with.offset(kPadding);
    }];
    
    _mTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView;
    });
    CGFloat y = 50*kWidthCoefficient + 2*kPadding;
    [_mTableView setFrame:CGRectMake(0, y, kScreenWidth, 5*[CommonSettingCell cellHeight])];
    [self.view addSubview:_mTableView];
    
    y+= 5*[CommonSettingCell cellHeight] + 5*kPadding;
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, kButtonHeight)];
    [_deleteButton setTitle:@"action_delete_device".localizedString forState:UIControlStateNormal];
    [_deleteButton setAppThemeType:ButtonStyleStyleAppTheme];
    [self.view addSubview:_deleteButton];
    
    
}

-(void)initNav{
    [self setTitle:@"action_dev_setting".localizedString];
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
    NSInteger row = indexPath.row;
    if(0 == row || 1 == row || 2 == row || 3 == row){
        if (![_viewModel.model IsConnect])
        {
            [self showHint:@"action_net_not_connect".localizedString];
            return;
        }
    }
    if (0 == row) {
        
        [self presentViewController:self.changeDeviceNameAlert animated:YES completion:nil];
    }
    else if(1 == row){
        ChangeDevicePwdController * ctl = [ChangeDevicePwdController new];
        [ctl setViewModel:_viewModel];
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if(2 == row){
         [self presentViewController:self.changePushSheet animated:YES completion:nil];
    }
    else if(3 == row){
        DeviceAdvanceSettingController * ctl =  [DeviceAdvanceSettingController new];
        [ctl setViewModel:_viewModel];
        [self.navigationController pushViewController:ctl animated:YES];
    }
  
}

#pragma Methods
-(void)changeDeviceName:(NSString*)deviceName{
    @weakify(self)
    [self showHudInView:self.view hint:@""];
    [[[self.viewModel racChangeDeviceName:deviceName]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self)
         [self hideHud];
         if([x integerValue] == 1){
             [self showHint:@"action_Success".localizedString];
             InfoModel * model0 = [self.rowsArray objectAtIndex:0];
             [model0 setInfo:self.viewModel.model.DevName];
             [self.mTableView reloadData];
         }
         else{
             [self showHint:@"action_Failed".localizedString];
         }
     }];
}

-(void)setPushConfig:(BOOL)open{
    [self.viewModel.mPushSettingModel setPushActive:open];
    @weakify(self)
    [[[self.viewModel racSetPushConfig]
    deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self)
         if ([x integerValue] == 1) {
             InfoModel * model2 = [self.rowsArray objectAtIndex:2];
             [model2 setInfo:[self.viewModel.mPushSettingModel getPushActiveDes]];
             [self.mTableView reloadData];
         }
         
         
     }];
}
#pragma getter
-(UIAlertController*)changeDeviceNameAlert{
    if (!_changeDeviceNameAlert) {
        @weakify(self)
        _changeDeviceNameAlert = [UIAlertController alertControllerWithTitle:@"action_change_device_name".localizedString message:nil preferredStyle:UIAlertControllerStyleAlert];
        [_changeDeviceNameAlert addTextFieldWithConfigurationHandler:^(UITextField *textField){
            @strongify(self)
            textField.placeholder = @"device_name".localizedString;
            textField.text = self.viewModel.model.DevName;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            UITextField *inputInfo = self.changeDeviceNameAlert.textFields.firstObject;
            
            NSString * devName =inputInfo.text;
            if ([devName length] == 0) {
                [self showHint:@"error_field_required".localizedString];
                return ;
            }
            
            [self changeDeviceName:devName];
            
        }];
        
        [_changeDeviceNameAlert addAction:cancelAction];
        [_changeDeviceNameAlert addAction:okAction];
     
    }
    return _changeDeviceNameAlert;
}
-(UIAlertController*)changePushSheet{
    if (!_changePushSheet) {
        @weakify(self)
        _changePushSheet = [UIAlertController alertControllerWithTitle:@"action_push".localizedString message:nil preferredStyle:UIAlertControllerStyleActionSheet];
       
      UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        
        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"action_close".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self setPushConfig:NO];
        }];
        
        UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"action_open".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
           [self setPushConfig:YES];
            
        }];
        
        [_changePushSheet addAction:openAction];
        [_changePushSheet addAction:closeAction];
        [_changePushSheet addAction:cancelAction];
        
    }
    return _changePushSheet;
}

//

@end
