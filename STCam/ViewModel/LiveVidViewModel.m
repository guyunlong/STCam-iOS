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
#import "TFun.h"
#import "AudioSession.h"
#import "STFileManager.h"
@interface LiveVidViewModel ()<VideoBufferParserDelegate>
@property (strong, nonatomic)  VideoBufferParser *parser;
@property (strong, nonatomic)  AudioSession *audioSession;
@property (assign, nonatomic)  BOOL refreshSnapShot;//每次采集一张图片,用作首页设备图片刷新用,
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
    
    LiveVidViewModel *myself = (__bridge LiveVidViewModel * ) vidSelf;
    if (myself.openaud && !myself.isTalking) {
        [myself.audioSession playAudio:Buf length:Len];
    }
    
}

void alarmRealTimeCallBack(int AlmType, int AlmTime, int AlmChl, void* UserCustom)
{
    
}

-(id)init{
    self = [super init];
    if (self) {
        vidSelf = (__bridge void *)(self);
        _parser = [VideoBufferParser new];
        [_parser setDelegate:self];
        _sub = 1;
        _openaud = 0;
        
        _refreshSnapShot = 0;
        
        _audioSession = [[AudioSession alloc] initAudio];
        UInt32 category = kAudioSessionCategory_PlayAndRecord;
        OSStatus error;
        ;
        error = AudioSessionInitialize(NULL, NULL, NULL, NULL);
        error =  AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
        [_audioSession initRecordAudio];
        if (error) NSLog(@"couldn't set audio category!,error is");
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
            ret = thNet_Play((HANDLE) self.model.NetHandle, 1-sub, self.openaud,sub, 0);;//
        }
        [self.parser clearDecoder];
        
    });
    
    
}

-(void)openAud:(int)openaud{
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        //
        thNet_Play((HANDLE) self.model.NetHandle,1-self.sub, openaud,self.sub, 0);
    });
}
-(void)closeVid{
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        thNet_Stop((HANDLE) self.model.NetHandle);
       // thNet_TalkClose(HANDLE) self.model.NetHandle);
        
    });
    
    
}

#pragma mark - VideoBufferParserDelegate
- (void)updateVidView:(CVPixelBufferRef)pixelBuffer{
    if (_delegate && [_delegate respondsToSelector:@selector(updateVidView:)]) {
        [_delegate updateVidView:pixelBuffer];
        if (!_refreshSnapShot) {
            STFileManager * manager = [STFileManager sharedManager];
            if (![manager fileExistsForUrl:@"Thumbnail"]) {
                [manager createDirectoryNamed:@"Thumbnail"];
            }
            NSString * fileName = [manager localPathForFile:[NSString stringWithFormat:@"%@.png",self.model.SN] inDirectory:@"Thumbnail"];
            BOOL ret = [self snapshot:pixelBuffer fileName:fileName];
            if (ret) {
                _refreshSnapShot = YES;
            }
        }
        if (_snapShot) {
            STFileManager * manager = [STFileManager sharedManager];
            if (![manager fileExistsForUrl:@"snapshot"]) {
                [manager createDirectoryNamed:@"snapshot"];
            }
            if (![manager fileExistsForUrl:[NSString stringWithFormat:@"snapshot/%@",_model.SN]]) {
                [manager createDirectoryNamed:[NSString stringWithFormat:@"snapshot/%@",_model.SN]];
            }
            NSTimeInterval timeInterVal = [[NSDate date] timeIntervalSince1970];
            NSString * fileName = [manager localPathForFile:[NSString stringWithFormat:@"%ld.png",(NSInteger)timeInterVal] inDirectory:[NSString stringWithFormat:@"snapshot/%@",_model.SN]];
            BOOL ret = [self snapshot:pixelBuffer fileName:fileName];
            if (ret) {
                _snapShot = NO;
            }
        }
    }
}
-(BOOL)snapshot:(CVPixelBufferRef)pixelBuffer fileName:(NSString*)fullFileName{
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(pixelBuffer),
                                                 CVPixelBufferGetHeight(pixelBuffer))];
    
    UIImage *image = [UIImage imageWithCGImage:videoImage];
   
    CGImageRelease(videoImage);
    //图片名称
    
    NSData *data = UIImageJPEGRepresentation(image,0.8);
    BOOL result = [data writeToFile: fullFileName    atomically:YES];
    return result;
}
/**
 开始对讲
 */
-(void)talkBegin{
    _isTalking = YES;
    [_audioSession setNetHandle:_model.NetHandle];
    [_audioSession reStartRecord];
}

/**
 结束对讲
 */
-(void)talkEnd{
    _isTalking = NO;
    [_audioSession pauseRecord];
}

@end
