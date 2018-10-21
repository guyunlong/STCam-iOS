//
//  DeviceSettingViewModel.h
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "PushSettingModel.h"
@interface DeviceSettingViewModel : NSObject
@property(nonatomic,strong)DeviceModel * model;
@property(nonatomic,strong)PushSettingModel * mPushSettingModel;
-(RACSignal*)racChangeDeviceName:(NSString*)deviceName;
-(RACSignal*)racChangeDevicePassword:(NSString*)devicePassword;
-(RACSignal*)racGetPushSetting;
-(RACSignal*)racRebootDevice;
-(RACSignal*)racSetPushConfig;
@end
