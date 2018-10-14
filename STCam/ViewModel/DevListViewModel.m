//
//  DevListViewModel.m
//  STCam
//
//  Created by guyunlong on 8/26/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "DevListViewModel.h"
#import "PrefixHeader.h"
#import "libthSDK.h"
#import "DeviceModel.h"
#import "FFHttpTool.h"
#import "AccountManager.h"
#import "iconv.h"
@interface DevListViewModel ()
@property (strong, nonatomic)  NSMutableArray *searchDeviceArray;
@end

@implementation DevListViewModel

void * refSelf;
int code_convert_name(char *from_charset, char *to_charset, char *inbuf, size_t inlen, char *outbuf, size_t outlen) {
    iconv_t cd = NULL;
    cd = iconv_open(to_charset, from_charset);
    if(!cd)
        return -1;
    memset(outbuf, 0, outlen);
    if(iconv(cd, &inbuf, &inlen, &outbuf, &outlen) == -1) {
        return -1;
    }
    iconv_close(cd);
    return 0;
}

void callback_SearchDev(void *UserCustom, u32 SN, int DevType, char *DevModal, char *SoftVersion, int DataPort, int HttpPort, int rtspPort,
                        char *DevName, char *DevIP, char *DevMAC, char *SubMask, char *Gateway, char *DNS1, char *DDNSServer,
                        char *DDNSHost, char *UID){
    DevListViewModel *myself = (__bridge DevListViewModel * ) refSelf;
    
    printf("sn is %d,DevIP is %s,DevName is %s,ddns host is %s\n",SN,DevIP,DevName,DDNSHost);
    
    //设置 DevIP 的设备
    for (DeviceModel * model in myself.searchDeviceArray) {
        if ([model.IPUID isEqualToString:[NSString stringWithUTF8String:DevIP]]) {
            return;
        }
    }
    DeviceModel * node = [DeviceModel new];
    [node setIPUID:[NSString stringWithUTF8String:DevIP]];
    [node setSN:[NSString stringWithFormat:@"%0.8x", SN]];
    [node setDataPort:DataPort];
    [node setWebPort: HttpPort];
    [node setConnType:@"IS_CONN_LAN"];
    NSString *devName = nil;
    NSInteger ansiLen = strlen(DevName);
    
    NSInteger utf8Len = ansiLen*2;
    char *utf8String = (char*)malloc(utf8Len);
    memset(utf8String, 0, utf8Len);
    int result = code_convert_name("gb2312", "utf8", DevName, ansiLen, utf8String, utf8Len);
    if (result == -1) {
        
    }
    else {
        devName = [[NSString alloc] initWithUTF8String:utf8String];
        [node setDevName:devName];
    }
    free(utf8String);
    [node threadConnect];
    [myself.searchDeviceArray addObject:node];
    
}


+ (DevListViewModel *)sharedDevListViewModel{
    static DevListViewModel *sharedManager = nil;
    static dispatch_once_t manyiToken;
    dispatch_once(&manyiToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(id)init{
    self = [super init];
    if (self) {
        _deviceArray = [NSMutableArray new];
        _searchDeviceArray = [NSMutableArray new];
        refSelf = (__bridge void *)(self);
        
    }
    return self;
}
-(RACSignal *)racGetDeviceList{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        //http://211.149.199.247:800/app_user_get_devlst.asp?user=1257117229@qq.com&psd=12345678
        NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_user_get_devlst.asp?user=%@&psd=%@",serverIP,ServerPort,[AccountManager getUser],[AccountManager getPassword]];
        [FFHttpTool GET:url parameters:nil success:^(id data){
            @strongify(self)
            if ([data isKindOfClass:[NSArray class]]) {
               
                for (NSDictionary * dic in data) {
                    DeviceModel * model = [DeviceModel DeviceModelWithDict:dic];
                    
                    for (DeviceModel * devModel in self.deviceArray) {
                        if ([devModel.IPUID isEqualToString:model.IPUID]) {
                            ConnType type = [model getConnectType];
                            if (type == ConnType_LAN || type == ConnType_DDNS || type == ConnType_P2P) {
                                devModel.ConnType = model.ConnType;
                                [devModel threadConnect];
                            }
                            continue;
                        }
                    }
                    ConnType type = [model getConnectType];
                    if (type == ConnType_LAN || type == ConnType_DDNS || type == ConnType_P2P) {
                        [model threadConnect];
                    }
                    [self.deviceArray addObject:model];
                    
                }
                 [subscriber sendNext:@1];
            }
            else{
                [subscriber sendNext:0];//
            }
            [subscriber sendCompleted];
        } failure:^(NSError * error){
            [subscriber sendNext:@100000];//未知网络错误
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}
-(RACSignal *)racSearchDevice{
    
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            HANDLE SearchHandle;
            SearchHandle = thSearch_Init(callback_SearchDev, NULL);
            if (!SearchHandle) {
                
            }
            thSearch_SearchDevice(SearchHandle);
            time_t dt;
            dt = time(NULL);
            while(1)
            {
                usleep(1000*100);
                if (time(NULL) - dt >= 5) break;
            }
            
            thSearch_Free(SearchHandle);
            SearchHandle = NULL;
            
            self.deviceArray = [self.searchDeviceArray mutableCopy];
             [subscriber sendNext:@1];
        });
        
        return nil;
    }];
    
    
}
/**
 app 退到后台，断开所有连接
 */
-(void)disConnectAllDevice{
    for (DeviceModel * devModel in self.deviceArray) {
        if ([devModel IsConnect]) {
            NSLog(@"threadDisconnect device ,sn :%@",devModel.SN);
            [devModel threadDisconnect];
        }
    }
}


/**
 app 进入前台，进行设备连接
 */
-(void)connectAllDevice{
    for (DeviceModel * devModel in self.deviceArray) {
        ConnType type = [devModel getConnectType];
        if (type == ConnType_LAN || type == ConnType_DDNS || type == ConnType_P2P) {
            NSLog(@"threadConnect device ,sn :%@",devModel.SN);
            [devModel threadConnect];
        }
    }
}
@end
