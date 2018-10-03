//
//  LoginViewModel.m
//  STCam
//
//  Created by guyunlong on 10/3/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "LoginViewModel.h"
#import "FFHttpTool.h"
#import "PrefixHeader.h"
#import "RetModel.h"
@implementation LoginViewModel
-(RACSignal *)racLogin{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        //http://211.149.199.247:800/app_user_login.asp?user=1257117229@qq.com&psd=12345678
        NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_user_login.asp?user=1257117229@qq.com&psd=12345678",serverIP,ServerPort];
        [FFHttpTool GET:url parameters:nil success:^(id data){
            @strongify(self)
            NSLog(@"view model response data is %@",data);
            if ([data isKindOfClass:[NSDictionary class]]) {
                RetModel * model = [RetModel RetModelWithDict:data];
                if (model.ret == 1) {
                    [subscriber sendNext:@1];
                }
                else{
                    [subscriber sendNext:@(model.ret)];
                }
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
