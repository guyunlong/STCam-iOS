//
//  RegisterAccountController.m
//  STCam
//
//  Created by coverme on 2018/10/30.
//  Copyright © 2018 South. All rights reserved.
//

#import "ForgetPwdController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "PrefixHeader.h"
#import "BasicTextField.h"
#import "FFHttpTool.h"
#import "RetModel.h"
#import "SouthUtil.h"
@interface ForgetPwdController (){
}
@property(nonatomic,strong)TPKeyboardAvoidingScrollView * mainScrollView;
@property(nonatomic,strong)UIView * topBackView;
@property (nonatomic, strong) BasicTextField *userField;
@property (nonatomic, strong) BasicTextField *pwdField;
@property (nonatomic, strong) BasicTextField *confirmPwdField;
@property (nonatomic, strong) BasicTextField *checkNumField;
@property (nonatomic, strong) UIButton *getCheckNumButton;
@property (nonatomic, strong) UIButton *forgotButton;
@property (nonatomic,strong) NSTimer *coolDownTimer;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger leftTime;
@end
@implementation ForgetPwdController

-(void)initNav{
    [self setTitle:@"action_Forgetpwd".localizedString];
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
    self.pwdField.secureTextEntry = YES;
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
    self.confirmPwdField.secureTextEntry = YES;
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
    _forgotButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, kButtonHeight)];
    [_forgotButton setTitle:@"action_change_login_password".localizedString forState:UIControlStateNormal];
    [_forgotButton setAppThemeType:ButtonStyleStyleAppTheme];
    [self.view addSubview:_forgotButton];
    
    [_forgotButton addTarget:self action:@selector(forgetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_getCheckNumButton addTarget:self action:@selector(getCheckCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)forgetButtonClick{
    [self.view endEditing:YES];
    NSString* email = [_userField text];
    NSString*  password = [_pwdField text];
    NSString*  confirmPassword = [_confirmPwdField text];
    NSString* check =[_checkNumField text];
    
    
    if ([email length] == 0) {
        [self showHint:@"error_field_required".localizedString];
        return;
    }
    else if(!([self validateEmail:email] || [SouthUtil isValidPhone:email] )){
        [self showHint:@"error_invalid_email".localizedString];
        return;
    }
    else if([password length] < 4 || [password length] > 16){
        [self showHint:@"error_invalid_password".localizedString];
        return;
    }
    else if(![password isEqualToString:confirmPassword]){
        [self showHint:@"error_invalid_confirm_password".localizedString];
        return;
    }
    else if([check integerValue] != _code){
        [self showHint:@"error_invalid_checknum".localizedString];
        return;
    }
    NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_user_forgotpsd.asp?user=%@&newpsd=%@&verifycode=%@",serverIP,ServerPort,email,password,check];
    @weakify(self);
    [FFHttpTool GET:url parameters:nil success:^(id data){
        @strongify(self)
        [self hideHud];
        if ([data isKindOfClass:[NSDictionary class]]) {
            RetModel * m = [RetModel RetModelWithDict:data];
            if (m.ret == RESULT_FAIL)
            {
                [self showHint:@"action_reset_pwdr_failed0".localizedString];
            }
            else if (m.ret == RESULT_USER_EXISTS)
            {
                [self showHint:@"action_reset_pwd_failed1".localizedString];
            }
            else if (m.ret == RESULT_USER_VERIFYCODE_ERROR)
            {
                [self showHint:@"action_reset_pwd_failed2".localizedString];
            }
            else if (m.ret == RESULT_USER_VERIFYCODE_TIMEOUT)
            {
                 [self showHint:@"action_reset_pwd_failed3".localizedString];
            }
            else if (m.ret == RESULT_SUCCESS)
            {
                [self showHint:@"action_reset_pwd_success".localizedString];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        else{
            [self showHint:@"action_reset_pwdr_failed0".localizedString];
        }
        
    } failure:^(NSError * error){
        [self showHint:@"action_reset_pwdr_failed0".localizedString];
    }];
    
}
-(void)getCheckCodeButtonClick{
    [self.view endEditing:YES];
    NSString* email = [_userField text];
    NSString*  password = [_pwdField text];
    NSString*  confirmPassword = [_confirmPwdField text];
   
        if ([email length] == 0) {
            [self showHint:@"error_field_required".localizedString];
            return;
        }
        else if(!([self validateEmail:email] || [SouthUtil isValidPhone:email] )){
            [self showHint:@"error_invalid_email".localizedString];
            return;
        }
//        else if([password length] < 4 || [password length] > 16){
//            [self showHint:@"error_invalid_password".localizedString];
//            return;
//        }
//        else if([password isEqualToString:confirmPassword]){
//            [self showHint:@"error_invalid_confirm_password".localizedString];
//            return;
//        }
        NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_user_forgotpsd_send_verifycode.asp?user=%@",serverIP,ServerPort,email];
        @weakify(self);
        [FFHttpTool GET:url parameters:nil success:^(id data){
            @strongify(self)
            [self hideHud];
            if ([data isKindOfClass:[NSDictionary class]]) {
                RetModel * retModel = [RetModel RetModelWithDict:data];
                if ([retModel ret] > RESULT_SUCCESS) {
                    [self showHint:@"action_get_checknum_sent".localizedString];
                    self.code = retModel.ret;
                    [self.getCheckNumButton setEnabled:NO];
                    self.leftTime = 60;
                    [self coolDownTimer];
                }
                if (retModel.ret == RESULT_USER_NOTEXISTS)
                {
                    [self showHint:@"action_no_user".localizedString];
                }
                else if (retModel.ret == RESULT_USER_EXISTS)
                {
                    [self showHint:@"action_get_checknum_aleady_register".localizedString];
                }
                
            }
            else{
                [self showHint:@"action_get_checknum_sent_failed".localizedString];
            }
            
        } failure:^(NSError * error){
            [self showHint:@"action_get_checknum_sent_failed".localizedString];
        }];
        
   
}
- (BOOL) validateEmail: (NSString *) strEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:strEmail];
}

-(NSTimer*)coolDownTimer{
    if (!_coolDownTimer) {
        @weakify(self)
        _coolDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            @strongify(self)
            if (--self.leftTime >0) {
                [self.getCheckNumButton setTitle:[NSString stringWithFormat:@"%lds",self.leftTime] forState:UIControlStateNormal];
            }
            else{
                [self.coolDownTimer invalidate];
                self.coolDownTimer = nil;
                 [self.getCheckNumButton setTitle:@"action_get_verify_code".localizedString forState:UIControlStateNormal];
                [self.getCheckNumButton setEnabled:YES];
            }
        }];
    }
    return _coolDownTimer;
}


@end
