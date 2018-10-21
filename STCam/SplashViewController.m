//
//  ViewController.m
//  STCam
//
//  Created by guyunlong on 8/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "SplashViewController.h"
#import "DevListViewModel.h"
#import "LoginViewController.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"
#import "PrefixHeader.h"
#import "libthSDK.h"
@interface SplashViewController ()
@property(nonatomic,strong)DevListViewModel * viewModel;
@property(nonatomic,strong)UILabel * versionLb;
@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    P2P_Init();
    // Do any additional setup after loading the view, typically from a nib.
    //_viewModel = [DevListViewModel new];
   // [_viewModel searchDevice];
    
    _versionLb = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight-100, kScreenWidth-kPadding, 24)];
    [self.view addSubview:_versionLb];
    [_versionLb setTextAlignment:NSTextAlignmentRight];
    [_versionLb setTextColor:[UIColor redColor]];
    [_versionLb setFont:[UIFont boldSystemFontOfSize:20]];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [_versionLb setText:[infoDictionary objectForKey:@"CFBundleVersion"]];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kMainColor] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //跳转到LoginViewController
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LoginViewController * ctl  = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    });
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
