//
//  SDInfoModel.h
//  STCam
//
//  Created by guyunlong on 10/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDInfoModel : NSObject
@property(nonatomic,strong) NSString* DiskName;
@property(nonatomic,assign) NSInteger DiskSize;
@property(nonatomic,assign) NSInteger FreeSize;
@property(nonatomic,assign) NSInteger MinFreeSize;
+(instancetype)SDInfoModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
-(NSString*)getTotalSizeDesc;
-(NSString*)getFreeSizeDesc;
@end
