//
//  MoreViewController.m
//  STCam
//
//  Created by guyunlong on 8/27/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "MoreViewController.h"
#import "PrefixHeader.h"
#import "AccountManager.h"
#import "InfoModel.h"
#import "CommonSettingCell.h"
#import "ChangeAccountPwdController.h"
#import "FFHttpTool.h"
#import "UpdateModel.h"
#import "AboutAppController.h"
#import "ShareAccountManager.h"
#import "LoginViewController.h"
#import "STNavigationController.h"
#import "DevListViewModel.h"
@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)UIView * topBgView;//顶部蓝色背景
@property(nonatomic,strong)UIImageView * appIconImageView;
@property(nonatomic,strong)UILabel * userLb;
@property(nonatomic,strong)UITableView * mTableView;
@property(nonatomic,strong)UIButton  * exitButton;//退出登录按钮
@property(nonatomic,strong)NSMutableArray  * rowsArray;//列表数据
@property(nonatomic,strong)UIAlertController * alarmSoundSheetController;
@property(nonatomic,strong)UIAlertController  *updateConfirmAlertController;//提示升级
@property(nonatomic,strong)UIAlertController  *existAlertController;//退出登录
@end

@implementation MoreViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [_userLb setText:[AccountManager getUser]];
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
}
-(void)loadView{
    [super loadView];
    
    CGFloat y = 0;
    CGFloat topHeight  = 160*kWidthCoefficient;
    _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, topHeight)];
    [_topBgView setBackgroundColor:kMainColor];
    [self.view addSubview:_topBgView];
    
    CGFloat appIconWidth  = 70*kWidthCoefficient;
    _appIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-appIconWidth/2, 45*kWidthCoefficient, appIconWidth, appIconWidth)];
    [_appIconImageView setImage:[UIImage imageNamed:@"appicon100"]];
    [_topBgView addSubview:_appIconImageView];
    
    _userLb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_appIconImageView.frame)+kPadding/2, kScreenWidth, 24*kWidthCoefficient)];
    [_userLb setTextColor:[UIColor colorWithHexString:@"0x333333"]];
    [_userLb setTextAlignment:NSTextAlignmentCenter];
    [_topBgView addSubview:_userLb];
    
    y += topHeight;
    _mTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setUserInteractionEnabled:YES];
        [tableView setScrollEnabled:NO];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView;
    });
    
    [_mTableView setFrame:CGRectMake(0, y, kScreenWidth, 5*[CommonSettingCell cellHeight])];
    [self.view addSubview:_mTableView];
    
    y+= 5*[CommonSettingCell cellHeight] + 5*kPadding;
    _exitButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, kButtonHeight)];
    [_exitButton setTitle:@"action_exit".localizedString forState:UIControlStateNormal];
    [_exitButton setAppThemeType:ButtonStyleStyleAppTheme];
    [self.view addSubview:_exitButton];
    [_exitButton addTarget:self action:@selector(existButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
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
    
    [model0 setTitle:@"action_alarm_sound".localizedString];
    [model1 setTitle:@"action_change_system_password".localizedString];
    [model2 setTitle:@"action_share_manager".localizedString];
    [model3 setTitle:@"action_app_version".localizedString];
    [model4 setTitle:@"action_about".localizedString];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [model3 setInfo:app_Version];
    
    [_rowsArray addObject:model0];
    [_rowsArray addObject:model1];
    [_rowsArray addObject:model2];
    [_rowsArray addObject:model3];
    [_rowsArray addObject:model4];
    
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
    
    NSInteger row = [indexPath row];
    if (1 == row) {
        ChangeAccountPwdController * ctl = [ChangeAccountPwdController new];
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if(2 == row){
        ShareAccountManager * ctl = [ShareAccountManager new];
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if(3 == row){
        [self checkUpdateClicked];
    }
    else if(4 == row){
        AboutAppController * ctl = [AboutAppController new];
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
//    MediaDetailController *ctl = [MediaDetailController new];
//    [ctl setHidesBottomBarWhenPushed:YES];
//    [ctl setModel:_devListViewModel.deviceArray[indexPath.row]];
//    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)existButtonClicked{
    [self presentViewController:self.existAlertController animated:YES completion:nil];
}
-(void)checkUpdateClicked{
    [self showHudInView:self.view hint:nil];
    NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_upgrade_app_check.asp?apptype=1&ostype=ios",serverIP,ServerPort];
    @weakify(self);
    [FFHttpTool GET:url parameters:nil success:^(id data){
        @strongify(self)
        [self hideHud];
        if ([data isKindOfClass:[NSDictionary class]]) {
            UpdateModel * model = [UpdateModel UpdateModelWithDict:data];
            if (model) {
                if(![model checkIsLocalAlreadyNewerVersion]){
                    [self presentViewController:self.updateConfirmAlertController animated:YES completion:nil];
                }
                else{
                    [self showHint:@"string_current_newer".localizedString];
                }
            }
        }
        
    } failure:^(NSError * error){
        [self hideHud];
    }];
}

#pragma getter

-(UIAlertController*)updateConfirmAlertController{
    if (!_updateConfirmAlertController) {
        @weakify(self)
        _updateConfirmAlertController = [UIAlertController alertControllerWithTitle:@"string_current_older".localizedString message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            
        }];
        
        [_updateConfirmAlertController addAction:cancelAction];
        [_updateConfirmAlertController addAction:okAction];
        
    }
    return _updateConfirmAlertController;
}



-(UIAlertController*)alarmSoundSheetController{
    if (!_alarmSoundSheetController) {
        @weakify(self)
        _alarmSoundSheetController = [UIAlertController alertControllerWithTitle:@"action_alarm_sound".localizedString message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        
        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"action_close".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
           // [self changeSoundPlayConfig:NO];
        }];
        
        UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"action_open".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
           // [self changeSoundPlayConfig:YES];
            
        }];
        
        [_alarmSoundSheetController addAction:openAction];
        [_alarmSoundSheetController addAction:closeAction];
        [_alarmSoundSheetController addAction:cancelAction];
        
    }
    return _alarmSoundSheetController;
}
-(UIAlertController*)existAlertController{
    if (!_existAlertController) {
        @weakify(self)
        _existAlertController = [UIAlertController alertControllerWithTitle:@"action_exit_ask".localizedString message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"action_cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        
        UIAlertAction *existction = [UIAlertAction actionWithTitle:@"action_ok".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [AccountManager saveRemember:NO];
            DevListViewModel * viewModel = [DevListViewModel sharedDevListViewModel];
            for (DeviceModel * model in viewModel.deviceArray) {
                [model threadDisconnect];
            }
            [viewModel.deviceArray removeAllObjects];
             LoginViewController * ctl  = [[LoginViewController alloc] init];
            STNavigationController *loginNav =   [[STNavigationController alloc] initWithRootViewController:ctl];
            [self presentViewController:loginNav animated:YES completion:nil];
            
        }];
        [_existAlertController addAction:existction];
        [_existAlertController addAction:cancelAction];
        
    }
    return _existAlertController;
}




@end
