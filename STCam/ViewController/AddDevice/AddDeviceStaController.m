//
//  AddDeviceStaController.m
//  STCam
//
//  Created by coverme on 2018/10/24.
//  Copyright © 2018 South. All rights reserved.
//

#import "AddDeviceStaController.h"
#import "PrefixHeader.h"
#import "DevListViewModel.h"
#import "SearchDeviceCell.h"
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
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)refreshStaDevList{
    @weakify(self)
    [[[_viewModel racSearchDeviceinMainView:NO]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self)
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
}

-(void)addDevice:(NSString*)devpwd{
     DeviceModel * model  = self.viewModel.searchDeviceArray[self.selectIndex];
}

#pragma getter
-(UIAlertController*)fillDevicePwdAlertController{
    if (!_fillDevicePwdAlertController) {
        @weakify(self)
        _fillDevicePwdAlertController = [UIAlertController alertControllerWithTitle:@"action_change_device_name".localizedString message:nil preferredStyle:UIAlertControllerStyleAlert];
        [_fillDevicePwdAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
           // @strongify(self)
            textField.placeholder = @"device_pwd".localizedString;
            DeviceModel * model  = self.viewModel.searchDeviceArray[self.selectIndex];
            textField.text =model.Pwd;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            UITextField *inputInfo = self.fillDevicePwdAlertController.textFields.firstObject;
            
            NSString * devPwd =inputInfo.text;
            if ([devPwd length] == 0) {
                [self showHint:@"error_field_required".localizedString];
                return ;
            }
            
            [self addDevice:devPwd];
            
        }];
        
        [_fillDevicePwdAlertController addAction:cancelAction];
        [_fillDevicePwdAlertController addAction:okAction];
        
    }
    return _fillDevicePwdAlertController;
}


@end
