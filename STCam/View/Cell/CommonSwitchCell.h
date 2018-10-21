//
//  CommonSwitchCell.h
//  STCam
//
//  Created by guyunlong on 10/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"
@interface CommonSwitchCell : UITableViewCell
@property(nonatomic,strong)InfoModel*model;
+ (instancetype)CommonSwitchCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@property(nonatomic,copy)void (^switchValueChangeBlock)(BOOL open);
+(CGFloat)cellHeight;
@end
