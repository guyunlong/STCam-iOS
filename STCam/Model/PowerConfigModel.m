//
//  PowerConfigModel.m
//  GRAVE
//
//  Created by guyunlong on 2018/12/27.
//  Copyright © 2018年 South. All rights reserved.
//  定时开关机配置

#import "PowerConfigModel.h"

@implementation PowerConfigModel
+(instancetype)PowerConfigModelWithDict:(NSDictionary *)dict{
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
