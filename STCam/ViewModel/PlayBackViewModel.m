//
//  PlayBackViewModel.m
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "PlayBackViewModel.h"
#import "PrefixHeader.h"
#import "AudioSession.h"
#import "VideoBufferParser.h"

static  int PS_Play = 1;          //播放
static  int PS_Pause = 2;         //暂停
@interface PlayBackViewModel()<VideoBufferParserDelegate>
@property (strong, nonatomic)  VideoBufferParser *parser;
@property (strong, nonatomic)  AudioSession *audioSession;
@end
@implementation PlayBackViewModel

//数据回调

void * playbackVidSelf;

void avRemoteCallBack(void *UserCustom,         //用户自定义数据
                        i32 Chl, char *Buf,                //音视频解码前帧数据
                        i32 Len,                  //数据长度
                        int IsIFrame)
{
    if (playbackVidSelf != NULL){
        PlayBackViewModel *myself = (__bridge PlayBackViewModel * ) playbackVidSelf;
        printf("vid receive buf len is %d\n",Len);
        [myself.parser parseFrame:(uint8_t*)Buf len:Len];
    }
    
    
}

void avRemoteAuddioCallBack(void *UserCustom,         //用户自定义数据
                      i32 Chl, char *Buf,                //音视频解码前帧数据
                      i32 Len                   //数据长度
){
    printf("aud receive buf len is %d\n",Len);
    if (playbackVidSelf) {
        PlayBackViewModel *myself = (__bridge PlayBackViewModel * ) playbackVidSelf;
        [myself.audioSession playAudio:Buf length:Len];
    }
    
}

-(id)init{
    self = [super init];
    if (self) {
        playbackVidSelf = (__bridge void *)(self);
        _parser = [VideoBufferParser new];
        [_parser setDelegate:self];
        _audioSession = [[AudioSession alloc] initAudio];
        UInt32 category = kAudioSessionCategory_PlayAndRecord;
        OSStatus error;
        ;
        error = AudioSessionInitialize(NULL, NULL, NULL, NULL);
        error =  AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
        if (error) NSLog(@"couldn't set audio category!,error is");
    }
    return self;
}
-(void)dealloc{
    playbackVidSelf = NULL;
}

-(void)destoryVidSelfPoint{
     playbackVidSelf = NULL;
}
-(void)stopPlayRemoteFile{
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
       thNet_RemoteFileStop((HANDLE) self.deviceModel.NetHandle);
        
    });
}
-(void)playRemoteFile{
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        //
        BOOL ret = thNet_SetCallBack(self.deviceModel.NetHandle, avRemoteCallBack,avRemoteAuddioCallBack, NULL, (void*)self.deviceModel.NetHandle);
        if (ret) {
            ret = thNet_RemoteFilePlay((HANDLE) self.deviceModel.NetHandle, (char*)[self.videoModel.sdVideo UTF8String]);
        }
        [self.parser clearDecoder];
        
    });
}
-(void)playControlRemoteFile:(BOOL)play{
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        if(play){
            //PS_Play
            thNet_RemoteFilePlayControl(self.deviceModel.NetHandle, PS_Play, 0,0);
        }
        else{
            thNet_RemoteFilePlayControl(self.deviceModel.NetHandle, PS_Pause, 0,0);
        }
       
        
    });
}

#pragma mark - VideoBufferParserDelegate
- (void)updateVidView:(CVPixelBufferRef)pixelBuffer{
    if (_delegate && [_delegate respondsToSelector:@selector(updateVidView:)]) {
        [_delegate updateVidView:pixelBuffer];
    }
}

@end
