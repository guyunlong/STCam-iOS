//
//  MotionCfgModel.h
//  STCam
//
//  Created by guyunlong on 10/21/18.
//  Copyright © 2018 South. All rights reserved.
//  图像侦测灵明度

#import <Foundation/Foundation.h>

@interface MotionCfgModel : NSObject
@property(nonatomic,assign) NSInteger MD_Active;
@property(nonatomic,assign) NSInteger MD_Sensitive;
-(NSString*)getMotionDesc;
+(instancetype)MotionCfgModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
