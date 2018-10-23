//
//  SearchDeviceCell.h
//  STCam
//
//  Created by coverme on 2018/10/23.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceModel.h"
@interface SearchDeviceCell : UITableViewCell
@property(nonatomic,strong)DeviceModel * model;
+ (instancetype)SearchDeviceCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
+(CGFloat)cellHeight;
@end
