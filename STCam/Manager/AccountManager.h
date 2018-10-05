//
//  AccountManager.h
//  STCam
//
//  Created by guyunlong on 10/4/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManager : NSObject
+(void)saveAccount:(NSString*)user pwd:(NSString*)pwd remember:(BOOL)remember;
+(void)saveRemember:(BOOL)remember;
+(NSString*)getUser;
+(NSString*)getPassword;
+(BOOL)getIsRemember;
@end
