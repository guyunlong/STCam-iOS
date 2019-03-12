//
//  DeviceModel.m
//  STCam
//
//  Created by guyunlong on 10/5/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "DeviceModel.h"
#import "UIColor+expanded.h"
#import "PrefixHeader.h"
#import "DevListViewModel.h"
#import "CoreDataManager.h"
#import "STFileManager.h"
@interface DeviceModel(){
//    dispatch_queue_t conSerialQueue;
//    dispatch_queue_t disConSerialQueue;
    int reconnectTime;
}
@property(assign)BOOL IsConnecting;
@end
@implementation DeviceModel

-(id)init{
    self = [super init];
    if (self) {
//        conSerialQueue = dispatch_queue_create("com.southtec.cam", DISPATCH_QUEUE_SERIAL);
//        disConSerialQueue = dispatch_queue_create("com.southtec.camdis", DISPATCH_QUEUE_SERIAL);
        _User = @"admin";
        _Pwd = @"admin";
        _FunctionMask = 0xfffffffe;
        _Battery = -1;
    }
    return self;
}
/**
 public final static int IS_CONN_NODEV = 0;
 public final static int IS_CONN_OFFLINE = 1;
 public final static int IS_CONN_LAN = 2;
 public final static int IS_CONN_DDNS = 3;
 public final static int IS_CONN_P2P = 4;
 public final static int IS_CONN_NOWAY = 5;

 */
-(ConnType)getConnectType{
    if ([self.ConnType isEqualToString:@"ConnType_NODEV"]){
        return ConnType_NODEV;
    }
    else if([self.ConnType isEqualToString:@"IS_CONN_OFFLINE"]){
        return ConnType_OFFLINE;
    }
    else if([self.ConnType isEqualToString:@"IS_CONN_LAN"]){
        return ConnType_LAN;
    }
    else if([self.ConnType isEqualToString:@"IS_CONN_DDNS"]){
        return ConnType_DDNS;
    }
    else if([self.ConnType isEqualToString:@"IS_CONN_P2P"]){
        return ConnType_P2P;
    }
    else if([self.ConnType isEqualToString:@"IS_CONN_NOWAY"]){
        return ConnType_NOWAY;
    }
    return ConnType_OFFLINE;
}

-(BOOL)isOnline{
    
    ConnType type = [self getConnectType];
    if (type == ConnType_LAN || type == ConnType_DDNS || type == ConnType_P2P) {
        return YES;
    }
    return NO;
}
-(UIColor*)getConnectColor{
    if (![self IsConnect]) {
        return [UIColor colorWithHexString:@"0xff0000"];
    }
    switch ([self getConnectType]) {
        case ConnType_LAN:
            return [UIColor colorWithHexString:@"0x227711"];
        case ConnType_DDNS:
            return [UIColor colorWithHexString:@"0x0055aa"];
            break;
        case ConnType_P2P:
            return [UIColor colorWithHexString:@"0x00ff00"];
            break;
        default:
            return [UIColor colorWithHexString:@"0xff0000"];
            break;
    }
}
-(NSString*)getOnLineDesc{
    if (![self IsConnect]) {
        return @"OFFLINE";
    }
    
    return [self.ConnType substringFromIndex:@"IS_CONN_".length];
}

+(instancetype)DeviceModelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];//kvc
        _User = @"admin";
        _Pwd = @"admin";
        CoreDataManager * manager = [CoreDataManager sharedManager];
        DeviceModel * model = [manager getDeviceModel:_SN];
        if (model) {
            _Pwd = model.Pwd;
        }
        
//        conSerialQueue = dispatch_queue_create("com.southtec.cam", DISPATCH_QUEUE_SERIAL);
//        disConSerialQueue = dispatch_queue_create("com.southtec.camdis", DISPATCH_QUEUE_SERIAL);
        
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    DDLogDebug(@"%s---%@",__func__,key);
}

/**************设备连接**************/
-(BOOL)IsConnect{
    BOOL ret = NO;
    if (_NetHandle == 0)
    {
        return ret;
    }
    ret = thNet_IsConnect(_NetHandle);
    //TFun.printf(SN + "(" + IPUID + ") thNetIsConnect:" + ret);
    return ret;
}
-(BOOL)Connect;
{
    BOOL ret;
    if ([self.IPUID length] == 0)
    {
        return NO;
    }
    
    if (_IsConnecting && reconnectTime < 2)
    {
        ++reconnectTime;
        return NO;
    }
    
    DDLogDebug(@"-------------------------- Connect device 0,DeviceModel sn %@,User:%@,pwd:%@.ipuid:%@,dataport:%ld,self.NetHandle:%d",[self SN],self.User,self.Pwd,self.IPUID,self.DataPort,self.NetHandle);
    _IsConnecting = YES;
    reconnectTime = 0;
    //thNet_Connect(HANDLE NetHandle, u64 SN, char* UserName, char* Password, char* IPUID, i32 DataPort, u32 TimeOut)
    NSString * logFileName = [[STFileManager sharedManager] localPathForFile:@"log.txt" inDirectory:@""];
    ret = thNet_Connect(self.NetHandle,
                           [_SN integerValue],
                           [self.User UTF8String],
                           [self.Pwd UTF8String],
                           [self.IPUID UTF8String],
                           (int32_t)self.DataPort,
                           [logFileName UTF8String],
                           5 * 1000);
      DDLogDebug(@"-------------------------- Connect device 1,DeviceModel sn %@",[self SN]);
    _IsConnecting = NO;
    return ret;
}
-(void)threadDisconnect{
    
    @weakify(self)
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        [self disconnect];
    });
    
}
-(void)disconnect{
    DDLogDebug(@"------------disconnect  before,sn %@",self.SN);
     DDLogDebug(@"------------disconnect  before 0 ,NetHandle %d",self.NetHandle);
    THandle NetHandle = self.NetHandle;
    self.NetHandle = 0;
    BOOL ret = NO;
    @try
    {
       ret = thNet_DisConn(NetHandle);
    }@catch (NSException * e) {
        DDLogDebug(@"------------disconnect  Exception,exception is %@",e.description);
    }
    DDLogDebug(@"------------disconnect  thNet_DisConn,sn %@,ret is %d",self.SN,ret);
    if (ret)
    {
        
        usleep(200000);

        thNet_Free(NetHandle);

    }
    DDLogDebug(@"------------disconnect  after,sn %@",self.SN);
    
    DevListViewModel * listViewModel = [DevListViewModel sharedDevListViewModel];
    [listViewModel setRefreshView:YES];
    
}
-(void)threadConnect
{
    if ([self IsConnect] && self.SoftVersion){
        return;
    }
    DDLogDebug(@"-------------------------- connect before,DeviceModel sn %@",[self SN]);
    @weakify(self)
    //dispatch_async
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        DDLogDebug(@"-------------------------- connect 0,DeviceModel sn %@",[self SN]);
        if (self.NetHandle == 0) {
            self.NetHandle = thNet_Init(true, false);
        }
        DDLogDebug(@"-------------------------- connect 1,DeviceModel sn %@",[self SN]);
        if (![self IsConnect]) {
             P2P_Init();
            DDLogDebug(@"-------------------------- connect 2,DeviceModel sn %@",[self SN]);
            [self Connect];
            DDLogDebug(@"-------------------------- connect 3,DeviceModel sn %@",[self SN]);
            DevListViewModel * listViewModel = [DevListViewModel sharedDevListViewModel];
            [listViewModel setRefreshView:YES];
        }
        DDLogDebug(@"-------------------------- connect 4,DeviceModel sn %@",[self SN]);
        if ([self IsConnect] && !self.SoftVersion) {
            char conv[1024 * 64];
            char* tmpBuf = NULL;
            conv[0] = 0x00;
            tmpBuf = thNet_GetAllCfg((HANDLE) self.NetHandle);
            code_convert_name("gb2312", "utf8", tmpBuf,strlen(tmpBuf), conv, sizeof(conv));
            NSString * deviceInfoStr  = [[NSString alloc] initWithUTF8String:conv];
            DDLogDebug(@"deviceInfoStr is %@",deviceInfoStr);
            NSData *utf8Data = [deviceInfoStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            id deviceInfoDic = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableLeaves error:&error];
            
            self.ExistSD = [[[deviceInfoDic objectForKey:@"DevInfo"] objectForKey:@"ExistSD"] boolValue];
            self.SoftVersion = [[deviceInfoDic objectForKey:@"DevInfo"] objectForKey:@"SoftVersion"];
            self.DevType =[[[deviceInfoDic objectForKey:@"DevInfo"] objectForKey:@"DevType"] integerValue];
            if([[deviceInfoDic objectForKey:@"DevInfo"] objectForKey:@"FunctionMask"]){
                self.FunctionMask = [[[deviceInfoDic objectForKey:@"DevInfo"] objectForKey:@"FunctionMask"] integerValue];
            }
        }
        
        DDLogDebug(@"threadConnect device end,sn :%@",self.SN);
    });
    
    DDLogDebug(@"-------------------------- connect after,DeviceModel sn %@",[self SN]);
}

-(NSString*)getDevURL:(int)MsgID{
    // return String.format("http://%s:%d/cfg1.cgi?User=%s&Psd=%s&MsgID=%d", IPUID, WebPort, usr, pwd, MsgID);
    return [NSString stringWithFormat:@"http://%@:%ld/cfg1.cgi?User=%@&Psd=%@&MsgID=%d", _IPUID, _WebPort, _User, _Pwd, MsgID];
}

-(id)thNetHttpGet:(NSString*)url{
    int ret;
    int BufLen = 0;
    char Buf[1024 * 64];
    char conv[1024 * 64];
    Buf[0] = 0x00;
    conv[0] = 0x00;
    
    code_convert_name("utf8", "gb2312",(char *) [url UTF8String],strlen([url UTF8String]), conv, sizeof(conv));
    //UcnvConvert_UTF8toGB2312(conv, sizeof(conv), url, &pnErrC);
    
    if (![self IsConnect]) {
        [self Connect];
    }
    if (![self IsConnect]) {
        return nil;
    }
    ret = thNet_HttpGet(_NetHandle, conv, Buf, &BufLen);
    if (ret)
    {
        memset(conv, 0, sizeof(conv));
        //UcnvConvert_GB2312toUTF8(conv, sizeof(conv), Buf, &pnErrC);
        
        code_convert_name("gb2312", "utf8",Buf,strlen(Buf), conv, sizeof(conv));
        //const char* SSID = [self.ssid cStringUsingEncoding:NSASCIIStringEncoding];
        NSString * retStr  = [[NSString alloc] initWithUTF8String:conv];
        DDLogDebug(@"retstr is %@",retStr);
        NSData *utf8Data = [retStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        id retDic = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableLeaves error:&error];
        return retDic;
        
    }
    return nil;
}
    
- (BOOL)BitValue:(NSInteger )s  bit:(int)Bits
{
    return ((s & (1 << Bits)) != 0);
}
    
/**
 灯光控制功能

 @return YES
 */
-(BOOL)FunctionExistsLight
{
    return  [self BitValue:_FunctionMask  bit:FunctionExistsLight];
}
    
/**
 定时开关机控制功能
 
 @return YES
 */
-(BOOL)FunctionExistsTimerPowerOnOff
{
    return  [self BitValue:_FunctionMask  bit:FunctionExistsTimerPowerOnOff];
}
    
/**
门控制功能
 
 @return YES
 */
-(BOOL)FunctionExistsDoorControl
{
    return  [self BitValue:_FunctionMask  bit:FunctionExistsDoorControl];
}
    
/**
 PTZ
 
 @return YES
 */
-(BOOL)FunctionExistsPTZ
{
    return  [self BitValue:_FunctionMask  bit:FunctionExistsPTZ];
}
/**
 AUD
 
 @return YE
 */
-(BOOL)FunctionExistsAudio
{
    return  [self BitValue:_FunctionMask  bit:FunctionExistsAudioMIC] || [self BitValue:_FunctionMask  bit:FunctionExistsAudioHorn];
}
@end
