//
//  NSObject+UIButton_Common.h
//  STCam
//
//  Created by guyunlong on 10/2/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ButtonStyle) {
    ButtonStyleDefault = 0,
    ButtonStyleStyleAppTheme,
    ButtonStyleStyleGray,
    ButtonStyleHollow,
    ButtonStyleHollowAppTheme,
    ButtonStyleDoorTheme,//门控
    ButtonStyleText_Blue, // 文字按钮样式蓝色
    ButtonStyleText_Gray, // 文字按钮样式灰色
    ButtonStyleText_Gray_Right,
    ButtonStyleText_Time_button
};
@interface UIButton (Common)
- (void)setAppThemeType:(ButtonStyle)style;


@end
