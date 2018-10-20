//
//  RecordListViewModel.h
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
@interface RecordListViewModel : NSObject
@property(nonatomic,strong)DeviceModel*model;

@property(nonatomic,strong)NSMutableArray * recordFileArray;
@property(nonatomic,assign)NSInteger page;
/**
 获取录像文件列表

 @param loadMore 下拉加载更多
 @return 成功后，返回信号量
 */
-(RACSignal *)racGetRecordFileList:(BOOL)loadMore;
@end
