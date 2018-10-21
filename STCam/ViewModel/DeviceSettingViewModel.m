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
#import "CoreDataManager.h"

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
-(RACSignal*)racChangeDevicePassword:(NSString*)devicePassword{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@&&UserName0=admin&Password0=%@",[self.model getDevURL:Msg_SetUserLst],devicePassword];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                RetModel * model = [RetModel RetModelWithDict:data];
                if (model.ret == 1 || model.ret == 2) {
                    [self.model setPwd:devicePassword];
                    [[CoreDataManager sharedManager] saveDevice:self.model];
                    [subscriber sendNext:@(model.ret)];
                }
                else{
                    [subscriber sendNext:@(model.ret)];
                }
            }
            
        });
        
        return nil;
    }];
}
-(RACSignal*)racRebootDevice{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@",[self.model getDevURL:Msg_SetDevReboot]];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                RetModel * model = [RetModel RetModelWithDict:data];
                if (model.ret == 1) {
                    
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
-(RACSignal*)racGetPushSetting{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@",[self.model getDevURL:Msg_GetPushCfg]];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                PushSettingModel * model = [PushSettingModel PushSettingModelWithDict:data];
                if (model) {
                    self.mPushSettingModel = model;
                    [subscriber sendNext:@1];
                }
                else{
                    [subscriber sendNext:@0];
                }
            }
            
        });
        
        return nil;
    }];
}
-(RACSignal*)racSetPushConfig{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@&PushActive=%d&PushInterval=%ld&PIRSensitive=%ld",[self.model getDevURL:Msg_SetPushCfg],self.mPushSettingModel.PushActive,self.mPushSettingModel.PushInterval,self.mPushSettingModel.PIRSensitive];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                RetModel * model = [RetModel RetModelWithDict:data];
                if (model.ret) {
                    [subscriber sendNext:@1];
                }
                else{
                    [subscriber sendNext:@0];
                }
            }
            
        });
        
        return nil;
    }];
}
-(RACSignal*)racGetMotionCfg{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@",[self.model getDevURL:Msg_GetMDCfg]];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                MotionCfgModel * model = [MotionCfgModel MotionCfgModelWithDict:data];
                if (model) {
                    self.motionCfgModel = model;
                    [subscriber sendNext:@1];
                }
                else{
                    [subscriber sendNext:@0];
                }
            }
            
        });
        
        return nil;
    }];
}
-(RACSignal*)racSetMotionCfg{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@&MD_Sensitive=%ld&MD_Active=%ld",[self.model getDevURL:Msg_SetMDCfg],self.motionCfgModel.MD_Sensitive,self.motionCfgModel.MD_Active];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                RetModel * model = [RetModel RetModelWithDict:data];
                if (model.ret) {
                    [subscriber sendNext:@1];
                }
                else{
                    [subscriber sendNext:@0];
                }
            }
            
        });
        
        return nil;
    }];
}
-(RACSignal*)racGetAudioCfg{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@",[self.model getDevURL:Msg_GetAudioCfg]];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                self.AUDIO_IsPlayPromptSound = [[data objectForKey:@"AUDIO_IsPlayPromptSound"] boolValue];
                [subscriber sendNext:@1];
            }
            else{
                [subscriber sendNext:@0];
            }
            
        });
        
        return nil;
    }];
}
-(RACSignal*)racSetAudioCfg{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@&AUDIO_IsPlayPromptSound=%d",[self.model getDevURL:Msg_SetAudioCfg],self.AUDIO_IsPlayPromptSound];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                RetModel * model = [RetModel RetModelWithDict:data];
                if (model.ret) {
                    [subscriber sendNext:@1];
                }
                else{
                    [subscriber sendNext:@0];
                }
            }
            
        });
        
        return nil;
    }];
}
-(RACSignal*)racGetRecCfg{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@",[self.model getDevURL:Msg_GetRecCfg]];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                RecConfigModel * model = [RecConfigModel RecConfigModelWithDict:data];
                if (model) {
                    self.mRecConfigModel = model;
                    [subscriber sendNext:@1];
                }
                else{
                    [subscriber sendNext:@0];
                }
            }
            
        });
        
        return nil;
    }];
}
-(RACSignal*)racSetRecCfg{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@&Rec_AlmTimeLen=%ld",[self.model getDevURL:Msg_SetRecCfg],self.mRecConfigModel.Rec_AlmTimeLen];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                RetModel * model = [RetModel RetModelWithDict:data];
                if (model.ret) {
                    [subscriber sendNext:@1];
                }
                else{
                    [subscriber sendNext:@0];
                }
            }
            
        });
        
        return nil;
    }];
}
-(RACSignal*)racGetDiskCfg{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@",[self.model getDevURL:Msg_GetDiskCfg]];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                SDInfoModel * model = [SDInfoModel SDInfoModelWithDict:data];
                if (model) {
                    self.mSDInfoModel = model;
                    [subscriber sendNext:@1];
                }
                else{
                    [subscriber sendNext:@0];
                }
            }
            
        });
        
        return nil;
    }];
}
@end
