//
//  DoorConfigAlertView.h
//  STCam
//
//  Created by guyunlong on 2019/1/3.
//  Copyright © 2019年 South. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoorConfigAlertView : UIView
@property(copy,nonatomic)void (^btnClickBlock)(NSInteger channel);
@property(nonatomic,strong)NSMutableArray * doorConfigList;
+(CGSize)viewSize;
@end
