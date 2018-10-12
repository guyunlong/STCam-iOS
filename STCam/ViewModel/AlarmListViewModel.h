//
//  AlarmListViewModel.h
//  STCam
//
//  Created by guyunlong on 10/11/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
@interface AlarmListViewModel : NSObject
-(RACSignal *)racGetAlarmList;
-(RACSignal *)racDeleteAlarm:(BOOL)deleteAll model:(id)model;
@property(nonatomic,strong)NSMutableArray* alarmArray;
@end
