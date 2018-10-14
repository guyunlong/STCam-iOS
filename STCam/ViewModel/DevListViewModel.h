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
-(RACSignal*)racSearchDevice;
-(RACSignal *)racGetDeviceList;
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
 网络连接状态改变

 @param type 网络连接类型
 */
-(void)notifyNetworkStatusChanged:(NetWorkConnType)type;
@end
