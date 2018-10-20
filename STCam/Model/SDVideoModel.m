//
//  SDVideoModel.m
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "SDVideoModel.h"

@implementation SDVideoModel
-(NSString *)getSdVideoName{
    NSArray * array = [_sdVideo componentsSeparatedByString:@"/"];
    if ([array count] > 0) {
        return array[array.count-1];
    }
    return nil;
}
-(NSString*)getFileSizeDes{
    NSInteger kb = _FileSize / 1024;
    
    if (kb / 1024 > 1024)
    {
       float size = (float) kb / 1024.0 / 1024.0;
       return [NSString stringWithFormat:@"%0.2fG", size];
        
    }
    else if (kb > 1024)
    {
        float size = (float) kb / 1024.0;
        return [NSString stringWithFormat:@"%0.1fM", size];
    }
    else
    {
        return [NSString stringWithFormat:@"%ldK",kb];
    }
}

+(instancetype)SDVideoModelWithDict:(NSDictionary *)dict{
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
