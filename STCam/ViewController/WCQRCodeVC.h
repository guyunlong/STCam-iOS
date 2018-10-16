//
//  WCQRCodeVC.h
//  STCam
//
//  Created by guyunlong on 10/16/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@protocol QRCodeDelegate <NSObject>
- (void)SCanQRCodeResult:(NSString*)result;
@end

@interface WCQRCodeVC : RootViewController

@property (nonatomic, weak) id<QRCodeDelegate> delegate;

@end
