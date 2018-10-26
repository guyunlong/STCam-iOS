//
//  SDVolumeManagerController.h
//  STCam
//
//  Created by guyunlong on 10/21/18.
//  Copyright © 2018 South. All rights reserved.
//  视频存储管理

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "DeviceSettingViewModel.h"
@interface SDVolumeManagerController : RootViewController
@property(nonatomic,strong) DeviceSettingViewModel* viewModel;
@end
