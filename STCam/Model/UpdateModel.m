//
//  UpdateModel.m
//  STCam
//
//  Created by coverme on 2018/10/30.
//  Copyright © 2018 South. All rights reserved.
//

#import "UpdateModel.h"

@implementation UpdateModel
+(instancetype)UpdateModelWithDict:(NSDictionary *)dict{
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
-(BOOL)checkIsLocalAlreadyNewerVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSArray * serverVersionSpilt = [_ver componentsSeparatedByString:@"."];
    NSArray * localVersionSpilt = [app_Version componentsSeparatedByString:@"."];
    if ([serverVersionSpilt count] == 3 && [localVersionSpilt count] == 3) {
        for (NSInteger index = 0; index < 3; ++index) {
            NSInteger server =[serverVersionSpilt[index] integerValue];
            NSInteger local = [localVersionSpilt[index] integerValue];
            if (server > local) {
                return NO;
            }
        }
    }
    return YES;
}
@end
