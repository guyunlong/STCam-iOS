//
//  AccountManager.m
//  STCam
//
//  Created by guyunlong on 10/4/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "AccountManager.h"
#define kAccountUser @"AccountUser"
#define kAccountPassword @"AccountPassword"
#define kAccountRemember @"AccountRemember"
@implementation AccountManager
+ (AccountManager *)sharedManager{
    static AccountManager *sharedManager = nil;
    static dispatch_once_t manyiToken;
    dispatch_once(&manyiToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
+(void)saveAccount:(NSString*)user pwd:(NSString*)pwd remember:(BOOL)remember{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:user forKey:kAccountUser];
    [userDefault setObject:pwd forKey:kAccountPassword];
    [userDefault setObject:@(remember) forKey:kAccountRemember];
}
+(void)saveRemember:(BOOL)remember{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@(remember) forKey:kAccountRemember];
}
+(NSString*)getUser{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * user =[userDefault objectForKey:kAccountUser];
    return user;
}
+(NSString*)getPassword{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * pwd =[userDefault objectForKey:kAccountPassword];
    return pwd;
}
+(BOOL)getIsRemember{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    BOOL remember =[[userDefault objectForKey:kAccountRemember] boolValue];
    return remember;
}
@end
