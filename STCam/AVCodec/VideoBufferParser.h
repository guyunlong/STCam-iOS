//
//  VideoBufferParser.h
//  SouthCamCut
//
//  Created by guyunlong on 5/5/16.
//  Copyright © 2016 south. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol VideoBufferParserDelegate<NSObject>
- (void)updateVidView:(CVPixelBufferRef)pixelBuffer;
@end
@interface VideoBufferParser : NSObject
-(BOOL)parseFrame:(uint8_t*)buf len:(int)len;
-(BOOL)decodeFrame:(uint8_t*)buf len:(int)len;
-(void)clearDecoder;
@property(nonatomic, assign) id<VideoBufferParserDelegate> delegate;
@end
