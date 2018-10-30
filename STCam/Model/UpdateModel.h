//
//  UpdateModel.h
//  STCam
//
//  Created by coverme on 2018/10/30.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateModel : NSObject
@property(nonatomic,strong) NSString* ver;
@property(nonatomic,strong) NSString* url;
@property(nonatomic,strong) NSString* memo;
+(instancetype)UpdateModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

/**
 如果当前版本高于或者等于服务器版本，那么为最新版本，返回YES
 */
-(BOOL)checkIsLocalAlreadyNewerVersion;
@end
