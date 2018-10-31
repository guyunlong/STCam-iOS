//
//  UIViewController+Utils.h
//  miliao
//
//  Created by covermesite on 2017/7/5.
//  Copyright © 2017年 CoverMe. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIViewController (Utils)

+(UIViewController*) currentViewController;


/**
 是否是nav

 @param ctl <#ctl description#>
 @return <#return value description#>
 */
+(bool) haveNavigationController:(UIViewController*)ctl;

/**
 是否具有上一级的nav

 @param ctl <#ctl description#>
 @return <#return value description#>
 */
+(bool) havePreNavigationController:(UIViewController*)ctl;
@end
