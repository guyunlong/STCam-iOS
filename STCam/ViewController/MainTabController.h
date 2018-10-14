//
//  MainTabController.h
//  STCam
//
//  Created by guyunlong on 8/27/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevListViewModel.h"
@interface MainTabController : UITabBarController
-(id)initWithUserMode:(TUserMode)userMode;
@property(nonatomic,assign)TUserMode userMode;
@end
