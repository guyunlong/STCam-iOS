//
//  AddDeviceAPToStaController.m
//  STCam
//
//  Created by coverme on 2018/10/23.
//  Copyright © 2018 South. All rights reserved.
//

#import "AddDeviceAPToStaController.h"
#import "PrefixHeader.h"
@interface AddDeviceAPToStaController ()
@property(nonatomic,strong)UIAlertController  *joinAPAlertController;//提示加入ap网络
@end

@implementation AddDeviceAPToStaController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self presentViewController:self.joinAPAlertController animated:YES completion:nil];
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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNav];
}
-(void)initNav{
    [self setTitle:@"action_add_ap_sta".localizedString];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 28, 28);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(0, 0, 80, 28);
    refreshButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    [refreshButton addTarget:self action:@selector(refreshApDevList) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTitle:@"action_refresh".localizedString forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)refreshApDevList{
    
}
-(void)gotoWifiSetting{
    NSString * urlString = @"App-Prefs:root=WIFI";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }
}
#pragma getter
-(UIAlertController*)joinAPAlertController{
    if (!_joinAPAlertController) {
        @weakify(self)
        _joinAPAlertController = [UIAlertController alertControllerWithTitle:@"string_Info_APToSTA".localizedString message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self gotoWifiSetting];
        }];
        
        [_joinAPAlertController addAction:cancelAction];
        [_joinAPAlertController addAction:okAction];
        
    }
    return _joinAPAlertController;
}
@end
