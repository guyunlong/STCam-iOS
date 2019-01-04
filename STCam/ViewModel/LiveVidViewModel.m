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
#import "RetModel.h"

@interface LiveVidBufferModel(){
    char * buf;
    int len;
}
@end
@implementation LiveVidBufferModel
-(void)setBuffer:(char*)buffer size:(int)size{
    len = size;
    buf = malloc(size);
    memcpy(buf, buffer, size);
}
-(char*)getBuffer{
    return buf;
}
-(int)getBufLen{
    return len;
}
-(void)deallocBuf{
    free(buf);
    buf = nil;
    len = 0;
}

@end


@interface LiveVidViewModel ()<VideoBufferParserDelegate>
@property (strong, nonatomic)  VideoBufferParser *parser;
@property (strong, nonatomic)  AudioSession *audioSession;
@property (assign, nonatomic)  BOOL refreshSnapShot;//每次采集一张图片,用作首页设备图片刷新用,
@property(assign,nonatomic)int screenWidth;
@property(assign,nonatomic)int screenHeight;
@property (strong, nonatomic)  NSMutableArray *queneArray;
@property(nonatomic,assign)BOOL getQueneBufferStauts;
@end
@implementation LiveVidViewModel
//数据回调
pthread_mutex_t th_mutex_lock;
void * vidSelf;

void avRealTimeCallBack(void *UserCustom,         //用户自定义数据
                        i32 Chl, char *Buf,                //音视频解码前帧数据
                        i32 Len,                  //数据长度
                        int IsIFrame)
{
    if (vidSelf != NULL){
        LiveVidViewModel *myself = (__bridge LiveVidViewModel * ) vidSelf;
        printf("vid receive buf len is %d\n",Len);
      //   [myself.parser parseFrame:(uint8_t*)Buf len:Len];
        LiveVidBufferModel * model  = [LiveVidBufferModel new];
        [model setBuffer:Buf size:Len];
       // NSLog(@"pthread_mutex_lock begin 2");
            pthread_mutex_lock(&th_mutex_lock);
        NSInteger length  =[myself.queneArray count];
            [myself.queneArray insertObject:model atIndex:length];
            pthread_mutex_unlock(&th_mutex_lock);
       // NSLog(@"pthread_mutex_lock end 2");
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
        _queneArray = [NSMutableArray new];
        pthread_mutex_init(&th_mutex_lock, NULL);
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
            // NSLog(@"pthread_mutex_lock begin 1");
            pthread_mutex_lock(&th_mutex_lock);
            [self.queneArray removeAllObjects];
            NSLog(@"clearH264Deocder --------- from openVid");
            [self.parser clearDecoder];
            pthread_mutex_unlock(&th_mutex_lock);
           //  NSLog(@"pthread_mutex_lock end 1");
            ret = thNet_Play((HANDLE) self.model.NetHandle, 1-sub, self.openaud,sub, 0);;//
        }
       
        
    });
    
    [self startGetQueneBuffer];
    
}
-(void)startGetQueneBuffer{
    _getQueneBufferStauts = YES;
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        //
        while (self.getQueneBufferStauts) {
           // NSLog(@"pthread_mutex_lock begin 0");
           pthread_mutex_lock(&th_mutex_lock);
            if ([self.queneArray count] > 0) {
                
                LiveVidBufferModel * model =self.queneArray[0];
                [self.parser parseFrame:(uint8_t*)[model getBuffer] len:[model getBufLen]];
                NSLog(@"queneArray count is %ld",[self.queneArray count]);
                [self.queneArray removeObject:model];
                [model deallocBuf];
                
                
            }
            pthread_mutex_unlock(&th_mutex_lock);
           // NSLog(@"pthread_mutex_lock end 0");
        }
    });
    
}
-(void)destroyVidSelfPoint{
    vidSelf = NULL;
    _getQueneBufferStauts = NO;
}
-(void)dealloc{
    vidSelf = NULL;
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
    _screenWidth =(int)CVPixelBufferGetWidth(pixelBuffer);
    _screenHeight =(int)CVPixelBufferGetHeight(pixelBuffer);
    
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
    thNet_TalkOpen(_model.NetHandle);
    [_audioSession setNetHandle:_model.NetHandle];
    [_audioSession reStartRecord];
}

/**
 结束对讲
 */
-(void)talkEnd{
    thNet_TalkClose(_model.NetHandle);
    _isTalking = NO;
    [_audioSession pauseRecord];
}

/**
 改变录像状态
 
 @return YES-正在录像 NO-停止录像
 */
-(BOOL)changeRecordStatus{
    if (thNet_IsRec(_model.NetHandle)) {
        //停止录像
        thNet_StopRec(_model.NetHandle);
        return NO;
    }
    else{
        //打开录像
        STFileManager * manager = [STFileManager sharedManager];
        //录像文件名称
        if (![manager fileExistsForUrl:@"record"]) {
            [manager createDirectoryNamed:@"record"];
        }
        if (![manager fileExistsForUrl:[NSString stringWithFormat:@"record/%@",_model.SN]]) {
            [manager createDirectoryNamed:[NSString stringWithFormat:@"record/%@",_model.SN]];
        }
        NSTimeInterval timeInterVal = [[NSDate date] timeIntervalSince1970];
        NSString * fileName = [manager localPathForFile:[NSString stringWithFormat:@"%ld.mp4",(NSInteger)timeInterVal] inDirectory:[NSString stringWithFormat:@"record/%@",_model.SN]];
        thNet_Play_OnlySend(_model.NetHandle);
        thNet_StartRec(_model.NetHandle, [fileName UTF8String],_screenWidth,_screenHeight);
        return YES;
    }
}

-(void)ptzControl:(PtzControlType)ptzType{
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(quene, ^{
        NSString * url = [NSString stringWithFormat:@"%@&cmd=%d&sleep=500",[self.model getDevURL:Msg_PTZControl],(int)ptzType];
        
        id data = [self.model thNetHttpGet:url];
        if([data isKindOfClass:[NSDictionary class]]){
            RetModel * model = [RetModel RetModelWithDict:data];
            if (model.ret == 1) {
                NSLog(@"ptz ctl succtss");
            }
            else{
                NSLog(@"ptz ctl failed");
            }
        }
    });
    
}

/**
 获取门控制配置
 */
-(RACSignal *)racGetDoorConfig{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@",[self.model getDevURL:Msg_GetPowerTimerCfg]];
            
            id data = [self.model thNetHttpGet:url];
            if ([data isKindOfClass:[NSArray class]]) {
                if (!self.doorCfgArray) {
                    self.doorCfgArray = [[NSMutableArray alloc] init];
                }
                else{
                    [self.doorCfgArray removeAllObjects];
                }
                for (NSDictionary * dic in data) {
                    DoorCfgModel * model = [DoorCfgModel DoorCfgModelWithDict:dic];
                    [self.doorCfgArray addObject:model];
                }
                [subscriber sendNext:@1];
            }
            else{
                [subscriber sendNext:0];//
            }
        });
        
        return nil;
    }];
}

/**
 设置门控制
 */
-(RACSignal *)racSetDoorConfig{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSMutableString * url = [NSMutableString stringWithFormat:@"%@",[self.model getDevURL:Msg_SetDoorCfg]];
            for (NSInteger index = 0;index<[self.doorCfgArray count];index++) {
                DoorCfgModel * model =self.doorCfgArray[index];
                [url appendString:[NSString stringWithFormat:@"&Active%ld=%ld&Name%ld=%@",index,model.Active,index,model.Name]];
            }
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                RetModel * model = [RetModel RetModelWithDict:data];
                [subscriber sendNext:@(model.ret)];
            }
            else{
                [subscriber sendNext:@0];
            }
        });
        
        return nil;
    }];
}

-(RACSignal *)racHandleDoorControl:(NSInteger)channel cmd:(NSInteger)cmd{
    //http://IP:Port/cfg1.cgi?User=admin&Psd=admin&MsgID=106&Chl=2&Cmd=1
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@&Chl=%ld&Cmd=%ld",[self.model getDevURL:Msg_DoorControl],channel,cmd];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                RetModel * model = [RetModel RetModelWithDict:data];
                [subscriber sendNext:@(model.ret)];
            }
            else{
                [subscriber sendNext:@0];
            }
        });
        
        return nil;
    }];
}

@end
