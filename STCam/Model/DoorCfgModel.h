//
//  DoorCfgModel.h
//  STCam
//
//  Created by guyunlong on 2019/1/3.
//  Copyright © 2019年 South. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoorCfgModel : NSObject
@property(nonatomic,assign) NSInteger Chl;
@property(nonatomic,assign) BOOL Active;
@property(nonatomic,assign) BOOL Status;
@property(nonatomic,strong) NSString *Name;
+(instancetype)DoorCfgModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
