//
//  ChangeDevicePwdController.m
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "ChangeDevicePwdController.h"
#import "PrefixHeader.h"
#import "TPKeyboardAvoidingScrollView.h"
#define fieldHeight 44*kWidthCoefficient
#define lbwidth 120*kWidthCoefficient
@interface ChangeDevicePwdController ()

@property (strong, nonatomic)UILabel*oldPwdLb;
@property (strong, nonatomic)UILabel*newerPwdLb;
@property (strong, nonatomic)UILabel*confirmPwdLb;

@property (strong, nonatomic)UITextField*oldPwdFd;
@property (strong, nonatomic)UITextField*newerPwdFd;
@property (strong, nonatomic)UITextField*confirmPwdFd;

@property(nonatomic,strong)   UIView *backgroundView;

@property(nonatomic,strong)TPKeyboardAvoidingScrollView * mainScrollView;

@property(nonatomic,strong)UIButton  * changeButton;//修改按钮


@end

@implementation ChangeDevicePwdController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_viewModel) {
        [_oldPwdFd setText:_viewModel.model.Pwd];
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}


-(void)initNav{
    [self setTitle:@"action_device_password_manager".localizedString];
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
    
    CGFloat y = kPadding*3;
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(kPadding, y,kScreenWidth-2*kPadding , fieldHeight*3+3)];
    [_mainScrollView addSubview:_backgroundView];
    [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
    [self.backgroundView.layer setCornerRadius:5.0];
    [self.backgroundView.layer setBorderWidth:1.0];
    [self.backgroundView.layer setBorderColor:[UIColor colorWithHexString:@"0xcfcfcf"].CGColor];
    [_mainScrollView addSubview:self.backgroundView];
    /****************************旧密码************************************/
    CGFloat ry = 0;
    _oldPwdLb = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, ry, lbwidth, fieldHeight)];
    [_oldPwdLb setFont:[UIFont systemFontOfSize:13]];
    [_oldPwdLb setText:@"device_old_pwd".localizedString];
    _oldPwdFd = [[UITextField alloc] initWithFrame:CGRectMake(kPadding + lbwidth, ry, kScreenWidth-2*kPadding-(kPadding + lbwidth)-kPadding, fieldHeight)];
    [_oldPwdFd setPlaceholder:@"device_old_pwd".localizedString];
    [_backgroundView addSubview:_oldPwdLb];
    [_backgroundView addSubview:_oldPwdFd];
    
    
    ry += fieldHeight;
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, ry, kScreenWidth-2*kPadding, 1)];
    [line setBackgroundColor:[UIColor colorWithHexString:@"0xcfcfcf"]];
    [_backgroundView addSubview:line];
    ry += 1;
    /****************************新密码************************************/
    _newerPwdLb = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, ry, lbwidth, fieldHeight)];
    [_newerPwdLb setText:@"device_new_pwd".localizedString];
     [_newerPwdLb setFont:[UIFont systemFontOfSize:13]];
    _newerPwdFd = [[UITextField alloc] initWithFrame:CGRectMake(kPadding + lbwidth, ry, kScreenWidth-2*kPadding-(kPadding + lbwidth)-kPadding, fieldHeight)];
    [_newerPwdFd setPlaceholder:@"device_new_pwd".localizedString];
    [_backgroundView addSubview:_newerPwdLb];
    [_backgroundView addSubview:_newerPwdFd];
    
    
    ry += fieldHeight;
    
    UIView * newerline = [[UIView alloc] initWithFrame:CGRectMake(0, ry, kScreenWidth-2*kPadding, 1)];
    [newerline setBackgroundColor:[UIColor colorWithHexString:@"0xcfcfcf"]];
    [_backgroundView addSubview:newerline];
    ry += 1;
    /****************************确认新密码************************************/
    _confirmPwdLb = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, ry, lbwidth, fieldHeight)];
    [_confirmPwdLb setText:@"device_confirm_pwd".localizedString];
     [_confirmPwdLb setFont:[UIFont systemFontOfSize:13]];
    _confirmPwdFd = [[UITextField alloc] initWithFrame:CGRectMake(kPadding + lbwidth, ry, kScreenWidth-2*kPadding-(kPadding + lbwidth)-kPadding, fieldHeight)];
    [_confirmPwdFd setPlaceholder:@"device_confirm_pwd".localizedString];
    [_backgroundView addSubview:_confirmPwdFd];
    [_backgroundView addSubview:_confirmPwdLb];
    
    
    ry += fieldHeight;
    
    UIView * confirmline = [[UIView alloc] initWithFrame:CGRectMake(0, ry, kScreenWidth-2*kPadding, 1)];
    [confirmline setBackgroundColor:[UIColor colorWithHexString:@"0xcfcfcf"]];
    [_backgroundView addSubview:confirmline];
    
    /****************************按钮************************************/
    y += kPadding*2 + fieldHeight*3+3;
    _changeButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadding, y, kScreenWidth-2*kPadding, kButtonHeight)];
    [_changeButton setTitle:@"action_change".localizedString forState:UIControlStateNormal];
    [_changeButton setAppThemeType:ButtonStyleStyleAppTheme];
    [self.view addSubview:_changeButton];
    
    [_changeButton addTarget:self action:@selector(changeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)changeButtonClick {
    [self.view endEditing:YES];
    NSString * PasswordOld = _oldPwdFd.text;
    NSString * PasswordNew = _newerPwdFd.text;
    NSString * PasswordNew1 = _confirmPwdFd.text;
    
    if ([PasswordNew isEqualToString:PasswordOld])
    {
       // SouthUtil.showDialog(DevChangePwdActivity.this, getString(R.string.confirm_password_same));
        [self showHint:@"confirm_password_same".localizedString];
        return;
    }
    
    if ([PasswordNew length]>20)
    {
        
        [self showHint:@"action_dev_pwd_limit_lessthan_19".localizedString];
        return;
    }
    if (![PasswordNew isEqualToString:PasswordNew1])
    {
        [self showHint:@"confirm_password_nosame".localizedString];
        return;
    }
    if ([PasswordNew length]<4)
    {
        [self showHint:@"password_length_limit".localizedString];
        return;
    }
    
    [self showHudInView:self.view hint:@""];
    @weakify(self);
    [[[[[self.viewModel racChangeDevicePassword:PasswordNew]
       deliverOn:[RACScheduler mainThreadScheduler]]
       filter:^BOOL(id value) {
        @strongify(self);
        if ([value integerValue] == 1) {
            [self hideHud];
            [self showHint:@"action_Success".localizedString];
            [self back];
        }
        else if([value integerValue] == 2){
            [self hideHud];
            [self showHudInView:self.view hint:@"Rebooting"];
        }
        else{
            [self hideHud];
            [self showHint:@"action_Failed".localizedString];
        }
        return [value integerValue] == 2;
    }]
      flattenMap:^RACStream *(id value) {
          @strongify(self);
          return [self.viewModel racRebootDevice];
      }]
     subscribeNext:^(id x) {
         @strongify(self);
         [self hideHud];
       
     }];
}



@end
