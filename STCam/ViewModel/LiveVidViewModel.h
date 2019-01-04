//
//  LiveVidViewModel.h
//  STCam
//
//  Created by guyunlong on 10/6/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "DoorCfgModel.h"
typedef NS_ENUM(NSInteger, PtzControlType){
    PtzControlType_None,
    PtzControlType_Up = 1,
    PtzControlType_Down = 3,
    PtzControlType_Left = 5,
    PtzControlType_Right = 7,
    PtzControlType_Zoom0,
    PtzControlType_Zoom1
};

@protocol VidViewModelDelegate <NSObject>
- (void)updateVidView:(CVPixelBufferRef)pixelBuffer;
@end
@interface LiveVidBufferModel : NSObject
@end
@interface LiveVidViewModel : NSObject
@property(nonatomic,strong)DeviceModel*model;



/**
 默认sub为1，播放辅码流
 */
@property(nonatomic,assign)int sub;

/**
 截屏
 */
@property(nonatomic,assign)BOOL snapShot;

/**
 截屏
 */
@property(nonatomic,assign)BOOL isRcord;

/**
 打开视频
 @param sub 辅码流
 */
-(void)openVid:(int)sub;

/**
 默认openaud为01，关闭音频
 */
@property(nonatomic,assign)int openaud;
/**
 打开音频
 @param openaud 是否打开音频
 */
-(void)openAud:(int)openaud;

/**
 关闭视频
 */
-(void)closeVid;
@property (nonatomic, weak) id<VidViewModelDelegate> delegate;


/**
 开始对讲
 */
-(void)talkBegin;

/**
 结束对讲
 */
-(void)talkEnd;


/**
 是否正在对讲标志位
 */
@property(nonatomic,assign)BOOL isTalking;

/****************录像***********************/

/**
 改变录像状态

 @return YES-正在录像 NO-停止录像
 */
-(BOOL)changeRecordStatus;

/**
 云台控制

 @param ptzType <#ptzType description#>
 */
-(void)ptzControl:(PtzControlType)ptzType;
-(void)destroyVidSelfPoint;

/**
 获取门控制配置
 */
-(RACSignal *)racGetDoorConfig;

@property(nonatomic,strong) NSMutableArray*doorCfgArray;
/**
 设置门控制
 */
-(RACSignal *)racSetDoorConfig;

/**
 设置门控制
 */
-(RACSignal *)racHandleDoorControl:(NSInteger)channel cmd:(NSInteger)cmd;//门锁控制
@end
