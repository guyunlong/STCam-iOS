//
//  RecConfigModel.m
//  STCam
//
//  Created by guyunlong on 10/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "RecConfigModel.h"
#import "PrefixHeader.h"
@implementation RecConfigModel
+(instancetype)RecConfigModelWithDict:(NSDictionary *)dict{
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
-(void)setRec_AlmTimeLenChoice:(NSInteger)choice{
    switch (choice) {
        case 0:
            _Rec_AlmTimeLen = 5;
            break;
        case 1:
            _Rec_AlmTimeLen = 10;
            break;
        case 2:
            _Rec_AlmTimeLen = 20;
            break;
        case 3:
            _Rec_AlmTimeLen = 30;
            break;
        case 4:
            _Rec_AlmTimeLen = 60;
            break;
        default:
            break;
    }
}
-(NSString*)getRecordLenDesc{
    return [NSString stringWithFormat:@"%ld%@",_Rec_AlmTimeLen,@"string_second".localizedString];
}
@end
