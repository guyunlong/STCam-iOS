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
#import "MotionCfgModel.h"
#import "RecConfigModel.h"
#import "SDInfoModel.h"
@interface DeviceSettingViewModel : NSObject
@property(nonatomic,strong)DeviceModel * model;
@property(nonatomic,strong)PushSettingModel * mPushSettingModel;
@property(nonatomic,strong)MotionCfgModel * motionCfgModel;//图像侦测灵明度
-(RACSignal*)racChangeDeviceName:(NSString*)deviceName;
-(RACSignal*)racChangeDevicePassword:(NSString*)devicePassword;
-(RACSignal*)racGetPushSetting;
-(RACSignal*)racRebootDevice;
-(RACSignal*)racSetPushConfig;
-(RACSignal*)racGetMotionCfg;
-(RACSignal*)racSetMotionCfg;


/*************设备提示音开关***************/
-(RACSignal*)racGetAudioCfg;
-(RACSignal*)racSetAudioCfg;
@property(nonatomic,assign)BOOL AUDIO_IsPlayPromptSound;//设备提示音开关

/*************录像***************/
-(RACSignal*)racGetRecCfg;
-(RACSignal*)racSetRecCfg;
@property(nonatomic,strong)RecConfigModel *mRecConfigModel;//录像

/*************sd卡***************/
@property(nonatomic,strong)SDInfoModel *mSDInfoModel;//sd卡信息
-(RACSignal*)racGetDiskCfg;
-(RACSignal*)racFormattfCard;

@end
