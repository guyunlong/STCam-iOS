//
//  STImageModel.m
//  STCam
//
//  Created by guyunlong on 10/10/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "STMediaModel.h"

@implementation STMediaModel
-(MediaType)getMediaType{
    if ([_fileName hasSuffix:@"png"]) {
        return MediaType_IMG;
    }
    else if ([_fileName hasSuffix:@"mp4"]) {
        return MediaType_VID;
    }
    return MediaType_Unknown;
}
@end
