//
//  DeviceModel.h
//  STCam
//
//  Created by guyunlong on 10/5/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
 {
 "SN": "31194514",
 "DevName": "IPCAM_9CD4D792",
 "ConnType": "IS_CONN_OFFLINE",
 "IPUID": "NULL",
 "WebPort": 0,
 "DataPort": 0,
 "IsVideo": 1,
 "IsHistory": 1,
 "IsPush": 1,
 "IsSetup": 1,
 "IsControl": 1,
 "IsShare": 1,
 "IsRec": 1,
 "IsSnapshot": 1
 }
 */
typedef NS_ENUM(NSInteger, ConnType){
    ConnType_NODEV,
    ConnType_OFFLINE,
    ConnType_LAN,
    ConnType_DDNS,
    ConnType_P2P,
    ConnType_NOWAY
};

@interface DeviceModel : NSObject
@property(nonatomic,strong)  NSString* SN;
@property(nonatomic,strong)  NSString* DevName;
@property(nonatomic,strong)  NSString* ConnType;
@property(nonatomic,strong)  NSString* IPUID;
@property(nonatomic,assign)  NSInteger WebPort;
@property(nonatomic,assign)  NSInteger DataPort;
@property(nonatomic,assign)  BOOL IsVideo;
@property(nonatomic,assign)  BOOL IsHistory;
@property(nonatomic,assign)  BOOL IsPush;
@property(nonatomic,assign)  BOOL IsSetup;
@property(nonatomic,assign)  BOOL IsControl;
@property(nonatomic,assign)  BOOL IsShare;
@property(nonatomic,assign)  BOOL IsRec;
@property(nonatomic,assign)  BOOL IsSnapshot;

/**
 根据不同的连接类型返回对应的颜色

 @return
 */
-(UIColor*)getConnectColor;
-(ConnType)getConnectType;
-(NSString*)getOnLineDesc;
+(instancetype)DeviceModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
