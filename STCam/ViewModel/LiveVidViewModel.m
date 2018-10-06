//
//  LiveVidViewModel.m
//  STCam
//
//  Created by guyunlong on 10/6/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "LiveVidViewModel.h"
#import "VideoBufferParser.h"
#import "PrefixHeader.h"
@interface LiveVidViewModel ()<VideoBufferParserDelegate>
@property (strong, nonatomic)  VideoBufferParser *parser;
@end
@implementation LiveVidViewModel
//数据回调

void * vidSelf;

void avRealTimeCallBack(void *UserCustom,         //用户自定义数据
                        i32 Chl, char *Buf,                //音视频解码前帧数据
                        i32 Len,                  //数据长度
                        int IsIFrame)
{
    if (vidSelf != NULL){
        LiveVidViewModel *myself = (__bridge LiveVidViewModel * ) vidSelf;
        printf("vid receive buf len is %d\n",Len);
         [myself.parser parseFrame:(uint8_t*)Buf len:Len];
    }
   
    
}

void avAuddioCallBack(void *UserCustom,         //用户自定义数据
                             i32 Chl, char *Buf,                //音视频解码前帧数据
                             i32 Len                   //数据长度
){
    printf("aud receive buf len is %d\n",Len);
}

void alarmRealTimeCallBack(int AlmType, int AlmTime, int AlmChl, void* UserCustom)
{
    
}

-(id)init{
    self = [super init];
    if (self) {
        vidSelf = (__bridge void *)(self);
    }
    return self;
}

-(void)openVid:(int)sub{
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        //
        bool ret = thNet_SetCallBack(self.model.NetHandle, avRealTimeCallBack,avAuddioCallBack, NULL, (void*)self.model.NetHandle);
        if (ret) {
            ret = thNet_Play((HANDLE) self.model.NetHandle, 1-sub, 0,sub, 0);;//
        }
        
        
    });
    
    
}

#pragma mark - VideoBufferParserDelegate
- (void)updateVidView:(CVPixelBufferRef)pixelBuffer{
    if (_delegate && [_delegate respondsToSelector:@selector(updateVidView:)]) {
        [_delegate updateVidView:pixelBuffer];
        //        if (_capture || !_caputureFirst) {
        //
        //            CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
        //
        //            CIContext *temporaryContext = [CIContext contextWithOptions:nil];
        //            CGImageRef videoImage = [temporaryContext
        //                                     createCGImage:ciImage
        //                                     fromRect:CGRectMake(0, 0,
        //                                                         CVPixelBufferGetWidth(pixelBuffer),
        //                                                         CVPixelBufferGetHeight(pixelBuffer))];
        //
        //            UIImage *image = [UIImage imageWithCGImage:videoImage];
        //            // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        //            CGImageRelease(videoImage);
        //            //图片名称
        //            NSDate * date = [NSDate date];
        //            NSTimeInterval intever = [[NSDate date] timeIntervalSince1970];
        //            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //            NSString *dateString = [dateFormatter stringFromDate:date];
        //
        //        }
    }
}

@end
