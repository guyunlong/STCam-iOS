//
//  Audio.m
//  SouIpcam
//
//  Created by root on 2/28/13.
//  Copyright (c) 2013 gyl. All rights reserved.
//

#import "AudioSession.h"
#import "PrefixHeader.h"
@implementation AudioSession

@synthesize queue;
@synthesize audioRecordQueue;
@synthesize NetHandle;

static UInt32 gBufferSizeBytes=0x800;
circular_buffer *outrb;
short *nextBuffer;
unsigned nextSize;
bool _isplay[NUM_BUFFERS];

circular_buffer *inrb;
bool audioset;

void * audSelf;
static void BufferCallback(void *inUserData,AudioQueueRef inAQ,                         AudioQueueBufferRef buffer){
   
   
        if (audSelf == NULL) {
            return;
        }
        AudioSession* player=(__bridge AudioSession*)audSelf;
        if (!audioset) {
            audioset = true;
            [player resetOutputTarget];
        }
        
        //printf("=================== %d\n",[player bufferByteSize]);
        UInt32 numBytes;
        //写进buffer
        
        int index;
        for(int i=0;i<NUM_BUFFERS;i++)
        {
            if(player->buffers[i] == buffer)
                index = i;
            
        }
        
        int len = read_circular_buffer_bytes(outrb, nextBuffer,nextSize);
        DDLogDebug(@"333333333333333333 read buf is %d,circle size is %d",len,outrb->wp);
        if (len > 0) {
            // DDLogDebug(@"back 1111111111111");
            memcpy(buffer->mAudioData, nextBuffer, nextSize);
            buffer->mAudioDataByteSize = len;
            AudioQueueEnqueueBuffer(inAQ, buffer, 0, NULL);
        } else {
            _isplay[index] = false;
            int cnt = 0;
            for (int i=0; i<NUM_BUFFERS; i++) {
                if (!_isplay[i]) {
                    cnt++;
                }
            }
            
            // DDLogDebug(@"back 2222222222222");
            if (cnt == NUM_BUFFERS) {
                AudioQueueStop(inAQ, true);
            }
            
        }
    
    
    
    
}

-(void)dealloc{
    audSelf = NULL;
}

- (BOOL)hasHeadset {
#if TARGET_IPHONE_SIMULATOR
#warning *** Simulator mode: audio session code works only on a device
    return NO;
#else
    CFStringRef route;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route);
    if((route == NULL) || (CFStringGetLength(route) == 0)){
        // Silent Mode
        DDLogDebug(@"AudioRoute: SILENT, do nothing!");
    } else {
        NSString* routeStr = (__bridge NSString*)route;
        DDLogDebug(@"AudioRoute: %@", routeStr);
        
        NSRange headphoneRange = [routeStr rangeOfString : @"Headphone"];
        NSRange headsetRange = [routeStr rangeOfString : @"Headset"];
        if (headphoneRange.location != NSNotFound) {
            return YES;
        } else if(headsetRange.location != NSNotFound) {
            return YES;
        }
    }
    return NO;
#endif
    
}

- (void)resetOutputTarget {
   // BOOL hasHeadset = [self hasHeadset];
    BOOL hasHeadset = NO;

    DDLogDebug (@"Will Set output target is_headset = %@ .", hasHeadset ? @"YES" : @"NO");
    UInt32 audioRouteOverride = hasHeadset ?
kAudioSessionOverrideAudioRoute_None:kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
}





//音频播放方法的实现
-(id) initAudio{
    if (!(self=[super init])) return nil;
    int i;
    audioset = false;
    audSelf = (__bridge void *)(self);
    //取得音频数据格式
//    {
//        dataFormat.mSampleRate=8000;//采样频率
//        dataFormat.mFormatID=kAudioFormatLinearPCM;
//        dataFormat.mFormatFlags=kLinearPCMFormatFlagIsBigEndian
//        | kAudioFormatFlagIsPacked;;
//        dataFormat.mBytesPerFrame=2;
//        dataFormat.mBytesPerPacket=2;
//        dataFormat.mFramesPerPacket=1;//wav 通常为1
//        dataFormat.mChannelsPerFrame=1;//通道数
//        dataFormat.mBitsPerChannel=16;//采样的位数
//        dataFormat.mReserved=1;
//    }
    
    dataFormat.mSampleRate = 8000.0f;
    dataFormat.mFormatID = kAudioFormatLinearPCM;
    dataFormat.mFramesPerPacket = 1;
    dataFormat.mChannelsPerFrame = 1;
    dataFormat.mBytesPerFrame = 2;
    dataFormat.mBytesPerPacket = 2;
    dataFormat.mBitsPerChannel = 16;
    dataFormat.mReserved = 0;
    dataFormat.mFormatFlags =
    kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    //创建播放用的音频队列
    AudioQueueNewOutput(&dataFormat, BufferCallback, (__bridge void * _Nullable)(self),nil, nil, 0, &queue);
    
    for (i=0; i<NUM_BUFFERS; i++) {
        int result = AudioQueueAllocateBuffer(queue, gBufferSizeBytes, &buffers[i]);
        _isplay[i] = false;
        
    }
    
    [self resetOutputTarget];
    Float32 gain=2.0;
    //设置音量
    //AudioQueueSetParameter(queue, kAudioQueueParam_Volume, gain);
    //[[MPMusicPlayerController applicationMusicPlayer] setVolume:1.0];
    
    //队列处理开始，此后系统开始自动调用回调(Callback)函数
    
    
    outrb = create_circular_buffer(2048*sizeof(short)*2000);
    
    nextBuffer = (short *) malloc ( sizeof(short) * 2048 );
    
    nextSize = 2048;
    return self;
    
}
-(void)pauseRecord
{
    AudioQueuePause(audioRecordQueue);
}
-(void)reStartRecord
{
    AudioQueueStart(audioRecordQueue, NULL);
}
-(void)playAudio:(char *)Buf length:(int)len
{
   　//  DDLogDebug(@"audio play buffer size is %d",checkspace_circular_buffer(outrb, 0));
    
    int cnt = 0;
    for (int i=0; i<NUM_BUFFERS; i++) {
        if (!_isplay[i]) {
            cnt++;
        }
    }
    
    if (NUM_BUFFERS == cnt)
    {
        int size = write_circular_buffer_bytes(outrb, Buf,len);
        if ( checkspace_circular_buffer(outrb, 0)>=0x1800) {
            
            AudioQueueStart(queue, nil);
           // DDLogDebug(@"~~~~~~~~\n");
            for (int i=0; i<NUM_BUFFERS; i++)
                _isplay[i] = true;
            for (int i=0; i<NUM_BUFFERS; i++) {
                BufferCallback((__bridge void *)(self), queue, buffers[i]);
            }
        }
    }
    else
    {
       // DDLogDebug(@"+++++++++++\n");
        int size = write_circular_buffer_bytes(outrb, Buf,len);
        //DDLogDebug(@"2222222222 size is %d\n",size);
    }
   // printf("writen size is %d\n",checkspace_circular_buffer(outrb, 0));
    
}




-(void)initRecordAudio
{
    audioRecordDescription.mSampleRate=8000;//采样频率
    audioRecordDescription.mFormatID=kAudioFormatLinearPCM;
    audioRecordDescription.mFormatFlags=kAudioFormatFlagIsSignedInteger;
    audioRecordDescription.mBytesPerFrame=2;
    audioRecordDescription.mBytesPerPacket=2;
    audioRecordDescription.mFramesPerPacket=1;//wav 通常为1
    audioRecordDescription.mChannelsPerFrame=1;//通道数
    audioRecordDescription.mBitsPerChannel=16;//采样的位数

    
    ///设置音频参数
//    audioRecordDescription.mSampleRate = 8000;//采样率
//    audioRecordDescription.mFormatID = kAudioFormatLinearPCM;
//    audioRecordDescription.mFormatFlags = kAudioFormatFlagIsSignedInteger;
//    audioRecordDescription.mChannelsPerFrame = 1;///单声道
//    audioRecordDescription.mFramesPerPacket = 1;//每一个packet一侦数据
//    audioRecordDescription.mBitsPerChannel = 16;//每个采样点16bit量化
//    audioRecordDescription.mBytesPerFrame = (audioRecordDescription.mBitsPerChannel/8) * audioRecordDescription.mChannelsPerFrame;
//    audioRecordDescription.mBytesPerPacket = audioRecordDescription.mBytesPerFrame ;
    
    
    AudioQueueNewInput(&audioRecordDescription, MyInputBufferHandler, (__bridge void * _Nullable)(self), nil, nil, 0, &audioRecordQueue );
    ////添加buffer区
    for(int i=0;i<NUM_RECBUFFERS;i++)
    {
        int result =  AudioQueueAllocateBuffer(audioRecordQueue, MIN_SIZE_PER_FRAME, &audioRecordQueueBuffers[i]);///创建buffer区，MIN_SIZE_PER_FRAME为每一侦所需要的最小的大小，该大小
    }
    
   // AudioQueueStart(audioRecordQueue, NULL);
    
    for(int i=0;i<NUM_RECBUFFERS;i++)
    {
        AudioQueueEnqueueBuffer(audioRecordQueue, audioRecordQueueBuffers[i], 0, NULL);
    }
    
 //   inrb = create_circular_buffer(2048*sizeof(short)*2000);
    
    
}
static void MyInputBufferHandler(	void *								inUserData,
                                 AudioQueueRef						inAQ,
                                 AudioQueueBufferRef					inBuffer,
                                 const AudioTimeStamp *				inStartTime,
                                 UInt32								inNumPackets,
                                 const AudioStreamPacketDescription*	inPacketDesc)
{
    AudioSession* session=(__bridge AudioSession*)inUserData;
   // static FILE* f = NULL;
   //  if (!f) f = fopen("/Users/ky/Desktop/bbbb.pcm", "w+b");
    
    NSInteger len=inBuffer->mAudioDataByteSize;
    uint8_t *data=(uint8_t*)inBuffer->mAudioData;
     DDLogDebug(@"-------record size:%ld",len);
    //fwrite(data, len, 1, f);
    net_SetTalk((HANDLE)session.NetHandle,(char*) data,(int32_t)len);
    
   // int size = write_circular_buffer_bytes(inrb, data,len);
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}
-(int)readbuf:(char*)Buf length:(int)len
{
    // DDLogDebug("inrb len is %d",inrb->wp);
    if (checkspace_circular_buffer(inrb, 0)>1024) {
        int readlen =  read_circular_buffer_bytes(inrb, Buf,len);
        return  readlen;
    }
    else
    {
        return -1;
    }
    
    
}



-(void)delloc
{
    AudioQueueStop(queue, true);
    AudioQueueStop(audioRecordQueue, true);
    free_circular_buffer(outrb);
    
}
circular_buffer* create_circular_buffer(int bytes){
    circular_buffer *p;
    if ((p = calloc(1, sizeof(circular_buffer))) == NULL) {
        return NULL;
    }
    p->size = bytes;
    p->wp = p->rp = 0;
    
    if ((p->buffer = calloc(bytes, sizeof(char))) == NULL) {
        free (p);
        return NULL;
    }
    return p;
}
int checkspace_circular_buffer(circular_buffer *p, int writeCheck){
    int wp = p->wp, rp = p->rp, size = p->size;
    if(writeCheck){
        if (wp > rp) return rp - wp + size - 1;
        else if (wp < rp) return rp - wp - 1;
        else return size - 1;
    }
    else {
        if (wp > rp) return wp - rp;
        else if (wp < rp) return wp - rp + size;
        else return 0;
    }
}
int read_circular_buffer_bytes(circular_buffer *p, char *out, int bytes){
    int remaining;
    int bytesread, size = p->size;
    int i=0, rp = p->rp;
    char *buffer = p->buffer;
    if ((remaining = checkspace_circular_buffer(p, 0)) == 0) {
        return 0;
    }
    bytesread = bytes > remaining ? remaining : bytes;
    for(i=0; i < bytesread; i++){
        out[i] = buffer[rp++];
        if(rp == size) rp = 0;
    }
    p->rp = rp;
    return bytesread;
}
int write_circular_buffer_bytes(circular_buffer *p, const char *in, int bytes){
    int remaining;
    int byteswrite, size = p->size;
    int i=0, wp = p->wp;
    char *buffer = p->buffer;
    if ((remaining = checkspace_circular_buffer(p, 1)) == 0) {
        return 0;
    }
    byteswrite = bytes > remaining ? remaining : bytes;
    for(i=0; i < byteswrite; i++){
        buffer[wp++] = in[i];
        if(wp == size) wp = 0;
    }
    p->wp = wp;
    return byteswrite;
}
void free_circular_buffer (circular_buffer *p){
    if(p == NULL) return;
    free(p->buffer);
    free(p);
}
@end
