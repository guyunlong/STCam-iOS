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
-(void)openVid:(int)sub;
@property (nonatomic, weak) id<VidViewModelDelegate> delegate;
@end
