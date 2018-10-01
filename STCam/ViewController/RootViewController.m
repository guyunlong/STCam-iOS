//
//  STNavigationController.m
//  STCam
//
//  Created by guyunlong on 10/1/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "RootViewController.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
