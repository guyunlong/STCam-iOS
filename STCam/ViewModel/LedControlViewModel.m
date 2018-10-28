//
//  LedControlViewModel.m
//  STCam
//
//  Created by cc on 2018/10/26.
//  Copyright © 2018 South. All rights reserved.
//

#import "LedControlViewModel.h"
#import "PrefixHeader.h"
#import "RetModel.h"
@implementation LedControlViewModel

-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)setupTimer{
    @weakify(self)
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        if (self.changeValue) {
            [[self racSetLightCfg] subscribeNext:^(id x) {
                self.changeValue = NO;
            }];
        }
    }];
}
-(void)destoryTimer{
    [_refreshTimer invalidate];
    _refreshTimer = nil;
}
/**
 获得灯光配置
 */
-(RACSignal*)racGetLightCfg{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@",[self.model getDevURL:Msg_GetLightCfg]];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                self.ledStatusModel = [LedStatusModel LedStatusModelWithDict:data];
                [subscriber sendNext:@1];
            }
            else{
                [subscriber sendNext:@0];
            }
            
        });
        
        return nil;
    }];
}

/**
 设置灯光配置
 */
-(RACSignal*)racSetLightCfg{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@",[self.model getDevURL:Msg_SetLightCfg]];
            NSString * params;
            if (self.ledStatusModel.Mode == 1) {
                params = [NSString stringWithFormat:@"&Mode=1&Delay=%ld&Lux=%ld&Brightness=%ld",self.ledStatusModel.autoModel.Delay,self.ledStatusModel.autoModel.Lux,self.ledStatusModel.autoModel.Brightness];
            }
            else if (self.ledStatusModel.Mode == 2) {
                params = [NSString stringWithFormat:@"&Mode=2&Brightness=%ld",self.ledStatusModel.manualModel.Brightness];
            }
            else if (self.ledStatusModel.Mode == 3) {
                params = [NSString stringWithFormat:@"&Mode=3&Brightness=%ld&StartH=%ld&StartM=%ld&StopH=%ld&StopM=%ld",self.ledStatusModel.timerModel.Brightness,self.ledStatusModel.timerModel.StartH,self.ledStatusModel.timerModel.StartM,self.ledStatusModel.timerModel.StopH,self.ledStatusModel.timerModel.StopM];
                
            }
            else if (self.ledStatusModel.Mode == 4) {
                params = [NSString stringWithFormat:@"&Mode=4&Brightness=%ld&Lux=%ld",self.ledStatusModel.d2dModel.Brightness,self.ledStatusModel.d2dModel.Lux];
            }
            url = [NSString stringWithFormat:@"%@%@",url,params];
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
@end
