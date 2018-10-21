//
//  PushSettingModel.h
//  STCam
//
//  Created by guyunlong on 10/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushSettingModel : NSObject
@property(nonatomic,assign) BOOL PushActive;
@property(nonatomic,assign) NSInteger PushInterval;
@property(nonatomic,assign) NSInteger PushIntervalLevel;
@property(nonatomic,assign) NSInteger PIRSensitive;
+(instancetype)PushSettingModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

-(NSString*)getPushActiveDes;

-(NSString*)getPushIntervalDesc;

-(NSString*)getPIRSensitiveDesc;

-(NSInteger)getPushIntervalLevel;
-(void)setPushIntervalLevel:(NSInteger)PushIntervalLevel;
@end
