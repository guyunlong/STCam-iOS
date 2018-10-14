//
//  DevListCell.h
//  STCam
//
//  Created by guyunlong on 10/5/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceModel.h"

@interface DevListCell : UITableViewCell
@property(nonatomic,strong)DeviceModel * model;
@property(nonatomic,copy)void (^btnClickBlock)(NSInteger channel);
+ (instancetype)DevListCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
+(CGFloat)cellHeight;
@end
