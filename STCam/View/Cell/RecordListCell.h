//
//  RecordListCell.h
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDVideoModel.h"
@interface RecordListCell : UITableViewCell
@property(nonatomic,strong)SDVideoModel * model;
+ (instancetype)RecordListCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath ;
+(CGFloat)cellHeight;
@end
