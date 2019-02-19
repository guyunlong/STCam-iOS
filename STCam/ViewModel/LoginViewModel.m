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
#import "AccountManager.h"
#import "SouthUtil.h"
@implementation LoginViewModel
- (id)init {
    self = [super init];
    if (self) {
        [self initConfig];
    }
    return self;
   
}
-(void)initConfig{
     @weakify(self)
    self.validLoginSignal = [[RACSignal
                              combineLatest:@[ RACObserve(self, user), RACObserve(self, password) ]
                              reduce:^(NSString *username, NSString *password) {
                                  @strongify(self)
                                  BOOL vaildUser = [self validateEmail:username] || [SouthUtil isValidPhone:username];
                                  return @(vaildUser && password.length > 0);
                              }]
                             distinctUntilChanged];
    self.user = [AccountManager getUser];
    self.password = [AccountManager getPassword];
    self.remember =[AccountManager getIsRemember];
}
-(RACSignal *)racLogin:(BOOL)forceLogin{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
//        Observable<com.model.RetModel> app_user_login(@Query("user") String user,
//                                                      @Query("psd") String psd,
//                                                      @Query("tokenid") String tokenid,
//                                                      @Query("mbtype") int mbtype,
//                                                      @Query("apptype") int apptype,
//                                                      @Query("pushtype") int pushtype,
//                                                      @Query("isforce") int isforce
        
        //http://211.149.199.247:800/app_user_login.asp?user=1257117229@qq.com&psd=12345678
//        public static final int mbtype = 1;//手机类型 Android=1 IPhone=2
//        public static final int apptype = 0;//APP类型，IPCAM=0
//        public static final int pushtype = 0;//推送服务商 极光(jPush=0)  google=1
        NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_user_login.asp?user=%@&psd=%@&tokenid=%@&mbtype=2&apptype=0&pushtype=0&appname=%@&isforce=%d",serverIP,ServerPort,self.user,self.password,[[AccountManager sharedManager] deviceToken],@"app_name".localizedString,forceLogin];
        [FFHttpTool GET:url parameters:nil success:^(id data){
            @strongify(self)
            DDLogDebug(@"view model response data is %@",data);
            if ([data isKindOfClass:[NSDictionary class]]) {
                RetModel * model = [RetModel RetModelWithDict:data];
                if (model.ret == 1) {
                    [AccountManager saveAccount:self.user pwd:self.password remember:self.remember];
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
- (BOOL) validateEmail: (NSString *) strEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:strEmail];
}
@end
