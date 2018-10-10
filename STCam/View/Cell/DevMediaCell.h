//
//  DevMediaCell.h
//  STCam
//
//  Created by guyunlong on 10/10/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceModel.h"
@interface DevMediaCell : UITableViewCell
@property(nonatomic,strong)DeviceModel * model;
+ (instancetype)DevMediaCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
+(CGFloat)cellHeight;
@end
