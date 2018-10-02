//
//  NSObject+UIButton_Common.m
//  STCam
//
//  Created by guyunlong on 10/2/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "UIButton+Common.h"
#import "PrefixHeader.h"
@implementation UIButton (Common)
- (void)setAppThemeType:(ButtonStyle)style{
    switch (style) {
        case ButtonStyleStyleAppTheme:
            self.layer.cornerRadius = 5;
            self.layer.masksToBounds = true;
            [self setBackgroundImage:[UIImage imageWithColor:kMainColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case ButtonStyleHollow:
            self.layer.cornerRadius = 5;
            self.layer.masksToBounds = true;
            [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [self setTitleColor:kLightGrayColor forState:UIControlStateNormal];
            self.layer.borderWidth = 0.5;
            self.layer.borderColor =kLightGrayColor.CGColor;
            break;
        case ButtonStyleText_Blue:
           [self setTitleColor:kMainColor forState:UIControlStateNormal];
            [self setTitleColor:kDeepMainColor forState:UIControlStateHighlighted];
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            break;
        case ButtonStyleText_Gray:
            [self setTitleColor:kLightGrayColor forState:UIControlStateNormal];
            [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            break;
        default:
            break;
    }
}
@end
