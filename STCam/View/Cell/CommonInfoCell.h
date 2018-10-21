//
//  CommonInfoCell.h
//  STCam
//
//  Created by guyunlong on 10/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"
@interface CommonInfoCell : UITableViewCell
@property(nonatomic,strong)InfoModel*model;
+(CGFloat)cellHeight;
+ (instancetype)CommonInfoCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
