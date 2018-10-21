//
//  MotionCfgModel.m
//  STCam
//
//  Created by guyunlong on 10/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "MotionCfgModel.h"
#import "PrefixHeader.h"
@implementation MotionCfgModel
+(instancetype)MotionCfgModelWithDict:(NSDictionary *)dict{
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
-(NSString*)getMotionDesc{
    if (_MD_Active == 0) {
        return @"action_close".localizedString;
    }
    else if(_MD_Sensitive <= 100){
        return @"action_level_high".localizedString;
    }
    else if(_MD_Sensitive <= 150){
        return @"action_level_middle".localizedString;
    }
    else if(_MD_Sensitive <= 200){
        return @"action_level_low".localizedString;
    }
    return @"";
}

@end
