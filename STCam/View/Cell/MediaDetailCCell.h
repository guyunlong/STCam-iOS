//
//  MediaDetailCCell.h
//  STCam
//
//  Created by guyunlong on 10/10/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMediaModel.h"
#define MediaDetailCCellIdentify @"MediaDetailCCellIdentify"
@interface MediaDetailCCell : UICollectionViewCell
+(CGSize)ccellSize;
@property (strong, nonatomic) STMediaModel *model;
@property (copy, nonatomic) void (^checkBlock)();
@end
