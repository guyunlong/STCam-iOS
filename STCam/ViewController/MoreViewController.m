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
@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)UIView * topBgView;//顶部蓝色背景
@property(nonatomic,strong)UIImageView * appIconImageView;
@property(nonatomic,strong)UILabel * userLb;
@property(nonatomic,strong)UITableView * mTableView;
@property(nonatomic,strong)UIButton  * exitButton;//退出登录按钮
@property(nonatomic,strong)NSMutableArray  * rowsArray;//列表数据
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
        [tableView setUserInteractionEnabled:NO];
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
    
//    MediaDetailController *ctl = [MediaDetailController new];
//    [ctl setHidesBottomBarWhenPushed:YES];
//    [ctl setModel:_devListViewModel.deviceArray[indexPath.row]];
//    [self.navigationController pushViewController:ctl animated:YES];
}
@end
