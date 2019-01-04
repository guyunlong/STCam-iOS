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
        case ButtonStyleStyleGray:
            self.layer.cornerRadius = 5;
            self.layer.masksToBounds = true;
            [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x969696"]] forState:UIControlStateNormal];
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
        case ButtonStyleHollowAppTheme:
            self.layer.cornerRadius = 5;
            self.layer.masksToBounds = true;
            [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [self setTitleColor:kLightGrayColor forState:UIControlStateNormal];
            self.layer.borderWidth = 0.5;
            self.layer.borderColor =kMainColor.CGColor;
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
        case ButtonStyleText_Gray_Right:
            [self setTitleColor:kLightGrayColor forState:UIControlStateNormal];
            [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            break;
        case ButtonStyleText_Time_button:
            self.layer.cornerRadius = 5;
            self.layer.masksToBounds = true;
            [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xbbbbbb"]] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case ButtonStyleDoorTheme:
            [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [self setTitleColor:kMainColor forState:UIControlStateNormal];
            self.layer.borderWidth = 0.5;
            self.layer.borderColor =kMainColor.CGColor;
            [self setBackgroundImage:[UIImage imageWithColor:kMainColor] forState:UIControlStateSelected];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [self setTitleColor:kMainColor forState:UIControlStateDisabled];
            [self setBackgroundImage:[UIImage imageWithColor:kLightGrayColor] forState:UIControlStateDisabled];
            break;
        default:
            break;
    }
}
@end
