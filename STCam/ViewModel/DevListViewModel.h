//
//  DevListViewModel.h
//  STCam
//
//  Created by guyunlong on 8/26/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "DeviceModel.h"
typedef NS_ENUM(NSInteger, NetWorkConnType){
    NetWorkConnType_Break,//没有连接
    NetWorkConnType_Wlan,//无线连接
    NetWorkConnType_WWAN//蜂窝数据
};

typedef NS_ENUM(NSInteger, TUserMode){
    TUserMode_Unknown,
    TUserMode_Login,
    TUserMode_Visitor
};

@interface DevListViewModel : NSObject
+ (DevListViewModel *)sharedDevListViewModel;
@property(nonatomic,assign)TUserMode userMode;
-(RACSignal *)racSearchDeviceinMainView:(BOOL)inMainView;
-(RACSignal *)racGetDeviceList;

@property(nonatomic,assign)NetWorkConnType connType;
/**
 删除用户列表中的设备

 @param model 设备
 @return 信号量
 */
-(RACSignal *)racDeleteDevice:(DeviceModel*)model reset:(BOOL)isReset;



@property (strong, nonatomic)  NSMutableArray *searchDeviceArray;//主页面搜索设备
@property (strong, nonatomic)  NSMutableArray *searchDeviceInSubViewArray;//sta页面，ap转sta页面搜索设备，这些页面返回后，数组要清空

@property(nonatomic,strong)NSMutableArray* deviceArray;

/**
 设备状态更新（是否连上设备）后，刷新页面，kvo
 */
@property(nonatomic,assign)BOOL refreshView;
/**
 app 退到后台，断开所有连接
 */
-(void)disConnectAllDevice;


/**
 app 进入前台，进行设备连接
 */
-(void)connectAllDevice;


/**
 搜索到的设备是否存于用户的设备中
 */
-(BOOL)isSearchDevExistInDeviceArray:(DeviceModel*)model;

/**
 网络连接状态改变

 @param type 网络连接类型
 */
-(void)notifyNetworkStatusChanged:(NetWorkConnType)type;

int code_convert_name(char *from_charset, char *to_charset, char *inbuf, size_t inlen, char *outbuf, size_t outlen);
@end
