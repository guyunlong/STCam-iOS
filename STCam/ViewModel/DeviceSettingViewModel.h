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
@interface DeviceSettingViewModel : NSObject
@property(nonatomic,strong)DeviceModel * model;
-(RACSignal*)racChangeDeviceName:(NSString*)deviceName;
@end
