//
//  UpdateDevModel.h
//  STCam
//
//  Created by guyunlong on 10/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateDevModel : NSObject
@property(nonatomic,assign) NSInteger ret;
@property(nonatomic,strong) NSString* ver;
@property(nonatomic,strong) NSString* url;
@property(nonatomic,strong) NSString* memo;
@property(nonatomic,assign) NSInteger crc;
+(instancetype)UpdateDevModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
