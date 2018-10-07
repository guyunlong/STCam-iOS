//
//  LiveVidViewModel.h
//  STCam
//
//  Created by guyunlong on 10/6/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"
@protocol VidViewModelDelegate <NSObject>
- (void)updateVidView:(CVPixelBufferRef)pixelBuffer;
@end

@interface LiveVidViewModel : NSObject
@property(nonatomic,strong)DeviceModel*model;

/**
 默认sub为1，播放辅码流
 */
@property(nonatomic,assign)int sub;

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
@end
