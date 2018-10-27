//
//  ModelLedStatus.m
//  STCam
//
//  Created by guyunlong on 10/27/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "LedStatusModel.h"
@implementation AutoModel
+(instancetype)AutoModelWithDict:(NSDictionary *)dict{
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

@implementation ManualModel
+(instancetype)ManualModelWithDict:(NSDictionary *)dict{
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

@implementation TimerModel
+(instancetype)TimerModelWithDict:(NSDictionary *)dict{
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
-(NSString*)getStartTimeDesc{
    return [NSString stringWithFormat:@"%ld:%ld",_StartH,_StartM];
}
-(NSString*)getStopTimeDesc{
    return [NSString stringWithFormat:@"%ld:%ld",_StopH,_StopM];
}
@end

@implementation D2DModel
+(instancetype)D2DModelWithDict:(NSDictionary *)dict{
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

@implementation LedStatusModel
+(instancetype)LedStatusModelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];//kvc
        self.autoModel = [AutoModel AutoModelWithDict:[dict objectForKey:@"Auto"]];
        self.manualModel = [ManualModel ManualModelWithDict:[dict objectForKey:@"Manual"]];
        self.timerModel = [TimerModel TimerModelWithDict:[dict objectForKey:@"Timer"]];
        self.d2dModel = [D2DModel D2DModelWithDict:[dict objectForKey:@"D2D"]];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%s---%@",__func__,key);
}
@end
