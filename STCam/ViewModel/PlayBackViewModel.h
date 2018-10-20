//
//  PlayBackViewModel.h
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDVideoModel.h"
#import "DeviceModel.h"
@protocol PlayBackVidViewModelDelegate <NSObject>
- (void)updateVidView:(CVPixelBufferRef)pixelBuffer;
@end

@interface PlayBackViewModel : NSObject
@property(nonatomic,strong)SDVideoModel * videoModel;
@property(nonatomic,strong)DeviceModel * deviceModel;
@property(nonatomic,assign)BOOL isPlay;
-(void)playRemoteFile;
-(void)stopPlayRemoteFile;
-(void)playControlRemoteFile:(BOOL)play;
@property (nonatomic, weak) id<PlayBackVidViewModelDelegate> delegate;
@end
