//
//  ChangeAccountPwdController.m
//  STCam
////  Created by coverme on 2018/10/30.
//  Copyright © 2018 South. All rights reserved.
//

#import "ChangeAccountPwdController.h"
#import "PrefixHeader.h"
#import "BasicTextField.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AccountManager.h"
#import "FFHttpTool.h"
#import "RetModel.h"
@interface ChangeAccountPwdController ()
@property(nonatomic,strong)TPKeyboardAvoidingScrollView * mainScrollView;
@property(nonatomic,strong)UIView * topBackView;
@property (nonatomic, strong) BasicTextField *oriPwdField;
@property (nonatomic, strong) BasicTextField *newerPwdField;
@property (nonatomic, strong) BasicTextField *confirmPwdField;
@property(nonatomic,strong)UIButton * confirmButton;

@end

@implementation ChangeAccountPwdController
-(void)initNav{
    [self setTitle:@"action_change_login_password".localizedString];
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

-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNav];
    
    _mainScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_mainScrollView];
    
    
    CGFloat rowHeight = 40*kWidthCoefficient;
    CGFloat prefixWidth = 80*kWidthCoefficient;
    
    CGFloat y = kPadding*3;
    _topBackView = [[UIView alloc] initWithFrame:CGRectMake(kPadding*2, y, kScreenWidth-4*kPadding, rowHeight*3+2)];
    [self.topBackView setBackgroundColor:[UIColor whiteColor]];
    [self.topBackView.layer setCornerRadius:5.0];
    [self.topBackView.layer setBorderWidth:1.0];
    [self.topBackView.layer setBorderColor:[UIColor colorWithHexString:@"0xcfcfcf"].CGColor];
    [_mainScrollView addSubview:_topBackView];
    
    /******************ori**********************/
    UILabel *oriPwdLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, prefixWidth, rowHeight)];
    [oriPwdLb setText:@"string_old_pwd".localizedString];
    self.oriPwdField = [[BasicTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-4*kPadding, rowHeight)];
    
    self.oriPwdField.placeholder = @"string_input_old_password".localizedString;
    [self.oriPwdField setFont:[UIFont systemFontOfSize:14]];
  
    self.oriPwdField.leftView = oriPwdLb;
    self.oriPwdField.leftViewMode = UITextFieldViewModeAlways;
    [self.topBackView addSubview:self.oriPwdField];
    
    UIView * oriSpiltView =  [[UIView alloc] initWithFrame:CGRectMake(0, rowHeight,kScreenWidth-4*kPadding, 1)];
    [oriSpiltView setBackgroundColor:[UIColor colorWithHexString:@"0xcfcfcf"]];
    [self.topBackView addSubview:oriSpiltView];
    /******************new**********************/
    UILabel *newerPwdLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, prefixWidth, rowHeight)];
    [newerPwdLb setText:@"string_new_pwd".localizedString];
    self.newerPwdField = [[BasicTextField alloc] initWithFrame:CGRectMake(0, rowHeight+1, kScreenWidth-4*kPadding, rowHeight)];
    
    self.newerPwdField.placeholder = @"string_input_new_password".localizedString;
    [self.newerPwdField setFont:[UIFont systemFontOfSize:14]];
    
    self.newerPwdField.leftView = newerPwdLb;
    self.newerPwdField.leftViewMode = UITextFieldViewModeAlways;
    [self.topBackView addSubview:self.newerPwdField];
    
    UIView * newerSpiltView =  [[UIView alloc] initWithFrame:CGRectMake(0, 2*rowHeight+1,kScreenWidth-4*kPadding, 1)];
    [newerSpiltView setBackgroundColor:[UIColor colorWithHexString:@"0xcfcfcf"]];
    [self.topBackView addSubview:newerSpiltView];
    
    /******************confirm**********************/
    UILabel *confirmPwdLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, prefixWidth, rowHeight)];
    [confirmPwdLb setText:@"string_confirm_pwd_title2".localizedString];
    self.confirmPwdField = [[BasicTextField alloc] initWithFrame:CGRectMake(0, 2*rowHeight+2, kScreenWidth-4*kPadding, rowHeight)];
    
    self.confirmPwdField.placeholder = @"string_confirm_new_password".localizedString;
    [self.confirmPwdField setFont:[UIFont systemFontOfSize:14]];
    
    self.confirmPwdField.leftView = confirmPwdLb;
    self.confirmPwdField.leftViewMode = UITextFieldViewModeAlways;
    [self.topBackView addSubview:self.confirmPwdField];
    
    /******************confirm button**********************/
    y = CGRectGetMaxY(_topBackView.frame)+ 3*kPadding;
    _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, kButtonHeight)];
    [_confirmButton setTitle:@"action_make_change".localizedString forState:UIControlStateNormal];
    [_confirmButton setAppThemeType:ButtonStyleStyleAppTheme];
    [self.view addSubview:_confirmButton];
    
    [_confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)confirmButtonClick{
    [self.view endEditing:YES];
//    PasswordOld = editText_old_pwd.getText().toString();
//    PasswordNew = editText_new_pwd.getText().toString();
//    PasswordNew1 = editText_confirm_pwd.getText().toString();
    NSString *PasswordOld = [_oriPwdField text];
    NSString *PasswordNew = [_newerPwdField text];
    NSString *PasswordNew1 = [_confirmPwdField text];
    if (![PasswordOld isEqualToString:[AccountManager getPassword]]) {
        [self showHint:@"old_password_wrong".localizedString];
        return;
    }
    else if([PasswordNew isEqualToString:PasswordOld]){
        [self showHint:@"confirm_password_same".localizedString];
        return;
    }
    else if([PasswordNew length] < 4){
        [self showHint:@"password_length_limit".localizedString];
        return;
    }
    else if(![PasswordNew isEqualToString:PasswordNew1]){
        [self showHint:@"confirm_password_nosame".localizedString];
        return;
    }
    //设置密码
    [self showHudInView:self.view hint:nil];
    
  
    NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_user_changepsd.asp?user=%@&psd=%@&newpsd=%@",serverIP,ServerPort,[AccountManager getUser],[AccountManager getPassword],PasswordNew];
    @weakify(self);
    [FFHttpTool GET:url parameters:nil success:^(id data){
        @strongify(self)
        [self hideHud];
        if ([data isKindOfClass:[NSDictionary class]]) {
            RetModel * retModel = [RetModel RetModelWithDict:data];
            if ([retModel ret] == 1) {
               
                [self showHint:@"string_ChangePsdSuccess".localizedString];
                [AccountManager saveAccount:[AccountManager getUser] pwd:PasswordNew remember:[AccountManager getIsRemember]];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [self showHint:@"string_ChangePsdFail".localizedString];
            }
            
        }
        
    } failure:^(NSError * error){
        [self showHint:@"string_ChangePsdFail".localizedString];
    }];
}

@end
