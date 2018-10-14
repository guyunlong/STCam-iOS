//
//  AlarmImageModel.m
//  STCam
//
//  Created by guyunlong on 10/11/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "AlarmImageModel.h"
#import "DevListViewModel.h"
#import "DeviceModel.h"
@implementation AlarmImageModel
+(instancetype)AlarmImageModelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];//kvc
        switch (_AlmType) {
            case 0:
                 _AlmDesc = @"";
            case 1:
                 _AlmDesc = @"移动警报";
            case 2:
                _AlmDesc = @"传感器警报";
            case 3:
                _AlmDesc = @"声音警报";
            case 4:
                _AlmDesc = @"网络短线";
            case 5:
                _AlmDesc = @"网络重连";
            case 6:
                _AlmDesc = @"磁盘空间满";
            case 7:
                _AlmDesc = @"视频遮挡";
            case 8:
                _AlmDesc = @"视频丢失";
            case 9:
                _AlmDesc = @"门铃出发";
            case 10:
                _AlmDesc = @"其他警报";
            default:
                _AlmDesc = @"其他警报";
        }
        
        DevListViewModel * viewModel =[DevListViewModel sharedDevListViewModel];
        NSArray * deviceArray =viewModel.deviceArray;
        for (DeviceModel * model in deviceArray) {
            if ([model.SN isEqualToString:_SN]) {
                _DevName =model.DevName;
                 break;
            }
        }
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%s---%@",__func__,key);
}
@end
