//
//  DevListViewModel.m
//  STCam
//
//  Created by guyunlong on 8/26/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "DevListViewModel.h"
#import "libthSDK.h"
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
@end
