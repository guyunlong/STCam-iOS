//
//  DeviceModel.m
//  STCam
//
//  Created by guyunlong on 10/5/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "DeviceModel.h"
#import "UIColor+expanded.h"
@implementation DeviceModel


/**
 public final static int IS_CONN_NODEV = 0;
 public final static int IS_CONN_OFFLINE = 1;
 public final static int IS_CONN_LAN = 2;
 public final static int IS_CONN_DDNS = 3;
 public final static int IS_CONN_P2P = 4;
 public final static int IS_CONN_NOWAY = 5;

 */
-(ConnType)getConnectType{
    if ([self.ConnType isEqualToString:@"IS_CONN_LAN"]){
        return ConnType_NODEV;
    }
    else if([self.ConnType isEqualToString:@"IS_CONN_OFFLINE"]){
        return ConnType_OFFLINE;
    }
    else if([self.ConnType isEqualToString:@"IS_CONN_LAN"]){
        return ConnType_LAN;
    }
    else if([self.ConnType isEqualToString:@"IS_CONN_DDNS"]){
        return ConnType_DDNS;
    }
    else if([self.ConnType isEqualToString:@"IS_CONN_P2P"]){
        return ConnType_P2P;
    }
    else if([self.ConnType isEqualToString:@"IS_CONN_NOWAY"]){
        return ConnType_NOWAY;
    }
    return ConnType_OFFLINE;
}
-(UIColor*)getConnectColor{
    switch ([self getConnectType]) {
        case ConnType_LAN:
            return [UIColor colorWithHexString:@"0x227711"];
        case ConnType_DDNS:
            return [UIColor colorWithHexString:@"0x0055aa"];
            break;
        case ConnType_P2P:
            return [UIColor colorWithHexString:@"0x00ff00"];
            break;
        default:
            return [UIColor colorWithHexString:@"0xff0000"];
            break;
    }
}
-(NSString*)getOnLineDesc{
    return [self.ConnType substringFromIndex:@"IS_CONN_".length];
}

+(instancetype)DeviceModelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];//kvc
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%s---%@",__func__,key);
}
@end
