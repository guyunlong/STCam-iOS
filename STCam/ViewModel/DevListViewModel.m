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
@implementation DevListViewModel
void callback_SearchDev(void *UserCustom, u32 SN, int DevType, char *DevModal, char *SoftVersion, int DataPort, int HttpPort, int rtspPort,
                        char *DevName, char *DevIP, char *DevMAC, char *SubMask, char *Gateway, char *DNS1, char *DDNSServer,
                        char *DDNSHost, char *UID){
    
}

-(void)searchDevice{
    
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
}


-(id)init{
    self = [super init];
    if (self) {
        _deviceArray = [NSMutableArray new];
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
                [self.deviceArray removeAllObjects];
                for (NSDictionary * dic in data) {
                    DeviceModel * model = [DeviceModel DeviceModelWithDict:dic];
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
@end
