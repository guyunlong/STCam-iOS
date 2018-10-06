//
//  VideoDecoder.h
//  SouthCamCut
//
//  Created by guyunlong on 5/6/16.
//  Copyright © 2016 south. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface VideoDecoder : NSObject
-(BOOL)initH264Decoder;
-(void)clearH264Deocder;
-(CVPixelBufferRef)decode:(uint8_t*)buffer size:(int)size;
-(void)setSps:(uint8_t*)sps size:(int)size;
-(void)setPps:(uint8_t*)pps size:(int)size;

@end
