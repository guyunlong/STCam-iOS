//
//  DevListCell.h
//  STCam
//
//  Created by guyunlong on 10/5/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceModel.h"
typedef NS_ENUM(NSInteger, DeviceListBtnType){
    DeviceListBtnType_None,
    DeviceListBtnType_Playback,
    DeviceListBtnType_Setting,
    DeviceListBtnType_Share
};
@interface DevListCell : UITableViewCell
@property(nonatomic,strong)DeviceModel * model;
@property(nonatomic,copy)void (^btnClickBlock)(DeviceListBtnType type);
+ (instancetype)DevListCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
+(CGFloat)cellHeight;
@end
