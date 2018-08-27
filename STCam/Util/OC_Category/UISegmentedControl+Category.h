//
//  UISegmentedControl+FFCategory.h
//  KK3_14
//
//  Created by sks on 16/3/16.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISegmentedControl (Category)
/**
 *  控制器UISegmentedControl
 *
 *  @param itemsArray             数组按钮
 *  @param rect                   frame
 *  @param tinColor               渲染颜色
 *  @param didUnselectedTitleFont 不选中字体
 *  @param didselectedTitleFont   选中字体
 *  @param target                 点击响应
 *  @param action                 动作
 *
 *  @return SegmentedControl
 */
+(UISegmentedControl *)segumentedControlWithItems:(NSArray *)itemsArray frame:(CGRect )rect tinColor:(UIColor *)tinColor didUnselectedTitleFont:(UIFont *)didUnselectedTitleFont didselectedTitleFont:(UIFont *)didselectedTitleFont addTarget:(id)target action:(SEL)action ;

@end
