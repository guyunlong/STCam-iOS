//
//  VideoDecoder.m
//  SouthCamCut
//
//  Created by guyunlong on 5/6/16.
//  Copyright © 2016 south. All rights reserved.
//

#import "VideoDecoder.h"
#import <VideoToolbox/VideoToolbox.h>
@interface VideoDecoder (){
    uint8_t *_sps;
    NSInteger _spsSize;
    uint8_t *_pps;
    NSInteger _ppsSize;
    VTDecompressionSessionRef _deocderSession;
    CMVideoFormatDescriptionRef _decoderFormatDescription;
}
@end
//此回调没有使用
static void didDecompress( void *decompressionOutputRefCon, void *sourceFrameRefCon, OSStatus status, VTDecodeInfoFlags infoFlags, CVImageBufferRef pixelBuffer, CMTime presentationTimeStamp, CMTime presentationDuration ){
    
    CVPixelBufferRef *outputPixelBuffer = (CVPixelBufferRef *)sourceFrameRefCon;
    *outputPixelBuffer = CVPixelBufferRetain(pixelBuffer);
}

@implementation VideoDecoder

-(id)init{
    self = [super init];
    if (self) {
        _deocderSession = nil;
    }
    return self;
}
-(void)setSps:(uint8_t*)sps size:(int)size{
    if (_deocderSession) {
        return;
    }
    _spsSize = size;
    _sps = malloc(_spsSize);
    memcpy(_sps, sps, _spsSize);
}
-(void)setPps:(uint8_t*)pps size:(int)size{
    if (_deocderSession) {
        return;
    }
    _ppsSize = size;
    _pps = malloc(_ppsSize);
    memcpy(_pps, pps, _ppsSize);
}
-(BOOL)initH264Decoder {
    if(_deocderSession) {
        return YES;
    }
    
    const uint8_t* const parameterSetPointers[2] = { _sps, _pps };
    const size_t parameterSetSizes[2] = { _spsSize, _ppsSize };
    OSStatus status = CMVideoFormatDescriptionCreateFromH264ParameterSets(kCFAllocatorDefault,
                                                                          2, //param count
                                                                          parameterSetPointers,
                                                                          parameterSetSizes,
                                                                          4, //nal start code size
                                                                          &_decoderFormatDescription);
    
    if(status == noErr) {
        CFDictionaryRef attrs = NULL;
        const void *keys[] = { kCVPixelBufferPixelFormatTypeKey };
        //      kCVPixelFormatType_420YpCbCr8Planar is YUV420
        //      kCVPixelFormatType_420YpCbCr8BiPlanarFullRange is NV12
        uint32_t v = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
        const void *values[] = { CFNumberCreate(NULL, kCFNumberSInt32Type, &v) };
        attrs = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
        
        VTDecompressionOutputCallbackRecord callBackRecord;
        callBackRecord.decompressionOutputCallback = didDecompress;
        callBackRecord.decompressionOutputRefCon = NULL;
        
        status = VTDecompressionSessionCreate(kCFAllocatorDefault,
                                              _decoderFormatDescription,
                                              NULL, attrs,
                                              &callBackRecord,
                                              &_deocderSession);
        CFRelease(attrs);
    } else {
        NSLog(@"IOS8VT: reset decoder session failed status=%d", status);
        [self clearH264Deocder];
    }
    
    return YES;
}
-(void)clearH264Deocder {
    @synchronized(self){
        NSLog(@"clearH264Deocder -------- 0 ");
        if(_deocderSession) {
            NSLog(@"clearH264Deocder ------ 1");
            
            VTDecompressionSessionInvalidate(_deocderSession);
            CFRelease(_deocderSession);
            _deocderSession = NULL;
        }
        if(_decoderFormatDescription) {
            CFRelease(_decoderFormatDescription);
            _decoderFormatDescription = NULL;
        }
        if (_sps && _spsSize > 0) {
            free(_sps);
            _sps = NULL;
        }
        if (_pps && _ppsSize > 0) {
            free(_pps);
            _pps = NULL;
        }
        _spsSize = _ppsSize = 0;
    }
   
}
-(CVPixelBufferRef)decode:(uint8_t*)buffer size:(int)size {
    if (!_deocderSession) {
        return nil;
    }
    
    uint8_t* buf_addstart = malloc(size+4);
   
    //uint8_t *pNalSize = (uint8_t*)(&size);
    buf_addstart[0] = size>>24 & 0xff;
    buf_addstart[1] = size>>16 & 0xff;
    buf_addstart[2] = size>>8 & 0xff;
    buf_addstart[3] = size & 0xff;
    
    memcpy(buf_addstart+4, buffer, size);
    CVPixelBufferRef outputPixelBuffer = NULL;
    
    CMBlockBufferRef blockBuffer = NULL;
    OSStatus status  = CMBlockBufferCreateWithMemoryBlock(kCFAllocatorDefault,
                                                          (void*)buf_addstart, size+4,
                                                          kCFAllocatorNull,
                                                          NULL, 0,size+4,
                                                          0, &blockBuffer);
    if(status == kCMBlockBufferNoErr) {
        CMSampleBufferRef sampleBuffer = NULL;
        const size_t sampleSizeArray[] = {size+4};
        status = CMSampleBufferCreateReady(kCFAllocatorDefault,
                                           blockBuffer,
                                           _decoderFormatDescription ,
                                           1, 0, NULL, 1, sampleSizeArray,
                                           &sampleBuffer);
        if (status == kCMBlockBufferNoErr && sampleBuffer && _deocderSession != NULL) {
            VTDecodeFrameFlags flags = 0;
            VTDecodeInfoFlags flagOut = 0;
            if (!_deocderSession) {
                return nil;
            }
            OSStatus decodeStatus = VTDecompressionSessionDecodeFrame(_deocderSession,
                                                                      sampleBuffer,
                                                                      flags,
                                                                      &outputPixelBuffer,
                                                                      &flagOut);
            
            if(decodeStatus == kVTInvalidSessionErr) {
                NSLog(@"IOS8VT: Invalid session, reset decoder session");
                [self clearH264Deocder];
            } else if(decodeStatus == kVTVideoDecoderBadDataErr) {
                NSLog(@"IOS8VT: decode failed status=%d(Bad data)", decodeStatus);
            } else if(decodeStatus != noErr) {
                NSLog(@"IOS8VT: decode failed status=%d", decodeStatus);
            }
            
            CFRelease(sampleBuffer);
        }
        CFRelease(blockBuffer);
    }
    if (buf_addstart) {
        free(buf_addstart);
    }
    
    return outputPixelBuffer;
}


@end
