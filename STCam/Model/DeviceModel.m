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
@interface DeviceModel(){
    dispatch_queue_t serialQueue;
}
@property(assign)BOOL IsConnecting;
@end
@implementation DeviceModel

-(id)init{
    self = [super init];
    if (self) {
        serialQueue = dispatch_queue_create("com.sentry.mlock.get", DISPATCH_QUEUE_SERIAL);
        _User = @"admin";
        _Pwd = @"admin";
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
    if ([self.ConnType isEqualToString:@"IS_CONN_LAN"]){
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
-(UIColor*)getConnectColor{
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
    return [self.ConnType substringFromIndex:@"IS_CONN_".length];
}

+(instancetype)DeviceModelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];//kvc
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%s---%@",__func__,key);
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
    
    if (_IsConnecting)
    {
        return NO;
    }
    
    
    _IsConnecting = YES;
    //thNet_Connect(HANDLE NetHandle, u64 SN, char* UserName, char* Password, char* IPUID, i32 DataPort, u32 TimeOut)
    ret = thNet_Connect(self.NetHandle,
                           [_SN integerValue],
                           [@"admin" UTF8String],
                           [@"admin" UTF8String],
                           [self.IPUID UTF8String],
                           self.DataPort,
                           10 * 1000);
    
    _IsConnecting = false;
    return ret;
}

-(void)threadConnect
{
    @weakify(self)
    dispatch_async(serialQueue, ^{
        @strongify(self);
        if (self.NetHandle == 0) {
            self.NetHandle = thNet_Init(true, false);
        }
        if (![self IsConnect]) {
            [self Connect];
        }
        if ([self IsConnect]) {
            
        }
    });
    
//    new Thread()
//    {
//        @Override
//        public void run()
//        {
//            try
//            {
//                if (tmpNode.NetHandle == 0)
//                {
//                    tmpNode.NetHandle = lib.thNetInit(
//                                                      true,
//                                                      false
//                                                      );
//                }
//
//                if (!tmpNode.IsConnect())
//                {
//                    tmpNode.Connect();
//                }
//
//                if (tmpNode.IsConnect())
//                {
//                    if (ipc != null)
//                    {
//                        ipc.sendMessage(Message.obtain(ipc, TMsg.Msg_NetConnSucceed, tmpNode.Index, 0, tmpNode));
//                    }
//                    String tmpStr = tmpNode.GetAllCfg();
//                    JSONObject json = new JSONObject(tmpStr);
//                    tmpNode.DevCfg = json;
//                    tmpNode.ExistSD = json.getJSONObject("DevInfo").getInt("ExistSD");
//                    tmpNode.DevType = json.getJSONObject("DevInfo").getInt("DevType");
//                    tmpNode.Brightness = json.getJSONObject("Video").getInt("Brightness");
//                    tmpNode.Contrast = json.getJSONObject("Video").getInt("Contrast");
//                    tmpNode.Sharpness = json.getJSONObject("Video").getInt("Sharpness");
//                    //tmpNode.UID = json.getJSONObject("P2P").getString("P2P_UID");
//                    tmpNode.DevName = json.getJSONObject("DevInfo").getString("DevName");
//                    tmpNode.SoftVersion = json.getJSONObject("DevInfo").getString("SoftVersion");
//                    //Log.e("java", "SoftVersion is :" + tmpNode.SoftVersion + ",uid is " + tmpNode.UID);
//                }
//                else
//                {
//                    if (ipc != null)
//                    {
//                        ipc.sendMessage(Message.obtain(ipc, TMsg.Msg_NetConnFail, tmpNode.Index, 0, tmpNode));
//                    }
//                    return;
//                }
//            }
//            catch (Exception e)
//            {
//                return;
//            }
//        }
//    }.start();
}
@end
