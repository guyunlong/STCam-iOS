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
#import "DevListViewModel.h"
#import "UpdateDevModel.h"
#import "PowerConfigModel.h"
@interface DeviceSettingViewModel : NSObject
@property(nonatomic,strong)DeviceModel * model;
@property(nonatomic,strong)PushSettingModel * mPushSettingModel;
@property(nonatomic,strong)MotionCfgModel * motionCfgModel;//图像侦测灵明度
@property(nonatomic,strong)PowerConfigModel * powerConfigModel;//定时开关机配置
@property(nonatomic,assign)BOOL disableDelete;//
@property(nonatomic,assign)BOOL disableReset;//
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
/**
 恢复出厂设置
 */
-(RACSignal*)racSetDevLoadDefault;

/**
 获取最新设备固件版本

 @return signal
 */
-(RACSignal *)racAppUpgradeDevCheck;
@property(nonatomic,strong)UpdateDevModel * mUpdateDevModel;

-(RACSignal *)racCheckUpgradeBin;

/**
 获取定时开关机配置
 */
-(RACSignal *)racGetPowerOnConfig;

/**
 设置定时开关机配置
 */
-(RACSignal *)racSetPowerOnConfig;


@end
