//
//  PowerConfigModel.h
//  GRAVE
//
//  Created by guyunlong on 2018/12/27.
//  Copyright © 2018年 South. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PowerConfigModel : NSObject
@property(nonatomic,assign) BOOL PowerOnActive;
@property(nonatomic,assign) NSInteger PowerOnHour;
@property(nonatomic,assign) NSInteger PowerOnMinute;
@property(nonatomic,assign) NSInteger PowerOffDelayMinute;
+(instancetype)PowerConfigModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
