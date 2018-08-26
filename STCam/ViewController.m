//
//  ViewController.m
//  STCam
//
//  Created by guyunlong on 8/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "ViewController.h"
#import "DevListViewModel.h"
@interface ViewController ()
@property(nonatomic,strong)DevListViewModel * viewModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _viewModel = [DevListViewModel new];
    [_viewModel searchDevice];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
