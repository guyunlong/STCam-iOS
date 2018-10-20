//
//  RecordListController.h
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "RecordListViewModel.h"
@interface RecordListController : RootViewController
@property(nonatomic,strong)RecordListViewModel * viewModel;
@end
