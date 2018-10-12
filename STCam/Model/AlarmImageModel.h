//
//  AlarmImageModel.h
//  STCam
//
//  Created by guyunlong on 10/11/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 //    "ID": 4431,
 //            "SN": "80001035",
 //            "AlmType": 1,
 //            "AlmName": "移动警报",
 //            "AlmTime": "2018-07-11 13:37:11",
 //            "Img": ""
 */
@interface AlarmImageModel : NSObject
@property(nonatomic,assign)  NSInteger ID;
@property(nonatomic,strong)  NSString* SN;
@property(nonatomic,strong)  NSString* DevName;
@property(nonatomic,assign)  NSInteger AlmType;
@property(nonatomic,strong)  NSString* AlmTime;
@property(nonatomic,strong)  NSString* Img;
+(instancetype)AlarmImageModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
