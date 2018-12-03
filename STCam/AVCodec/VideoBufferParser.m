//
//  VideoBufferParser.m
//  SouthCamCut
//
//  Created by guyunlong on 5/5/16.
//  Copyright © 2016 south. All rights reserved.
//  解析 sps ，pps 初始化解码器

#import "VideoBufferParser.h"
#import "VideoDecoder.h"
#import <UIKit/UIKit.h>
@interface VideoBufferParser ()
@property (strong, nonatomic)  VideoDecoder *decoder;
@end
@implementation VideoBufferParser
-(id)init{
    self = [super init];
    if (self) {
        _decoder = [VideoDecoder new];
    }
    return self;
}
-(BOOL)parseFrame:(uint8_t*)buf len:(int)len{
    //主要是解析idr前面的sps pps
    int last = 0;
    for (int i = 2; i <= len; ++i){
        if (i == len) {
            if (last) {
                [self decodeFrame:buf+last len:i - last];
            }
        } else if (buf[i - 2]== 0x00 && buf[i - 1]== 0x00 && buf[i] == 0x01) {
            if (last) {
                int size = i - last - 3;
                if (buf[i - 3]) ++size;
                [self decodeFrame:buf + last len:size];
            }
            last = i + 1;
        }
    }
    return true;
}
-(BOOL)decodeFrame:(uint8_t*)buf len:(int)len{
    CVPixelBufferRef pixelBuffer = NULL;
    switch (buf[0] & 0x1f){
        case 7: // SPS
            NSLog(@"sps len is %d",len);
            [_decoder setSps:buf size:len];
            break;
            
        case 8: // PPS
            NSLog(@"pps len is %d",len);
            [_decoder setPps:buf size:len];
            break;
            
        case 5:
            NSLog(@"idr len is %d",len);
            if([_decoder initH264Decoder]) {
               pixelBuffer =  [_decoder decode:buf size:len];
            }
            break;
        case 1:
            NSLog(@"B/P len is %d",len);
              pixelBuffer = [_decoder decode:buf size:len];
            break;
            
        default:
            break;
    }
    if(pixelBuffer) {
    
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (_delegate && [_delegate respondsToSelector:@selector(updateVidView:)]) {
                [_delegate updateVidView:pixelBuffer];
            }
        });
        CVPixelBufferRelease(pixelBuffer);
    }
    return true;
}
-(void)clearDecoder{
    [_decoder clearH264Deocder];
}
@end
