//
//  ChangeAccountPwdController.m
//  STCam
////  Created by coverme on 2018/10/30.
//  Copyright © 2018 South. All rights reserved.
//

#import "DevChangeManagerController.h"
#import "PrefixHeader.h"
#import "BasicTextField.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AccountManager.h"
#import "FFHttpTool.h"
#import "RetModel.h"
#import "DevListViewModel.h"
@interface DevChangeManagerController ()
@property(nonatomic,strong)TPKeyboardAvoidingScrollView * mainScrollView;
@property(nonatomic,strong)UILabel * titleLabel;//待转移的设备名称
@property(nonatomic,strong)UIView * topBackView;
@property (nonatomic, strong) BasicTextField *pwdField;
@property (nonatomic, strong) BasicTextField *newerUserField;
@property(nonatomic,strong)UIButton * confirmButton;

@end

@implementation DevChangeManagerController
-(void)initNav{
    [self setTitle:@"action_ChangeManager".localizedString];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 28, 28);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.model) {
        [_titleLabel setText:[NSString stringWithFormat:@"%@(%@)",_model.SN,_model.DevName]];
    }
    
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
    CGFloat prefixWidth = 100*kWidthCoefficient;
    
    CGFloat y = kPadding*3;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding*2, y, kScreenWidth-kPadding*2, rowHeight)];
    [self.view addSubview:_titleLabel];
    y += rowHeight;
    
    
    
    _topBackView = [[UIView alloc] initWithFrame:CGRectMake(kPadding*2, y, kScreenWidth-4*kPadding, rowHeight*2+2)];
    [self.topBackView setBackgroundColor:[UIColor whiteColor]];
    [self.topBackView.layer setCornerRadius:5.0];
    [self.topBackView.layer setBorderWidth:1.0];
    [self.topBackView.layer setBorderColor:[UIColor colorWithHexString:@"0xcfcfcf"].CGColor];
    [_mainScrollView addSubview:_topBackView];
    
    /******************ori**********************/
    UILabel *oriPwdLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, prefixWidth, rowHeight)];
    [oriPwdLb setText:@"string_pwd".localizedString];
    self.pwdField = [[BasicTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-4*kPadding, rowHeight)];
    
    self.pwdField.placeholder = @"string_input_password".localizedString;
    [self.pwdField setFont:[UIFont systemFontOfSize:14]];
    
    self.pwdField.leftView = oriPwdLb;
    self.pwdField.leftViewMode = UITextFieldViewModeAlways;
    [self.topBackView addSubview:self.pwdField];
    
    UIView * oriSpiltView =  [[UIView alloc] initWithFrame:CGRectMake(0, rowHeight,kScreenWidth-4*kPadding, 1)];
    [oriSpiltView setBackgroundColor:[UIColor colorWithHexString:@"0xcfcfcf"]];
    [self.topBackView addSubview:oriSpiltView];
    /******************new**********************/
    UILabel *newerPwdLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, prefixWidth, rowHeight)];
    [newerPwdLb setText:@"txtToUser".localizedString];
    self.newerUserField = [[BasicTextField alloc] initWithFrame:CGRectMake(0, rowHeight+1, kScreenWidth-4*kPadding, rowHeight)];
    
    self.newerUserField.placeholder = @"txtToUser".localizedString;
    [self.newerUserField setFont:[UIFont systemFontOfSize:14]];
    
    self.newerUserField.leftView = newerPwdLb;
    self.newerUserField.leftViewMode = UITextFieldViewModeAlways;
    [self.topBackView addSubview:self.newerUserField];

    
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
    NSString *Password = [_pwdField text];
    NSString *newerUser = [_newerUserField text];
    if (![Password isEqualToString:[AccountManager getPassword]]) {
        [self showHint:@"password_Error".localizedString];
        return;
    }
  
   
    //转移设备
    [self showHudInView:self.view hint:nil];
    
    
    NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_user_dev_changemanager.asp?user=%@&psd=%@&sn=%@&touser=%@",serverIP,ServerPort,[AccountManager getUser],[AccountManager getPassword],_model.SN,newerUser];
    @weakify(self);
    [FFHttpTool GET:url parameters:nil success:^(id data){
        @strongify(self)
        [self hideHud];
        if ([data isKindOfClass:[NSDictionary class]]) {
            RetModel * retModel = [RetModel RetModelWithDict:data];
            if ([retModel ret] == 1) {
                
                [self.model threadDisconnect];
                [[DevListViewModel sharedDevListViewModel].deviceArray removeObject:self.model];
                
                [self showHint:@"txtToUserSuccess".localizedString];
//                [AccountManager saveAccount:[AccountManager getUser] pwd:PasswordNew remember:[AccountManager getIsRemember]];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else if([retModel ret] == -8)
            {
                [self showHint:@"action_no_user".localizedString];
            }
            else
            {
                [self showHint:@"txtToUserFailed".localizedString];
            }
            
        }
        
    } failure:^(NSError * error){
        [self showHint:@"string_ChangePsdFail".localizedString];
    }];
}

@end
