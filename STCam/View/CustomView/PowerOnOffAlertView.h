//
//  PowerOnOffAlertView.h
//  GRAVE
//
//  Created by guyunlong on 2018/12/25.
//  Copyright © 2018年 South. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PowerOnOffAlertView : UIView
@property(copy,nonatomic)void (^btnClickBlock)(NSInteger channel);
+(CGSize)viewSize;
@end
