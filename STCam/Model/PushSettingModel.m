//
//  PushSettingModel.m
//  STCam
//
//  Created by guyunlong on 10/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "PushSettingModel.h"
#import "PrefixHeader.h"
@implementation PushSettingModel
+(instancetype)PushSettingModelWithDict:(NSDictionary *)dict{
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
-(NSString*)getPushActiveDes
{
    if (_PushActive )
    {
        return @"action_open".localizedString;
    }
    else
    {
        return @"action_close".localizedString;
    }
}

-(NSString*)getPushIntervalDesc
{
    if (_PushInterval < 60)
    {
        return [NSString stringWithFormat:@"%ld%@",_PushInterval,@"string_second".localizedString];
        
    }
    else
    {
        return [NSString stringWithFormat:@"%ld%@",_PushInterval/60,@"string_miniute".localizedString];
    }
}

-(NSString*)getPIRSensitiveDesc
{
    if (_PIRSensitive == 0)
    {
        return @"action_level_low".localizedString;
    }
    else if (_PIRSensitive == 1)
    {
        return @"action_level_middle".localizedString;
    }
    else if (_PIRSensitive == 2)
    {
        return @"action_level_high".localizedString;
    }
    return @"";
}

-(NSInteger)getPushIntervalLevel
{
    if (_PushInterval <= 10)
    {
        return 0;
    }
    else if (_PushInterval <= 30)
    {
        return 1;
    }
    else if (_PushInterval <= 60)
    {
        return 2;
    }
    else if (_PushInterval <= 300)
    {
        return 3;
    }
    else
    {
        return 4;
    }
}
-(void)setPushIntervalLevel:(NSInteger)PushIntervalLevel
{
    self.PushIntervalLevel = PushIntervalLevel;
    switch (PushIntervalLevel)
    {
        case 0:
            _PushInterval = 10;
            break;
        case 1:
            _PushInterval = 30;
            break;
        case 2:
            _PushInterval = 60;
            break;
        case 3:
            _PushInterval = 300;
            break;
        case 4:
            _PushInterval = 600;
            break;
        default:
            break;
    }
}


@end
