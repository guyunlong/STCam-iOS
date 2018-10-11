//
//  AlarmListViewModel.m
//  STCam
//
//  Created by guyunlong on 10/11/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "AlarmListViewModel.h"
#import "NSDate+Helper.h"
#import "AlarmImageModel.h"
@implementation AlarmListViewModel
-(RACSignal *)racGetAlarmList{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        NSString * dateStr = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyyMMdd"];
        //http://211.149.199.247:800/app_user_get_devlst.asp?user=1257117229@qq.com&psd=12345678
        NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_user_getalmfilelst.asp?user=%@&psd=%@&tokenid=&dt=%@&line=100&page=0",serverIP,ServerPort,[AccountManager getUser],[AccountManager getPassword]];
        [FFHttpTool GET:url parameters:nil success:^(id data){
            @strongify(self)
            if ([data isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary * dic in data) {
                    AlarmImageModel * model = [AlarmImageModel AlarmImageModelWithDict:dic];
                    
                    
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
