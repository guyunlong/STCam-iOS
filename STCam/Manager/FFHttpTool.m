//
//  FFHttpTool.m
//  STCam
//
//  Created by guyunlong on 10/3/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "FFHttpTool.h"
#import "RetModel.h"
#import "PrefixHeader.h"
#import "UIViewController+Utils.h"
#import "LoginViewController.h"
#import "STNavigationController.h"
@implementation FFHttpTool
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    [request setHTTPMethod:@"GET"];
    
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSLog(@"key = %@ and obj = %@", key, obj);
        [request setValue:obj forHTTPHeaderField:key];
        
    }];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task=[session dataTaskWithRequest:request completionHandler:^(id  _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil) {
                NSLog(@"error = %@", error);
                failure(error);
                return;
            }
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                NSError *error;
                NSData* uft8Data = [FFHttpTool UTF8WithGB2312Data:data];
                // NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
              
                
                if (uft8Data) {
                    id dictionary = [NSJSONSerialization JSONObjectWithData:uft8Data options:NSJSONReadingMutableLeaves error:&error];
                    if ([dictionary isKindOfClass:[NSDictionary class]]) {
                        RetModel * model = [RetModel RetModelWithDict:dictionary];
                        //if (model.ret == RESULT_USER_LOGOUT)
                        {
                            //当前页面如果是登录页面，弹出强制登录框，如果不是登录页面，跳转到登录页面，弹出强制登录框
                            UIViewController * ctl  =[UIViewController currentViewController];
                            if (![ctl isKindOfClass:[LoginViewController class]]) {
                                NSLog(@"current view controller is LoginViewController");
                                LoginViewController * loginCtl  = [[LoginViewController alloc] init];
                                [loginCtl setLogout:YES];
                                STNavigationController *loginNav =   [[STNavigationController alloc] initWithRootViewController:loginCtl];
                                [ctl presentViewController:loginNav animated:YES completion:nil];
                                
                            }
                        }
                    }
                    success(dictionary);
                }
                else{
                     failure(nil);
                }
               
                
            } else {
                failure(nil);
            }
        });
    }];
    //5.resume
    [task resume];
    
    
}
+(NSData *)UTF8WithGB2312Data:(NSData *)gb2312Data
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *str = [[NSString alloc] initWithData:gb2312Data encoding:enc];
    if (!str) {
        str = [[NSString alloc] initWithData:gb2312Data encoding:NSASCIIStringEncoding];
    }
    NSData *utf8Data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return utf8Data;
}


@end
