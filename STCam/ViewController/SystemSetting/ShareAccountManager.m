//
//  ShareAccountManager.m
//  STCam
//
//  Created by coverme on 2018/10/30.
//  Copyright © 2018 South. All rights reserved.
//

#import "ShareAccountManager.h"
#import "PrefixHeader.h"
#import "UserModel.h"
#import "FFHttpTool.h"
#import "AccountManager.h"
#import "CommonInfoCell.h"
#import "RetModel.h"
#import "MJRefresh.h"
@interface ShareAccountManager ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)UITableView * mTableView;
@property(nonatomic,strong)NSMutableArray * sharedUserArray;
@end

@implementation ShareAccountManager

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _sharedUserArray = [NSMutableArray new];
     [self getSharedUsers:NO];
    
}

-(void)getSharedUsers:(BOOL)dragToFresh{
    if (!dragToFresh) {
        [self showHudInView:self.view hint:nil];
    }
    NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_share_get_lst.asp?user=%@&psd=%@",serverIP,ServerPort,[AccountManager getUser],[AccountManager getPassword]];
    @weakify(self);
    [FFHttpTool GET:url parameters:nil success:^(id data){
        @strongify(self)
         [self.mTableView.mj_header endRefreshing];
        [self hideHud];
        if ([data isKindOfClass:[NSArray class]]) {
            [self.sharedUserArray removeAllObjects];
            for (NSDictionary * dic in data) {
                UserModel * model = [UserModel UserModelWithDict:dic];
                [self.sharedUserArray addObject:model];
            }
            [self.mTableView reloadData];
        }
       
    } failure:^(NSError * error){
       [self hideHud];
         [self.mTableView.mj_header endRefreshing];
    }];
}
-(void)initNav{
    [self setTitle:@"action_share_account_manager".localizedString];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 28, 28);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    
}
-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNav];
    
    _mTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setBackgroundColor:[UIColor whiteColor]];
        tableView.dataSource = self;
        tableView.delegate = self;
        // 下拉刷新
        @weakify(self)
        tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //
            @strongify(self)
            [self getSharedUsers:YES];
        }];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.automaticallyChangeAlpha = YES;
        tableView;
    });
    [self.view addSubview:_mTableView];
    
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)deleteSubUser:(NSInteger)index{
    UserModel * model = [_sharedUserArray objectAtIndex:index];
    NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_share_del_sub.asp?user=%@&psd=%@&sub=%@&sn=%@",serverIP,ServerPort,[AccountManager getUser],[AccountManager getPassword],model.User,model.SN];
    @weakify(self);
    [FFHttpTool GET:url parameters:nil success:^(id data){
        @strongify(self)
        [self hideHud];
        if ([data isKindOfClass:[NSDictionary class]]) {
            RetModel * retModel = [RetModel RetModelWithDict:data];
            if ([retModel ret] == 1) {
                [self.sharedUserArray removeObjectAtIndex:index];
                [self.mTableView reloadData];
            }
            else{
                [self.mTableView reloadData];
            }
            
        }
        
    } failure:^(NSError * error){
        [self.mTableView reloadData];
    }];
}
#pragma mark - tableView



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
    [self deleteSubUser:indexPath.row];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sharedUserArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonInfoCell * cell = [CommonInfoCell CommonInfoCellWith:tableView indexPath:indexPath];
    InfoModel * model = [InfoModel new];
    UserModel * userModel = _sharedUserArray[indexPath.row];
    [model setTitle:userModel.User];
    [model setInfo:userModel.SN];
    [cell setModel:model];
    [cell setFrame:CGRectMake(0, 0, kScreenWidth,[CommonInfoCell cellHeight] )];
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommonInfoCell cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
}

@end
