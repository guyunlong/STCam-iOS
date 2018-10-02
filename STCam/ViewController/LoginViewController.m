//
//  LoginViewController.m
//  STCam
//
//  Created by guyunlong on 8/27/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "LoginViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "PrefixHeader.h"
@interface LoginViewController ()
@property(nonatomic,strong)TPKeyboardAvoidingScrollView * mainScrollView;
@property(nonatomic,strong)UIImageView * iconImageView;

@property(nonatomic,strong)UIButton  * loginButton;
@property(nonatomic,strong)UIButton  * registerButton;
@property(nonatomic,strong)UIButton  * visitorButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //隐藏返回按钮
    self.navigationItem.hidesBackButton = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //禁止页面左侧滑动返回，注意，如果仅仅需要禁止此单个页面返回，还需要在viewWillDisapper下开放侧滑权限    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    

}
-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"action_sign_in".localizedString];
    
    CGFloat y = 20*kWidthCoefficient;
    
    self.edgesForExtendedLayout=UIRectEdgeBottom;//IOS 有导航栏的时候，坐标从(0,64)变成从(0,0)开始
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-100*kWidthCoefficient/2, y, 100*kWidthCoefficient, 100*kWidthCoefficient)];
    [_iconImageView setImage:[UIImage imageNamed:@"appicon100"]];
    _iconImageView.layer.cornerRadius = 8;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.borderColor = kMainColor.CGColor;
    _iconImageView.layer.borderWidth=0.5;
    [self.view addSubview:_iconImageView];
    
    y = kScreenHeight -  kSafeAreaBottomHeight - 350;
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, kButtonHeight)];
    [_loginButton setAppThemeType:ButtonStyleStyleAppTheme];
    [_loginButton setTitle:@"action_sign_in".localizedString forState:UIControlStateNormal];
    [self.view addSubview:_loginButton];
    
    y += kButtonHeight + 3*kPadding;
    _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, kButtonHeight)];
    [_registerButton setAppThemeType:ButtonStyleHollow];
    [_registerButton setTitle:@"action_Register".localizedString forState:UIControlStateNormal];
    [self.view addSubview:_registerButton];
    
    y += kButtonHeight + kPadding;
    _visitorButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, kButtonHeight)];
    [_visitorButton setAppThemeType:ButtonStyleText_Blue];
    [_visitorButton setTitle:@"action_visitor".localizedString forState:UIControlStateNormal];
    [self.view addSubview:_visitorButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
