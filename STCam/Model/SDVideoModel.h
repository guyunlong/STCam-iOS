//
//  SDVideoModel.h
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDVideoModel : NSObject
@property(nonatomic,strong) NSString * sdVideo;
@property(nonatomic,strong) NSString * url;
@property(nonatomic,assign) NSInteger FileSize;
-(NSString *)getSdVideoName;
-(NSString*)getFileSizeDes;
+(instancetype)SDVideoModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
