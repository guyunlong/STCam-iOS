//
//  AlarmListCell.h
//  STCam
//
//  Created by guyunlong on 10/11/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmImageModel.h"
@interface AlarmListCell : UITableViewCell
+(instancetype)AlarmListCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@property(nonatomic,strong)AlarmImageModel * model;
@property(nonatomic,weak)IBOutlet UIImageView * alarmImageView;
+(CGFloat)cellHeight;
@end
