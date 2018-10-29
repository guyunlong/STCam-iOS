//
//  AppDelegate.m
//  STCam
//
//  Created by guyunlong on 8/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import "AccountManager.h"
#import "DevListViewModel.h"
#import "RealReachability.h"
#import <Bugly/Bugly.h>
// iOS10 注册 APNs 所需头文件
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<JPUSHRegisterDelegate>{
    UIBackgroundTaskIdentifier _backIden;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    // 如需继续使用 pushConfig.plist 文件声明 appKey 等配置内容，请依旧使用 [JPUSHService setupWithOption:launchOptions] 方式初始化。
    NSString * appKey = @"e7a4318dfe0393afc10aec35";
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:nil
                 apsForProduction:NO
            advertisingIdentifier:nil];
    
    [self listenNetWorkingStatus];
    
    [application setApplicationIconBadgeNumber:0]; //清除角标
    
    
    [Bugly startWithAppId:@"b27ed1377f"];
    
    
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    NSString *deviceTokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]                                                 stringByReplacingOccurrencesOfString:@">" withString:@""]                                              stringByReplacingOccurrencesOfString:@" "withString:@""];
  

    
    [[AccountManager sharedManager] setDeviceToken:deviceTokenStr];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    DevListViewModel * viewModel = [DevListViewModel sharedDevListViewModel];
    [viewModel disConnectAllDevice];
    [self beginBackgroundTask];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    DevListViewModel * viewModel = [DevListViewModel sharedDevListViewModel];
    [viewModel connectAllDevice];
    
    [application setApplicationIconBadgeNumber:0]; //清除角标
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}
#pragma methods
-(void)beginBackgroundTask{
    _backIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"begin  bgend=============");
     
        [self endBackgroundBack]; // 如果在系统规定时间内任务还没有完成，在时间到之前会调用到这个方法，一般是10分钟
    }];
    
   
}
-(void)endBackgroundBack{
    [[UIApplication sharedApplication] endBackgroundTask:_backIden];
    _backIden = UIBackgroundTaskInvalid;
}

-(void)listenNetWorkingStatus{
    
    [GLobalRealReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
   
}
- (void)networkChanged:(NSNotification *)notification
{
    DevListViewModel *viewModel = [DevListViewModel sharedDevListViewModel];
    
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    NSLog(@"-----currentStatus:%@",@(status));
    
    switch (status)
    {
        case RealStatusNotReachable:
        {
            //  case NotReachable handler
            NSLog(@"------------没有联网");
            [viewModel notifyNetworkStatusChanged:NetWorkConnType_Break];
            break;
        }
            
        case RealStatusViaWiFi:
        {
            //  case WiFi handler
            NSLog(@"------------无线网");
            [viewModel notifyNetworkStatusChanged:NetWorkConnType_WWAN];
            break;
        }
            
        case RealStatusViaWWAN:
        {
            //  case WWAN handler
            NSLog(@"------------蜂窝数据");
            [viewModel notifyNetworkStatusChanged:NetWorkConnType_WWAN];
            break;
        }
            
        default:
            break;
    }
    
}


@end
