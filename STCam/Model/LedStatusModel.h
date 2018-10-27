//
//  ModelLedStatus.h
//  STCam
//
//  Created by guyunlong on 10/27/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AutoModel : NSObject
@property(nonatomic,assign) NSInteger Delay;
@property(nonatomic,assign) NSInteger Lux;
@property(nonatomic,assign) NSInteger Brightness;
+(instancetype)AutoModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
@interface ManualModel : NSObject
@property(nonatomic,assign) NSInteger Brightness;
+(instancetype)ManualModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
@interface TimerModel : NSObject
@property(nonatomic,assign) NSInteger Brightness;
@property(nonatomic,assign) NSInteger StartH;
@property(nonatomic,assign) NSInteger StartM;
@property(nonatomic,assign) NSInteger StopH;
@property(nonatomic,assign) NSInteger StopM;
-(NSString*)getStartTimeDesc;
-(NSString*)getStopTimeDesc;
+(instancetype)TimerModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
@interface D2DModel : NSObject
@property(nonatomic,assign) NSInteger Brightness;
@property(nonatomic,assign) NSInteger Lux;
+(instancetype)D2DModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
@interface LedStatusModel : NSObject
@property(nonatomic,assign) BOOL Status;
@property(nonatomic,assign) NSInteger Mode;
@property(nonatomic,strong) AutoModel* autoModel;
@property(nonatomic,strong) ManualModel* manualModel;
@property(nonatomic,strong) TimerModel* timerModel;
@property(nonatomic,strong) D2DModel* d2dModel;
+(instancetype)LedStatusModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
