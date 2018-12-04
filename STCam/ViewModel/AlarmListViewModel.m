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
#import "AccountManager.h"
#import "FFHttpTool.h"
#import "PrefixHeader.h"
@implementation AlarmListViewModel
-(id)init{
    self = [super init];
    if (self) {
        _alarmArray = [NSMutableArray new];
    }
    return self;
}
-(RACSignal *)racGetAlarmList{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        NSString * dateStr = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyyMMdd"];
        //http://211.149.199.247:800/app_user_get_devlst.asp?user=1257117229@qq.com&psd=12345678
        NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_user_getalmfilelst.asp?user=%@&psd=%@&dt=%@&line=100&page=0",serverIP,ServerPort,[AccountManager getUser],[AccountManager getPassword],dateStr];
        [FFHttpTool GET:url parameters:nil success:^(id data){
            @strongify(self)
            
            if ([data isKindOfClass:[NSArray class]]) {
                [self.alarmArray removeAllObjects];
                for (NSDictionary * dic in data) {
                    AlarmImageModel * model = [AlarmImageModel AlarmImageModelWithDict:dic];
                    [self.alarmArray addObject:model];
                    
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
-(RACSignal *)racDeleteAlarm:(BOOL)deleteAll model:(AlarmImageModel*)model{
    NSMutableString * mutaleString = [NSMutableString new];
    if (deleteAll) {
        for (AlarmImageModel * model in self.alarmArray) {
            if ([mutaleString length] >0) {
                [mutaleString appendString:@"@"];
            }
            [mutaleString appendString:[NSString stringWithFormat:@"%ld",model.ID]];
        }
    }
    else{
        [mutaleString appendString:[NSString stringWithFormat:@"%ld",model.ID]];
    }
    
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        //http://211.149.199.247:800/app_user_get_devlst.asp?user=1257117229@qq.com&psd=12345678
        NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_user_delalmfile.asp?user=%@&psd=%@&id=%@",serverIP,ServerPort,[AccountManager getUser],[AccountManager getPassword],mutaleString];
        [FFHttpTool GET:url parameters:nil success:^(id data){
            @strongify(self)
            [subscriber sendNext:@1];
        } failure:^(NSError * error){
            [subscriber sendNext:@100000];//未知网络错误
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    
}
@end
