//
//  DoorHandelCCell.h
//  STCam
//
//  Created by guyunlong on 2019/1/3.
//  Copyright © 2019年 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#define doorHandleBtnWidth (kScreenWidth-2*kPadding)/5
#define doorHandleBtnHeight 40
#define DoorHandelCCellIdentify @"DoorHandelCCellIdentify"
@interface DoorHandelCCell : UICollectionViewCell
@property (strong, nonatomic) NSString *title;
+(CGSize)ccellSize;
@end
