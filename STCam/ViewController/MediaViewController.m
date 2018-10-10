//
//  MediaViewController.m
//  STCam
//
//  Created by guyunlong on 8/27/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "MediaViewController.h"
#import "PrefixHeader.h"
#import "DevListViewModel.h"
#import "DevMediaCell.h"
@interface MediaViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)UITableView * mTableView;
@property(nonatomic,strong)DevListViewModel * devListViewModel;
@end

@implementation MediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"action_media".localizedString];
    
    _devListViewModel = [DevListViewModel sharedDevListViewModel];
     
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.mTableView reloadData];
}


-(void)loadView{
    [super loadView];
    if (!_mTableView) {
        _mTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView setUserInteractionEnabled:true];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView;
        });
    }
    [self.view addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_devListViewModel.deviceArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    DevMediaCell * cell = [DevMediaCell DevMediaCellWith:tableView indexPath:indexPath];
    [cell setModel:_devListViewModel.deviceArray[indexPath.row]];
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DevMediaCell cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
