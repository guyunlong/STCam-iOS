//
//  RecConfigModel.h
//  STCam
//
//  Created by guyunlong on 10/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecConfigModel : NSObject
@property(nonatomic,assign) NSInteger Rec_RecStyle;
@property(nonatomic,assign) NSInteger Rec_IsRecAudio;
@property(nonatomic,assign) NSInteger Rec_RecStreamType;
@property(nonatomic,assign) NSInteger Rec_AlmTimeLen;
@property(nonatomic,assign) NSInteger Rec_NmlTimeLen;

+(instancetype)RecConfigModelWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

-(void)setRec_AlmTimeLenChoice:(NSInteger)choice;
-(NSString*)getRecordLenDesc;
@end
