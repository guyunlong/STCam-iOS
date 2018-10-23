//
//  SSIDModel.m
//  STCam
//
//  Created by guyunlong on 10/23/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "SSIDModel.h"

@implementation SSIDModel
+(instancetype)SSIDModelWithDict:(NSDictionary *)dict{
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
