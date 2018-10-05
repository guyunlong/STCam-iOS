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
-(void)searchDevice;
-(RACSignal *)racGetDeviceList;
@property(nonatomic,strong)NSMutableArray* deviceArray;
@end
