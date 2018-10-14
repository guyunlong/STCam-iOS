//
//  CommonSettingCell.h
//  STCam
//
//  Created by guyunlong on 10/14/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"
@interface CommonSettingCell : UITableViewCell

@property(nonatomic,strong)InfoModel*model;
+ (instancetype)CommonSettingCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
+(CGFloat)cellHeight;
@end
