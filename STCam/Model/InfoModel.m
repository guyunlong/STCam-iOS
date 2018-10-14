//
//  InfoModel.m
//  STCam
//
//  Created by guyunlong on 10/14/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "InfoModel.h"

@implementation InfoModel
-(id)init{
    self = [super init];
    if (self) {
        _title = @"";
        _info = @"";
    }
    return self;
}
@end
