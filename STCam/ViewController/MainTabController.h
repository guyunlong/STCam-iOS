//
//  MainTabController.h
//  STCam
//
//  Created by guyunlong on 8/27/18.
//  Copyright © 2018 South. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabController : UITabBarController
-(id)initWithVisitorMode:(BOOL)visitorMode;
@property(nonatomic,assign)BOOL visitorMode;
@end
