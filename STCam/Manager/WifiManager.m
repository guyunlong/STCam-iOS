//
//  WifiManager.m
//  STCam
//
//  Created by guyunlong on 10/22/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "WifiManager.h"
#import<SystemConfiguration/CaptiveNetwork.h>
@implementation WifiManager
+ (NSString *)ssid

{
    
        NSString *ssid = @"";
        CFArrayRef myArray = CNCopySupportedInterfaces();
    
        if (myArray != nil) {
        
                CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        
                if (myDict != nil) {
            
                        NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            
                        ssid = [dict valueForKey:@"SSID"];
            
                    }
        
            }
    
        return ssid;
    
}

@end
