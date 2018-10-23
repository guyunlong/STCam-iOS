//
//  AddDeviceSmartLinkController.m
//  STCam
//
//  Created by guyunlong on 10/22/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "AddDeviceSmartLinkController.h"
#import "PrefixHeader.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "BasicTextField.h"
#import "WifiManager.h"
#import "AddDeviceSmartLinkNextController.h"
@interface AddDeviceSmartLinkController ()<UITextFieldDelegate>
@property(nonatomic,strong)TPKeyboardAvoidingScrollView * mainScrollView;
@property(nonatomic,strong)UIView * topBackView;
@property(nonatomic,strong)UIView * middleBackView;
@property(nonatomic,strong)UIButton * nextButton;
@property(nonatomic,strong)UILabel * tipLb;
@property(nonatomic,strong)UILabel * infoLb;
@property (nonatomic, strong) BasicTextField *ssidField;
@property (nonatomic, strong) BasicTextField *ssidPwdField;
@property(nonatomic,strong)NSString * ssid;
@property(nonatomic,strong)NSString * ssidPwd;
@property(nonatomic,strong)UIAlertController  *confirmAlertController;//确认弹框
@end

@implementation AddDeviceSmartLinkController
-(void)initNav{
    [self setTitle:@"SmartConfig".localizedString];
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
    [self setupObserve];
}
-(void)setupObserve{
    RAC(self, ssid)  = self.ssidField.rac_textSignal;
    RAC(self, ssidPwd)  = self.ssidPwdField.rac_textSignal;
}
-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNav];
    _mainScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:_mainScrollView];
    
    CGFloat y = 2*kPadding;
    /***********************top*************************/
    _topBackView = [[UIView alloc] initWithFrame:CGRectMake(kPadding*2, y, kScreenWidth-4*kPadding, 0)];
    [self.topBackView setBackgroundColor:[UIColor whiteColor]];
    [self.topBackView.layer setCornerRadius:5.0];
    [self.topBackView.layer setBorderWidth:1.0];
    [self.topBackView.layer setBorderColor:[UIColor colorWithHexString:@"0xcfcfcf"].CGColor];
    [_mainScrollView addSubview:_topBackView];
    
    _tipLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-4*kPadding, 40*kWidthCoefficient)];
    [_tipLb setTextAlignment:NSTextAlignmentCenter];
    [_tipLb setTextColor:kMainColor];
    [_tipLb setText:@"string_tip".localizedString];
    [_topBackView addSubview:_tipLb];
    CGFloat topY = 40*kWidthCoefficient;
    UIView * spilt = [[UIView alloc] initWithFrame:CGRectMake(0, topY,kScreenWidth-4*kPadding , 1)];
    [spilt setBackgroundColor:[UIColor colorWithHexString:@"0xcfcfcf"]];
    [_topBackView addSubview:spilt];
    topY+=1+2*kPadding;
    NSString * info = @"action_one_key_setting_desc0".localizedString;
    _infoLb = [[UILabel alloc] initWithFrame:CGRectMake(2*kPadding, topY, kScreenWidth-4*kPadding-4*kPadding, 0)];
    [_topBackView addSubview:_infoLb];
    [_infoLb setNumberOfLines:0];
    [_infoLb setTextColor:[UIColor colorWithHexString:@"0x969696"]];
    [_infoLb setText:info];
    [_infoLb sizeToFit];
    topY = CGRectGetMaxY(_infoLb.frame);
    topY+=2*kPadding;
    [_topBackView setHeight:topY];
    
    /***********************middle*************************/
    y +=topY + 2*kPadding;
    CGFloat fieldHeight = 40*kWidthCoefficient;
    _middleBackView = [[UIView alloc] initWithFrame:CGRectMake(kPadding*2, y, kScreenWidth-4*kPadding, fieldHeight*2+1)];
    [self.middleBackView setBackgroundColor:[UIColor whiteColor]];
    [self.middleBackView.layer setCornerRadius:5.0];
    [self.middleBackView.layer setBorderWidth:1.0];
    [self.middleBackView.layer setBorderColor:[UIColor colorWithHexString:@"0xcfcfcf"].CGColor];
    [_mainScrollView addSubview:_middleBackView];
    
    self.ssidField = [[BasicTextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-4*kPadding, fieldHeight)];
    [self.ssidField setUserInteractionEnabled:NO];
    self.ssidField.placeholder = @"ssid".localizedString;
    [self.ssidField setFont:[UIFont systemFontOfSize:14]];
    UIImageView *userTextFieldImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_wifi"]];
    self.ssidField.leftView = userTextFieldImage;
    self.ssidField.leftViewMode = UITextFieldViewModeAlways;
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.userTextField];
    [_ssidField setText:[WifiManager ssid]];
    _ssid =[WifiManager ssid];
    [self.middleBackView addSubview:self.ssidField];
    
    
    UIView * middleSpilt = [[UIView alloc] initWithFrame:CGRectMake(0, fieldHeight,kScreenWidth-4*kPadding , 1)];
    [middleSpilt setBackgroundColor:[UIColor colorWithHexString:@"0xcfcfcf"]];
    [_middleBackView addSubview:middleSpilt];
    
    
    self.ssidPwdField = [[BasicTextField alloc] initWithFrame:CGRectMake(0, fieldHeight+1, kScreenWidth-4*kPadding, fieldHeight)];
    
    self.ssidPwdField.placeholder = @"ssid_pwd".localizedString;
    [self.ssidPwdField setFont:[UIFont systemFontOfSize:14]];
    UIImageView *ssidPwdFieldImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_lock"]];
    self.ssidPwdField.leftView = ssidPwdFieldImage;
    self.ssidPwdField.leftViewMode = UITextFieldViewModeAlways;
    [self.middleBackView addSubview:self.ssidPwdField];
    
    y += 2*fieldHeight +1;
    
    /***********************button*************************/
    
    y += 3*kPadding;
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, kButtonHeight)];
    [_nextButton setTitle:@"next".localizedString forState:UIControlStateNormal];
    [_nextButton setAppThemeType:ButtonStyleStyleAppTheme];
    [self.view addSubview:_nextButton];
    
    [_nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)nextButtonClicked{
    if ([_ssidPwd length] == 0) {
        [self presentViewController:self.confirmAlertController animated:YES completion:nil];
    }
    else{
        [self setpToNextSetCtl];
    }
}
-(void)setpToNextSetCtl{
    
    AddDeviceSmartLinkNextController * ctl  = [AddDeviceSmartLinkNextController new];
    [self.navigationController pushViewController:ctl animated:YES];
    
}

-(UIAlertController*)confirmAlertController{
    if (!_confirmAlertController) {
        @weakify(self)
        _confirmAlertController = [UIAlertController alertControllerWithTitle:@"string_IsSureRouteNotPassword".localizedString message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self setpToNextSetCtl];
        }];
        
        [_confirmAlertController addAction:cancelAction];
        [_confirmAlertController addAction:okAction];
        
    }
    return _confirmAlertController;
}

@end
