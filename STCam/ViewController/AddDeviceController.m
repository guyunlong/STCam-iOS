//
//  AddDeviceController.m
//  STCam
//
//  Created by coverme on 10/16/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "AddDeviceController.h"
#import "PrefixHeader.h"
@interface AddDeviceController ()
@property (nonatomic, strong) UIButton *smartAddButton;
@property (nonatomic, strong) UIButton *apTStaAddButton;
@property (nonatomic, strong) UIButton *wifiAddButton;
@property (nonatomic, strong) UIButton *qrCodeAddButton;
@end

@implementation AddDeviceController

-(void)initNav{
    [self setTitle:@"action_add_device".localizedString];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)loadView{
    [super loadView];
    [self initNav];
    
    CGFloat y = 3*kPadding;
    _smartAddButton= [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-6*kPadding, kButtonHeight)];
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
