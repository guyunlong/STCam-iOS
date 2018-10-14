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
@interface DevListViewModel : NSObject
+ (DevListViewModel *)sharedDevListViewModel;
@property(nonatomic,assign)BOOL visitorMode;
-(RACSignal*)racSearchDevice;
-(RACSignal *)racGetDeviceList;
@property(nonatomic,strong)NSMutableArray* deviceArray;

/**
 app 退到后台，断开所有连接
 */
-(void)disConnectAllDevice;


/**
 app 进入前台，进行设备连接
 */
-(void)connectAllDevice;
@end
