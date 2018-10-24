//
//  SSIDModel.h
//  STCam
//
//  Created by guyunlong on 10/23/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSIDModel : NSObject
@property(nonatomic,strong) NSString* SSID;
@property(nonatomic,assign) NSInteger Siganl;
-(NSString *)getSSIDSignalDesc;
+(instancetype)SSIDModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
