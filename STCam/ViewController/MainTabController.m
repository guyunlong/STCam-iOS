//
//  MainTabController.m
//  STCam
//
//  Created by guyunlong on 8/27/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "MainTabController.h"
#import "DevListViewController.h"
#import "AlarmListViewController.h"
#import "MediaViewController.h"
#import "MoreViewController.h"
#import "STNavigationController.h"
#import "PrefixHeader.h"
@interface MainTabController ()<UITabBarControllerDelegate>
@property(nonatomic,strong)STNavigationController *devListNav;
@property(nonatomic,strong)STNavigationController *mediaNav;
@property(nonatomic,strong)STNavigationController *alarmListNav;
@property(nonatomic,strong)STNavigationController * moreNav;
@end

@implementation MainTabController
-(id)initWithUserMode:(TUserMode)userMode{
    self = [super init];
    if (self) {
        [self setUserMode:userMode];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [[UITabBar appearance] setTintColor:kMainColor];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_devListNav){
        return;
    }
    _devListNav= ( {
        DevListViewModel * viewModel = [DevListViewModel sharedDevListViewModel];
        [viewModel setUserMode:_userMode];
        DevListViewController * ctl = [[DevListViewController alloc] initWithViewModel:viewModel];
        UIImage *image = [UIImage imageNamed:@"tab_device_nor"];
        UIImage * selectImage = [[UIImage imageNamed:@"tab_device_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ctl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"title_main_dev_list".localizedString image:image selectedImage:selectImage];
        [[STNavigationController alloc] initWithRootViewController:ctl];
    });
    
    _mediaNav= ( {
        MediaViewController * ctl = [[MediaViewController alloc] init];
        UIImage *image = [UIImage imageNamed:@"tab_media_nor"];
        UIImage * selectImage = [[UIImage imageNamed:@"tab_media_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ctl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"action_media".localizedString image:image selectedImage:selectImage];
        [[STNavigationController alloc] initWithRootViewController:ctl];
    });
    
    _alarmListNav= ( {
        AlarmListViewController * ctl = [[AlarmListViewController alloc] init];
        UIImage *image = [UIImage imageNamed:@"tab_alarm_nor"];
        UIImage * selectImage = [[UIImage imageNamed:@"tab_alarm_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ctl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"action_alarm".localizedString image:image selectedImage:selectImage];
        [[STNavigationController alloc] initWithRootViewController:ctl];
    });
    
    _moreNav= ( {
        MoreViewController * ctl = [[MoreViewController alloc] init];
        UIImage *image = [UIImage imageNamed:@"tab_mine_nor"];
        UIImage * selectImage = [[UIImage imageNamed:@"tab_mine_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ctl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"action_mine".localizedString image:image selectedImage:selectImage];
        [[STNavigationController alloc] initWithRootViewController:ctl];
    });
    if (_userMode == TUserMode_Login) {
        self.viewControllers = @[_devListNav,_mediaNav,_alarmListNav,_moreNav];
        self.tabBar.hidden = NO;
    }
    else{
        self.viewControllers = @[_devListNav];
        self.tabBar.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (self.tabBarController.selectedViewController == viewController) {
      
    }
    return YES;
}

-(void) tabBar:(UITabBar *)theTabBar didSelectItem:(UITabBarItem *)item{
    
    
    NSUInteger indexOfTab = [[theTabBar items] indexOfObject:item];
    
   
}

@end
