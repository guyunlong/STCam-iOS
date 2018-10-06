//
//  DevListViewController.h
//  STCam
//
//  Created by guyunlong on 8/27/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "DevListViewModel.h"
@interface DevListViewController : RootViewController
-(id)initWithViewModel:(DevListViewModel*)viewModel;
@property(nonatomic,strong)DevListViewModel * viewModel;
@end
