//
//  UISegmentedControl+FFCategory.m
//  KK3_14
//
//  Created by sks on 16/3/16.
//  Copyright © 2016年 FF. All rights reserved.
//

#import "UISegmentedControl+Category.h"

@implementation UISegmentedControl (Category)
+(UISegmentedControl *)segumentedControlWithItems:(NSArray *)itemsArray frame:(CGRect )rect tinColor:(UIColor *)tinColor didUnselectedTitleFont:(UIFont *)didUnselectedTitleFont didselectedTitleFont:(UIFont *)didselectedTitleFont addTarget:(id)target action:(SEL)action {
    UISegmentedControl * segmentedControl=[[UISegmentedControl alloc]initWithItems:itemsArray ];
    segmentedControl.frame=rect;
    segmentedControl.tintColor=tinColor;
    //修改字体的默认颜色与选中颜色
    //修改字体的默认颜色
    
    NSDictionary *dicUnselected = [NSDictionary dictionaryWithObjectsAndKeys:  didUnselectedTitleFont,UITextAttributeFont ,[UIColor clearColor],UITextAttributeTextShadowColor ,nil];
    [segmentedControl setTitleTextAttributes:dicUnselected forState:UIControlStateNormal];
    
    //修改字体的选中颜色
    NSDictionary *dicselected = [NSDictionary dictionaryWithObjectsAndKeys:didselectedTitleFont,UITextAttributeFont ,[UIColor clearColor],UITextAttributeTextShadowColor ,nil];
    [segmentedControl setTitleTextAttributes:dicselected forState:UIControlStateSelected];
//    _segmentedControl.selectedSegmentIndex=0;
    [segmentedControl addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    return segmentedControl;
}
@end
