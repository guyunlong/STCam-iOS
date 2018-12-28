//
//  PowerOnOffAlertView.h
//  GRAVE
//
//  Created by guyunlong on 2018/12/25.
//  Copyright © 2018年 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PowerConfigModel.h"
@interface PowerOnOffAlertView : UIView

/**
 确认按钮，取消按钮
 */
@property(copy,nonatomic)void (^btnClickBlock)(NSInteger channel);
@property(nonatomic,strong)PowerConfigModel * model;
+(CGSize)viewSize;
@end
