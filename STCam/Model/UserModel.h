//
//  UserModel.h
//  STCam
//
//  Created by coverme on 2018/10/30.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property(nonatomic,strong) NSString* User;
@property(nonatomic,strong) NSString* SN;
@property(nonatomic,strong) NSString* DevName;
+(instancetype)UserModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
