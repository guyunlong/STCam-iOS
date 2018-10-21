//
//  SDInfoModel.m
//  STCam
//
//  Created by guyunlong on 10/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "SDInfoModel.h"

@implementation SDInfoModel
+(instancetype)SDInfoModelWithDict:(NSDictionary *)dict{
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

-(NSString*)getTotalSizeDesc{
    if (_DiskSize > 1024)
    {
        float size = _DiskSize / 1024.0;
        return [NSString stringWithFormat:@"%0.1fG", size];
        
    }
    else
    {
        return  [NSString stringWithFormat:@"%ldM", _DiskSize];
    }
}
-(NSString*)getFreeSizeDesc{
    if (_FreeSize > 1024)
    {
        float size = _FreeSize / 1024.0;
        return [NSString stringWithFormat:@"%0.1fG", size];
        
    }
    else
    {
        return  [NSString stringWithFormat:@"%ldM", _FreeSize];
    }
}

@end
