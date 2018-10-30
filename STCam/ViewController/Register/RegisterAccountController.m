//
//  RegisterAccountController.m
//  STCam
//
//  Created by coverme on 2018/10/30.
//  Copyright © 2018 South. All rights reserved.
//

#import "RegisterAccountController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "PrefixHeader.h"
#import "BasicTextField.h"
@interface RegisterAccountController ()
@property(nonatomic,strong)TPKeyboardAvoidingScrollView * mainScrollView;
@property(nonatomic,strong)UIView * topBackView;
@property (nonatomic, strong) BasicTextField *userField;
@property (nonatomic, strong) BasicTextField *pwdField;
@property (nonatomic, strong) BasicTextField *confirmPwdField;
@property (nonatomic, strong) BasicTextField *checkNumField;
@property (nonatomic, strong) UIButton *getCheckNumButton;
@property (nonatomic, strong) UIButton *registerButton;
@end
@implementation RegisterAccountController

-(void)initNav{
    [self setTitle:@"action_Register".localizedString];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 28, 28);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)loadView{
    [super loadView];
    [self initNav];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.edgesForExtendedLayout=UIRectEdgeBottom;//IOS 有导航栏的时候，坐标从(0,64)变成从(0,0)开始
    
    _mainScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_mainScrollView];
    
    
    CGFloat rowHeight = 40*kWidthCoefficient;
    CGFloat prefixWidth = 80*kWidthCoefficient;
    
    CGFloat y = kPadding*3;
    _topBackView = [[UIView alloc] initWithFrame:CGRectMake(kPadding*2, y, kScreenWidth-4*kPadding, 4*rowHeight+3)];
    [self.topBackView setBackgroundColor:[UIColor whiteColor]];
    [self.topBackView.layer setCornerRadius:5.0];
    [self.topBackView.layer setBorderWidth:1.0];
    [self.topBackView.layer setBorderColor:[UIColor colorWithHexString:@"0xcfcfcf"].CGColor];
    [_mainScrollView addSubview:_topBackView];
    
    CGFloat contentY = 0;
    /******************userField*********************/
    
    UILabel *userLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, prefixWidth, rowHeight)];
    [userLb setText:@"string_user".localizedString];
    self.userField = [[BasicTextField alloc] initWithFrame:CGRectMake(0, contentY, kScreenWidth-4*kPadding, rowHeight)];
    
    self.userField.placeholder = @"string_input_email_address".localizedString;
    [self.userField setFont:[UIFont systemFontOfSize:14]];
    
    self.userField.leftView = userLb;
    self.userField.leftViewMode = UITextFieldViewModeAlways;
    [self.topBackView addSubview:self.userField];
    
    contentY += rowHeight;
    UIView * spilt1View =  [[UIView alloc] initWithFrame:CGRectMake(0, contentY,kScreenWidth-4*kPadding, 1)];
    [spilt1View setBackgroundColor:[UIColor colorWithHexString:@"0xcfcfcf"]];
    [self.topBackView addSubview:spilt1View];
    
    contentY += 1;
    /******************pwdField*********************/
    UILabel *pwdLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, prefixWidth, rowHeight)];
    [pwdLb setText:@"string_new_pwd_title".localizedString];
    self.pwdField = [[BasicTextField alloc] initWithFrame:CGRectMake(0, contentY, kScreenWidth-4*kPadding, rowHeight)];
    
    self.pwdField.placeholder = @"string_input_password".localizedString;
    [self.pwdField setFont:[UIFont systemFontOfSize:14]];
    
    self.pwdField.leftView = pwdLb;
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    [self.topBackView addSubview:self.pwdField];
    contentY +=rowHeight;
    UIView * spilt2View =  [[UIView alloc] initWithFrame:CGRectMake(0, contentY,kScreenWidth-4*kPadding, 1)];
    [spilt2View setBackgroundColor:[UIColor colorWithHexString:@"0xcfcfcf"]];
    [self.topBackView addSubview:spilt2View];
    contentY +=1;
    /******************confirmPwdField*********************/
    
    UILabel *confirmLb = [[UILabel alloc] initWithFrame:CGRectMake(0,0, prefixWidth, rowHeight)];
    [confirmLb setText:@"string_confirm_pwd_title".localizedString];
    self.confirmPwdField = [[BasicTextField alloc] initWithFrame:CGRectMake(0, contentY, kScreenWidth-4*kPadding, rowHeight)];
    
    self.confirmPwdField.placeholder = @"string_confirm_new_password".localizedString;
    [self.confirmPwdField setFont:[UIFont systemFontOfSize:14]];
    
    self.confirmPwdField.leftView = confirmLb;
    self.confirmPwdField.leftViewMode = UITextFieldViewModeAlways;
    [self.topBackView addSubview:self.confirmPwdField];
    contentY +=rowHeight;
    UIView * spilt3View =  [[UIView alloc] initWithFrame:CGRectMake(0, contentY,kScreenWidth-4*kPadding, 1)];
    [spilt3View setBackgroundColor:[UIColor colorWithHexString:@"0xcfcfcf"]];
    [self.topBackView addSubview:spilt3View];
    
    contentY +=1;
    /******************checkNumField*********************/
    CGFloat confirmButtonHeight = rowHeight - 8;
    CGFloat confirmButtonWidth = 100*kWidthCoefficient;
     self.checkNumField = [[BasicTextField alloc] initWithFrame:CGRectMake(0, contentY, kScreenWidth-4*kPadding-confirmButtonWidth-8, rowHeight)];
    self.checkNumField.placeholder = @"action_input_verify_code".localizedString;
    [self.checkNumField setFont:[UIFont systemFontOfSize:14]];
    [self.topBackView addSubview:self.checkNumField];
    
    _getCheckNumButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-4*kPadding-4-confirmButtonWidth, contentY+4, confirmButtonWidth, confirmButtonHeight)];
    [_getCheckNumButton setTitle:@"action_get_verify_code".localizedString forState:UIControlStateNormal];
    [_getCheckNumButton setAppThemeType:ButtonStyleStyleAppTheme];
    [self.topBackView  addSubview:_getCheckNumButton];
    /******************registerButton*********************/
    y = CGRectGetMaxY(_topBackView.frame) + 3*kPadding;
    _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, kButtonHeight)];
    [_registerButton setTitle:@"action_Register".localizedString forState:UIControlStateNormal];
    [_registerButton setAppThemeType:ButtonStyleStyleAppTheme];
    [self.view addSubview:_registerButton];
    
    [_registerButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_getCheckNumButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)buttonClick:(id)sender{
    if (sender == _registerButton) {
        
    }
    else if(sender == _getCheckNumButton){
        
    }
}


@end
