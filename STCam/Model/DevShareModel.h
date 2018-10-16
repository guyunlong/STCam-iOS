//
//  DevShareModel.h
//  STCam
//
//  Created by coverme on 10/16/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DevShareModel : NSObject
@property(nonatomic,strong) NSString * SN;
@property(nonatomic,strong) NSString * From;
@property(nonatomic,strong) NSString * Pwd;
@property(nonatomic,assign) BOOL IsVideo;
@property(nonatomic,assign) BOOL IsHistory;
@property(nonatomic,assign) BOOL IsPush;
@property(nonatomic,assign) BOOL IsControl;
-(NSString*)localDescription;
@end
