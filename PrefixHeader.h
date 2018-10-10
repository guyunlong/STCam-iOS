//
//  PrefixHeader.pch
//
//
//  Created by sks on 16/3/14.
//  Copyright © 2016年. All rights reserved.
//

#import <Availability.h>

#ifndef __IPHONE_3_0
#warning "This project uses features only available in iOS SDK 3.0 and later."
#endif

#ifdef __OBJC__


#ifndef PrefixHeader_pch
#define PrefixHeader_pch
/*颜色*/
#define FFGreen [UIColor colorWithHexString:@"0x80e186"]
#define FFYellow [UIColor colorWithHexString:@"f18c32"]
#define FFRed [UIColor colorWithHexString:@"e30b20"]
#define iOS_Version [[[UIDevice currentDevice] systemVersion] floatValue]
#define FFDevice_Is_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define FFDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define FFDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define FFDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


/*加载图片default*/
#define FFIconImage [UIImage imageNamed:@"head"]
#define FFCoverImage [UIImage imageNamed:@"cover"]
#define FFDefaultImage [UIImage imageWithColor:FFYellow withFrame:CGRectMake(0, 0, FFScreenWith, 200)]
#define FFLightGreyImage [UIImage imageWithColor:[UIColor colorWithHexString:@"0xdddddd"] withFrame:CGRectMake(0, 0, FFScreenWith, 200)]
#define FFLightGreenImage [UIImage imageWithColor:[UIColor colorWithHexString:@"0x80e186"] withFrame:CGRectMake(0, 0, FFScreenWith, 200)]
/**
 *  屏幕的宽
 * */
#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenWith [UIScreen mainScreen].bounds.size.width
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
/**
 *屏幕的高
 */
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "MBProgressHUD.h"
#import "UIColor+Expanded.h"
#import "UIImage+Common.h"
#import "UITableView+Common.h"
#import "NSString+Common.h"
#import "UIView+Common.h"
#import "NSDate+Helper.h"
#import "NSDate+Common.h"
#import "UIButton+Common.h"
#import <Masonry/Masonry.h>
#import "MASConstraint.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "UITableView+Common.h"


#import "MBProgressHUD+Add.h"
#import "UIViewController+HUD.h"

#define  kMainColor [UIColor colorWithHexString:@"0x2197d8"]
#define  kDeepMainColor [UIColor colorWithHexString:@"0x41b7f8"]
#define  kLightGrayColor [UIColor colorWithHexString:@"0x969696"]
#define kHeightCoefficient kScreenHeight/667.0
#define kWidthCoefficient kScreenWidth/375.0

#define kPadding 10*kWidthCoefficient
#define kSafeAreaBottomHeight (kScreenHeight == 812.0 ? 34 : 0)
#define kSafeAreaHeaderHeight (kScreenHeight == 812.0 ? 44 : 20)
#define kButtonHeight 40*kWidthCoefficient
#endif /* PrefixHeader_pch */

#define serverIP @"211.149.199.247"
#define ServerPort  800
#endif

