//
//  DoorConfigCell.h
//  STCam
//
//  Created by guyunlong on 2019/1/3.
//  Copyright © 2019年 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoorCfgModel.h"
#define DoorConfigCellHeight 40
#define DoorConfigCellIdentify @"DoorConfigCellIdentify"
@interface DoorConfigCell : UITableViewCell
@property(nonatomic,strong)DoorCfgModel * model;
+(CGFloat)cellHeight;
@end
