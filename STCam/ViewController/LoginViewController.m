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
#import "LoginBackgroundView.h"
#import "BasicTextField.h"
#import "BEMCheckBox.h"
#import "LoginViewModel.h"
#import "MainTabController.h"
#import "RegisterAccountController.h"
#import "ForgetPwdController.h"
#define checkboxwidth 16
#define TextColor [UIColor colorWithHexString:@"0x535353"]
#define TextFont [UIFont systemFontOfSize:14]
#define textFieldColor(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define mianBodyColor(r, g, b)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@interface LoginViewController ()<UITextFieldDelegate,BEMCheckBoxDelegate>
@property(nonatomic,strong)TPKeyboardAvoidingScrollView * mainScrollView;
@property(nonatomic,strong)UIImageView * iconImageView;
@property(nonatomic,strong)   LoginBackgroundView *backgroundView;
@property (nonatomic, strong) BasicTextField *userTextField;
@property (nonatomic, strong) BasicTextField *passwordTextField;

@property(nonatomic,strong)UIButton  * loginButton;
@property(nonatomic,strong)BEMCheckBox  * rememberCheckBox;
@property (nonatomic, strong) UILabel* rememberTitleLb;
@property(nonatomic,strong)UIButton  * forgotButton;
@property(nonatomic,strong)UIButton  * registerButton;
@property(nonatomic,strong)UIButton  * visitorButton;

@property (nonatomic, assign) BOOL isUserEmpty;
@property (nonatomic, assign) BOOL isPasswordEmpty;

@property (nonatomic,strong) LoginViewModel * viewModel;
@property(nonatomic,strong)UIAlertController  *forceLoginAlertController;//强制登录
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //隐藏返回按钮
    self.navigationItem.hidesBackButton = YES;
    
    [self initViewModel];
}

-(void)initViewModel{
    _viewModel = [LoginViewModel new];
    [_userTextField setText:self.viewModel.user];
    [_passwordTextField setText:self.viewModel.password];
    [_rememberCheckBox setOn:self.viewModel.remember];
    if (self.viewModel.remember) {
        [_rememberTitleLb setTextColor:kMainColor];
    }
    else{
        [_rememberTitleLb setTextColor:TextColor];
    }
    
    RAC(self.viewModel, user)  = self.userTextField.rac_textSignal;
    RAC(self.viewModel, password)  = self.passwordTextField.rac_textSignal;
    RAC(self.loginButton, enabled) = self.viewModel.validLoginSignal;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //禁止页面左侧滑动返回，注意，如果仅仅需要禁止此单个页面返回，还需要在viewWillDisapper下开放侧滑权限    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    if (_logout) {
        _logout = NO;
        [self presentViewController:self.forceLoginAlertController animated:YES completion:nil];
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
    
  
    
    self.edgesForExtendedLayout=UIRectEdgeBottom;//IOS 有导航栏的时候，坐标从(0,64)变成从(0,0)开始
    _mainScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.frame];
    CGFloat y = 40*kWidthCoefficient;
    [self.view addSubview:_mainScrollView];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-100*kWidthCoefficient/2, y, 100*kWidthCoefficient, 100*kWidthCoefficient)];
#if TARGETTYPE == 0
    [_iconImageView setImage:[UIImage imageNamed:@"appicon100"]];
#elif TARGETTYPE == 1
    [_iconImageView setImage:[UIImage imageNamed:@"appicon100"]];
#else
    [_iconImageView setImage:[UIImage imageNamed:@"appicon100_door"]];
#endif
    
    _iconImageView.layer.cornerRadius = 8;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.borderColor = kMainColor.CGColor;
    _iconImageView.layer.borderWidth=0.5;
    [_mainScrollView addSubview:_iconImageView];
    
    y += 100*kWidthCoefficient + 20*kWidthCoefficient;
    [self addLoginBackgroundView:y];
    
    [self customUserTextField:self.backgroundView.frame];
    [self customPasswordTextField:self.backgroundView.frame];
    
    y += 80*kWidthCoefficient + 20*kWidthCoefficient;
    
    if (!_rememberCheckBox) {
        _rememberCheckBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(2*kPadding,y, checkboxwidth, checkboxwidth)];
        [_rememberCheckBox setDelegate:self];
        [_rememberCheckBox setOnTintColor:kMainColor];
        [_rememberCheckBox setOnCheckColor:kMainColor];
        
        _rememberCheckBox.lineWidth = 2;
        _rememberCheckBox.onAnimationType = BEMAnimationTypeBounce;
        _rememberCheckBox.offAnimationType = BEMAnimationTypeBounce;
        _rememberCheckBox.boxType = BEMBoxTypeSquare;
        [_mainScrollView addSubview:_rememberCheckBox];
    }
    if (!_rememberTitleLb) {
        _rememberTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(2*kPadding+checkboxwidth+10, y, 100*kWidthCoefficient, 16)];
        [_rememberTitleLb setFont:TextFont];
        [_rememberTitleLb setTextColor:TextColor];
        [_rememberTitleLb setNumberOfLines:0];
        [_mainScrollView addSubview:_rememberTitleLb];
        [_rememberTitleLb setText:@"action_check_remeber_pwd".localizedString];
    }
    
    _forgotButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-2*kPadding-120*kWidthCoefficient, y, 120*kWidthCoefficient, checkboxwidth)];
    [_forgotButton setAppThemeType:ButtonStyleText_Gray_Right];
    [_forgotButton setTitle:@"action_Forgetpwd".localizedString forState:UIControlStateNormal];
    [_forgotButton.titleLabel setFont:TextFont];
    [_mainScrollView addSubview:_forgotButton];
    
    y += 20*kWidthCoefficient + 20*kWidthCoefficient;
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, kButtonHeight)];
    [_loginButton setAppThemeType:ButtonStyleStyleAppTheme];
    [_loginButton setTitle:@"action_sign_in".localizedString forState:UIControlStateNormal];
    [_mainScrollView addSubview:_loginButton];
    [_loginButton addTarget:self action:@selector(loginClicked) forControlEvents:UIControlEventTouchUpInside];
    
    y += kButtonHeight + 3*kPadding;
    _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, kButtonHeight)];
    [_registerButton setAppThemeType:ButtonStyleHollow];
    [_registerButton setTitle:@"action_Register".localizedString forState:UIControlStateNormal];
    [_mainScrollView addSubview:_registerButton];
    
    y += kButtonHeight + kPadding;
    _visitorButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, kButtonHeight)];
    [_visitorButton setAppThemeType:ButtonStyleText_Blue];
    [_visitorButton setTitle:@"action_visitor".localizedString forState:UIControlStateNormal];
    [_mainScrollView addSubview:_visitorButton];
    
     [_visitorButton addTarget:self action:@selector(visitorModeClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_registerButton addTarget:self action:@selector(registerClicked) forControlEvents:UIControlEventTouchUpInside];
    [_forgotButton addTarget:self action:@selector(forgotClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)addLoginBackgroundView:(CGFloat)y{
    CGFloat  backgroundX = 20*kWidthCoefficient;
    CGFloat  backgroundY = y;
    CGFloat   backgroundW = kScreenWidth - 40*kWidthCoefficient;
    CGFloat backgroundH = 80*kWidthCoefficient;
    self.backgroundView  = [[LoginBackgroundView alloc] initWithFrame:CGRectMake(backgroundX, backgroundY, backgroundW,  backgroundH)];
    [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
    [self.backgroundView.layer setCornerRadius:5.0];
    [self.backgroundView.layer setBorderWidth:1.0];
    [self.backgroundView.layer setBorderColor:textFieldColor(207, 207, 207).CGColor];
    [_mainScrollView addSubview:self.backgroundView];
}

- (void)customUserTextField:(CGRect)frame{
    self.userTextField = [[BasicTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40*kWidthCoefficient)];
    //self.userTextField.keyboardType  = UIKeyboardTypeNumberPad;
    self.userTextField.delegate = self;
    self.userTextField.tag  = 7;
    self.userTextField.placeholder = @"string_input_email_address".localizedString;
    [self.userTextField setFont:[UIFont systemFontOfSize:14]];
    UIImageView *userTextFieldImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_user"]];
    self.userTextField.leftView = userTextFieldImage;
    self.userTextField.leftViewMode = UITextFieldViewModeAlways;
    self.userTextField.clearButtonMode = UITextFieldViewModeAlways;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.userTextField];
    self.isPasswordEmpty = YES;
    [self.backgroundView addSubview:self.userTextField];
}
- (void)customPasswordTextField:(CGRect)frame{
    self.passwordTextField = [[BasicTextField alloc] initWithFrame:CGRectMake(0, 40*kWidthCoefficient, frame.size.width, 40*kWidthCoefficient)];
    self.passwordTextField.delegate = self;
    self.passwordTextField.tag = 11;
    self.passwordTextField.placeholder = @"string_pwd".localizedString;
    [self.passwordTextField setFont:[UIFont systemFontOfSize:14]];
    UIImageView *passwordTextFieldImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pwd"]];
    self.passwordTextField.leftView = passwordTextFieldImage;
    self.passwordTextField.leftViewMode =
    UITextFieldViewModeAlways;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.passwordTextField.secureTextEntry = YES;
    //设置监听
//    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(passwordTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.passwordTextField];
    self.isUserEmpty = YES;
    [self.backgroundView addSubview:self.passwordTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma methods
-(void)registerClicked{
    
    RegisterAccountController * ctl  = [[RegisterAccountController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}
-(void)forgotClicked{
    ForgetPwdController * ctl  = [[ForgetPwdController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}
//支持旋转
-(BOOL)shouldAutorotate{
    return NO;
}

//支持的方向 因为界面A我们只需要支持竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
//一开始的方向  很重要

-(void)loginClicked{
    [self.view endEditing:YES];
    [self showHudInView:self.view hint:nil];
    @weakify(self)
    [[_viewModel racLogin:NO] subscribeNext:^(id x) {
        @strongify(self)
        [self hideHud];
        if ([x integerValue] == 1)
       //if(YES)
        {
           //跳转到tab页面
            
            MainTabController * mainTabController = [[MainTabController alloc] initWithUserMode:TUserMode_Login];
            [self presentViewController:mainTabController animated:YES completion:^{
                
            }];
        }
        else if([x integerValue] == RESULT_USER_LOGOUT || [x integerValue] == RESULT_USER_LOGINED){
            //
            [self presentViewController:self.forceLoginAlertController animated:YES completion:nil];
        }
        else if([x integerValue] == 100000){
            [self showHint:@"Network_error".localizedString];
        }
        else{
            [self showHint:@"error_login_failed".localizedString];
        }
    }];
}
-(void)forceLogin{
     [self showHudInView:self.view hint:nil];
    @weakify(self)
    [[_viewModel racLogin:YES] subscribeNext:^(id x) {
         @strongify(self)
        [self hideHud];
        if ([x integerValue] == 1)
            //if(YES)
        {
            //跳转到tab页面
           
            MainTabController * mainTabController = [[MainTabController alloc] initWithUserMode:TUserMode_Login];
            [self presentViewController:mainTabController animated:YES completion:^{
                
            }];
        }
        else if([x integerValue] == RESULT_USER_LOGOUT || [x integerValue] == RESULT_USER_LOGINED){
            //
            [self presentViewController:self.forceLoginAlertController animated:YES completion:nil];
        }
        else{
            [self showHint:@"error_login_failed".localizedString];
        }
    }];
}
-(void)visitorModeClicked{
    MainTabController * mainTabController = [[MainTabController alloc] initWithUserMode:TUserMode_Visitor];
    [self presentViewController:mainTabController animated:YES completion:nil];
}

-(UIAlertController*)forceLoginAlertController{
    if (!_forceLoginAlertController) {
        @weakify(self)
        _forceLoginAlertController = [UIAlertController alertControllerWithTitle:@"string_user_logined1".localizedString message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"action_cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        
        UIAlertAction *existction = [UIAlertAction actionWithTitle:@"action_ok".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self forceLogin];
           
            
        }];
        [_forceLoginAlertController addAction:existction];
        [_forceLoginAlertController addAction:cancelAction];
        
    }
    return _forceLoginAlertController;
}


#pragma checkbox
- (void)didTapCheckBox:(BEMCheckBox*)checkBox{
    BOOL value = checkBox.on;
    _viewModel.remember =value;
    if (value) {
        [_rememberTitleLb setTextColor:kMainColor];
    }
    else{
        [_rememberTitleLb setTextColor:TextColor];
    }
    
}

@end
