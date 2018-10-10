//
//  STImageModel.h
//  STCam
//
//  Created by guyunlong on 10/10/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MediaType){
    MediaType_Unknown,
    MediaType_IMG,
    MediaType_VID
};

@interface STMediaModel : NSObject
@property(nonatomic,strong)NSString * fileName;
@property(nonatomic,assign)BOOL check;
-(MediaType)getMediaType;

@end
