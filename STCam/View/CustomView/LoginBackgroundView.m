//
//  LoginBackgroundView.m
//  STCam
//
//  Created by guyunlong on 10/3/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "LoginBackgroundView.h"
#define mianBodyColor(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@implementation LoginBackgroundView

//重写此方法，用Quartz2D画出中间分割线
-(void)drawRect:(CGRect)rect{
     CGContextRef
    context = UIGraphicsGetCurrentContext();
     CGContextSetLineWidth(context,0.7);
     CGContextBeginPath(context);
     CGContextMoveToPoint(context,0,40);
     CGContextAddLineToPoint(context,self.frame.size.width,40);
     CGContextClosePath(context);
     [mianBodyColor(207, 207, 207)setStroke];
     CGContextStrokePath(context);
}

@end
