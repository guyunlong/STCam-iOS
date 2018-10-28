//
//  LedControlViewModel.h
//  STCam
//
//  Created by cc on 2018/10/26.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"
#import "LedStatusModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
@interface LedControlViewModel : NSObject
@property(nonatomic,strong)DeviceModel * model;
@property(nonatomic,strong)LedStatusModel * ledStatusModel;

/**
 获得灯光配置
 */
-(RACSignal*)racGetLightCfg;

/**
 设置灯光配置
 */
-(RACSignal*)racSetLightCfg;
-(void)destoryTimer;
-(void)setupTimer;
@property(nonatomic,assign)BOOL changeValue;
@property(nonatomic,strong)NSTimer * refreshTimer;
@end
