//
//  RecordListViewModel.m
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "RecordListViewModel.h"
#import "PrefixHeader.h"
#import "SDVideoModel.h"
@implementation RecordListViewModel
-(id)init{
    self = [super init];
    if (self) {
        _recordFileArray = [NSMutableArray new];
    }
    return self;
}
-(RACSignal *)racGetRecordFileList:(BOOL)loadMore{
    
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            if (!loadMore) {
                self.page = 0;
            }
            NSString * url = [NSString stringWithFormat:@"%@&p=%ld&l=20",[self.model getDevURL:Msg_GetRecFileLst],self.page];
            if (loadMore) {
                ++(self.page);
            }
            id data = [self.model thNetHttpGet:url];
            if ([data isKindOfClass:[NSArray class]]) {
                if (!loadMore) {
                    [self.recordFileArray removeAllObjects];
                }
                for (NSDictionary * dic in data){
                    SDVideoModel * model = [SDVideoModel SDVideoModelWithDict:dic];
                    [self.recordFileArray addObject:model];
                }
            }
            else if([data isKindOfClass:[NSDictionary class]]){
                
            }
            [subscriber sendNext:@1];
        });
        
        return nil;
    }];
}
@end
