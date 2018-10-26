//
//  STSlider.m
//  STCam
//
//  Created by cc on 2018/10/26.
//  Copyright © 2018 South. All rights reserved.
//

#import "STSlider.h"

@implementation STSlider

-(id)init{
    self = [super init];
    if (self) {
        UIImage *thumbImage = [UIImage imageNamed:@"sliderthumb"];
//        //设置轨道的图片
//
//        [slider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
//
//        [slider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
        
        
        
        //设置滑块的图片
        
        //[slider setThumbImage:thumbImage forState:UIControlStateHighlighted];
        
        [self setThumbImage:thumbImage forState:UIControlStateNormal];
    }
    return self;
}

@end
