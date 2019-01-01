//
//  AddDeviceStaController.m
//  STCam
//
//  Created by cc on 2018/10/24.
//  Copyright © 2018 South. All rights reserved.
//

#import "AddDeviceStaController.h"
#import "PrefixHeader.h"
#import "DevListViewModel.h"
#import "SearchDeviceCell.h"
#import "CoreDataManager.h"
#import "FFHttpTool.h"
#import "AccountManager.h"
#import "RetModel.h"
@interface AddDeviceStaController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)UIAlertController  *fillDevicePwdAlertController;//输入设备密码提示框
@property(nonatomic,strong)DevListViewModel *viewModel;
@property(nonatomic,strong)UILabel * titleLb;
@property(nonatomic,strong)UITableView * mTableView;
@property(nonatomic,assign)NSInteger selectIndex;
@end

@implementation AddDeviceStaController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshStaDevList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewModel = [DevListViewModel sharedDevListViewModel];
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
    [self setTitle:@"action_search".localizedString];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 28, 28);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(0, 0, 80, 28);
    refreshButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    [refreshButton addTarget:self action:@selector(refreshStaDevList) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTitle:@"action_refresh".localizedString forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)refreshStaDevList{
    [self showHudInView:self.view hint:nil];
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
    _selectIndex = indexPath.row;
     DeviceModel * model  = self.viewModel.searchDeviceArray[self.selectIndex];
    if ([_viewModel isSearchDevExistInDeviceArray:model]) {
        [self showHint:@"error_device_added".localizedString];
        return;
    }
    [self presentViewController:self.fillDevicePwdAlertController animated:YES completion:nil];
}

-(void)addDevice:(NSString*)devpwd{
    DeviceModel * model  = self.viewModel.searchDeviceArray[self.selectIndex];
    model.Pwd = devpwd;
    [[CoreDataManager sharedManager] saveDevice:model];
    
    /******************1、向设备内执行任意http指令，如果又返回，则说明设备密码正确*********************/
    /******************2、添加设备*********************/
    [self showHudInView:self.view hint:nil];
    @weakify(self);
    [[[[self racExcuteDeviceHttpCmd:model] filter:^BOOL(id value) {
        if ([value integerValue] != 1) {
            @strongify(self);
            [self hideHud];
            [self showHint:@"error_dev_pass".localizedString];
        }
        return [value integerValue] == 1;
    }]
      flattenMap:^RACStream *(id value) {
          return [self racAddDevice:model];
      }]
     subscribeNext:^(id x) {
         @strongify(self);
         [self hideHud];
         if ([x integerValue] == RESULT_SUCCESS) {
             [self showHint:@"string_devAddSuccess".localizedString];
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
         else if([x integerValue] == RESULT_USER_ISBIND){
             [self showHint:@"string_user_IsBind".localizedString];
         }
         else{
             [self showHint:@"string_devAddFail".localizedString];
         }
         
     }];
    
}

-(RACSignal *)racExcuteDeviceHttpCmd:(DeviceModel*)model{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        //http://211.149.199.247:800/app_user_get_devlst.asp?user=1257117229@qq.com&psd=12345678
        NSString * url = [NSString stringWithFormat:@"http://%@:%ld/cfg1.cgi?User=%@&Psd=%@&MsgID=%d",model.IPUID,model.WebPort,model.User,model.Pwd,Msg_GetTime];
        [FFHttpTool GET:url parameters:nil success:^(id data){
            @strongify(self)
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSInteger time = [[data objectForKey:@"time"] integerValue];
                if (time > 0) {
                    [subscriber sendNext:@1];//
                }
                else{
                    [subscriber sendNext:@0];//
                }
               
            }
            else{
                [subscriber sendNext:@0];//
            }
            [subscriber sendCompleted];
        } failure:^(NSError * error){
            [subscriber sendNext:@0];////未知网络错误
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

-(RACSignal *)racAddDevice:(DeviceModel*)model{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        //http://211.149.199.247:800/app_user_get_devlst.asp?user=1257117229@qq.com&psd=12345678
        NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_user_add_dev.asp?user=%@&psd=%@&tokenid=%@&sn=%@",serverIP,ServerPort,[AccountManager getUser],[AccountManager getPassword],[AccountManager sharedManager].deviceToken,model.SN];
        [FFHttpTool GET:url parameters:nil success:^(id data){
            @strongify(self)
            if ([data isKindOfClass:[NSDictionary class]]) {
                RetModel * model =[RetModel RetModelWithDict:data];
                if (model.ret == RESULT_SUCCESS) {
                    [subscriber sendNext:@1];//
                }
                else{
                     [subscriber sendNext:@(model.ret)];//
                }
            }
            else{
                [subscriber sendNext:@0];//
            }
            [subscriber sendCompleted];
        } failure:^(NSError * error){
            [subscriber sendNext:@0];////未知网络错误
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}




#pragma getter
-(UIAlertController*)fillDevicePwdAlertController{
    if (!_fillDevicePwdAlertController) {
        @weakify(self)
        _fillDevicePwdAlertController = [UIAlertController alertControllerWithTitle:@"action_add_device_search".localizedString message:nil preferredStyle:UIAlertControllerStyleAlert];
        [_fillDevicePwdAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            @strongify(self)
            textField.placeholder = @"device_pwd".localizedString;
            DeviceModel * model  = self.viewModel.searchDeviceArray[self.selectIndex];
            textField.text =model.Pwd;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            UITextField *inputInfo = self.fillDevicePwdAlertController.textFields.firstObject;
            
            NSString * devPwd =inputInfo.text;
            if ([devPwd length] < 4) {
                [self showHint:@"error_invalid_password".localizedString];
                return ;
            }
            else{
                [self addDevice:devPwd];
            }
            
            
            
        }];
        
        [_fillDevicePwdAlertController addAction:cancelAction];
        [_fillDevicePwdAlertController addAction:okAction];
        
    }
    return _fillDevicePwdAlertController;
}


@end
