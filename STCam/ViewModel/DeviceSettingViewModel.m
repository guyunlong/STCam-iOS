//
//  DeviceSettingViewModel.m
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "DeviceSettingViewModel.h"
#import "PrefixHeader.h"
#import "RetModel.h"
@implementation DeviceSettingViewModel
-(RACSignal*)racChangeDeviceName:(NSString*)deviceName{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
           
            NSString * url = [NSString stringWithFormat:@"%@&DevName=%@",[self.model getDevURL:Msg_SetDevInfo],deviceName];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                RetModel * model = [RetModel RetModelWithDict:data];
                if (model.ret == 1) {
                    [self.model setDevName:deviceName];
                    [subscriber sendNext:@1];
                }
                else{
                     [subscriber sendNext:@(model.ret)];
                }
            }
            
        });
        
        return nil;
    }];
}
@end
