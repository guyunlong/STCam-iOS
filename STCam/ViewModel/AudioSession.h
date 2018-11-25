//
//  Audio.h
//  SouIpcam
//
//  Created by root on 2/28/13.
//  Copyright (c) 2013 gyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AudioToolbox/AudioToolbox.h>
#include <MediaPlayer/MPMusicPlayerController.h>
#import "libthSDK.h"

#define NUM_BUFFERS 3
#define NUM_RECBUFFERS 2
#define MIN_SIZE_PER_FRAME 512 //每侦最小数据长度
typedef struct _circular_buffer {
    char *buffer;
    int  wp;
    int rp;
    int size;
} circular_buffer;
@interface AudioSession : NSObject{
    AudioStreamBasicDescription dataFormat;
    AudioQueueRef queue;
    UInt32 bufferByteSize;
    uint8_t *inbuf;
    AudioQueueBufferRef buffers[NUM_BUFFERS];
    
    
    
    AudioStreamBasicDescription audioRecordDescription;///音频参数
    AudioQueueRef audioRecordQueue;//音频播放队列
    AudioQueueBufferRef audioRecordQueueBuffers[NUM_RECBUFFERS];//音频缓存
    
    
}


@property AudioQueueRef queue;
@property AudioQueueRef audioRecordQueue;
@property THandle NetHandle;

-(id)initAudio;
-(void)playAudio:(char*)Buf length:(int)len;
-(int)readbuf:(char*)Buf length:(int)len;
-(void)pauseRecord;
-(void)reStartRecord;
-(void)delloc;
static void BufferCallack(void *inUserData,AudioQueueRef inAQ,AudioQueueBufferRef buffer);


static void MyInputBufferHandler(	void *								inUserData,
                                 AudioQueueRef						inAQ,
                                 AudioQueueBufferRef					inBuffer,
                                 const AudioTimeStamp *				inStartTime,
                                 UInt32								inNumPackets,
                                 const AudioStreamPacketDescription*	inPacketDesc);
-(void)initRecordAudio;

circular_buffer* create_circular_buffer(int bytes);
int checkspace_circular_buffer(circular_buffer *p, int writeCheck);
int read_circular_buffer_bytes(circular_buffer *p, char *out, int bytes);
int write_circular_buffer_bytes(circular_buffer *p, const char *in, int bytes);
void free_circular_buffer (circular_buffer *p);

@end
