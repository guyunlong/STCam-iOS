//
//  AddDeviceApToStaNextController.m
//  STCam
//
//  Created by guyunlong on 10/23/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "AddDeviceApToStaNextController.h"
#import "PrefixHeader.h"
#import "BasicTextField.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SSIDModel.h"
#import "RetModel.h"
#import "IGLDropDownMenu.h"
#import "FFHttpTool.h"
#import "LMJDropdownMenu.h"
@interface AddDeviceApToStaNextController ()<LMJDropdownMenuDelegate>
@property(nonatomic,strong)TPKeyboardAvoidingScrollView * mainScrollView;
@property(nonatomic,strong)UIView * topBackView;
@property(nonatomic,strong)UIView * middleBackView;
@property(nonatomic,strong)UIButton * nextButton;
@property(nonatomic,strong)UILabel * devNameLb;
@property(nonatomic,strong)UILabel * devAdressLb;
@property (nonatomic, strong) LMJDropdownMenu *ssidMenu;
//@property (nonatomic, strong) BasicTextField *ssidField;
@property(nonatomic,strong)UIImageView * ssidIconImageView;
@property (nonatomic, strong) BasicTextField *ssidPwdField;
@property(nonatomic,strong)NSString * ssid;
@property(nonatomic,strong)NSString * ssidPwd;
@property(nonatomic,strong)NSMutableArray * ssidArray;
@property(nonatomic,strong)UIAlertController  *confirmAlertController;//确认弹框
@property(nonatomic,strong)NSTimer  *coolTimer;
@end

@implementation AddDeviceApToStaNextController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //RAC(self, ssid)  = self.ssidField.rac_textSignal;
    RAC(self, ssidPwd)  = self.ssidPwdField.rac_textSignal;
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_devNameLb setText:_model.DevName];
    [_devAdressLb setText:_model.IPUID];
    [self searchWiFi];
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
    
    _devNameLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-4*kPadding, 25*kWidthCoefficient)];
    [_devNameLb setTextAlignment:NSTextAlignmentCenter];
    [_devNameLb setTextColor:[UIColor colorWithHexString:@"0x969696"]];
    [_topBackView addSubview:_devNameLb];
    CGFloat topY = CGRectGetMaxY(_devNameLb.frame) + 5;
    
   
    
    _devAdressLb = [[UILabel alloc] initWithFrame:CGRectMake(2*kPadding, topY, kScreenWidth-4*kPadding-4*kPadding, 25*kWidthCoefficient)];
    [_devAdressLb setTextAlignment:NSTextAlignmentCenter];
    [_topBackView addSubview:_devAdressLb];
  
    [_devAdressLb setTextColor:[UIColor colorWithHexString:@"0x969696"]];
 
    topY += 25*kWidthCoefficient;
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
    
    self.ssidMenu = [[LMJDropdownMenu alloc] init];
    self.ssidMenu.delegate = self;
    [self.ssidMenu setFrame:CGRectMake(40*kWidthCoefficient+kPadding*2,y+1, kScreenWidth-4*kPadding-40*kWidthCoefficient-kPadding, fieldHeight-2)];
    [self.view addSubview:self.ssidMenu];
    
    
    _ssidIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_wifi"]];
    [_ssidIconImageView setFrame:CGRectMake(8*kWidthCoefficient, 8*kWidthCoefficient, 24*kWidthCoefficient, 24*kWidthCoefficient)];
     [self.middleBackView addSubview:self.ssidIconImageView];
    
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
-(void)reSetUpSSIDMenu{
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        
        
        
        if ([_ssidArray count] == 0) {
            return;
        }
        NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.ssidArray.count; i++) {
            SSIDModel * model = self.ssidArray[i];
            [dropdownItems addObject:[model getSSIDSignalDesc]];
        }
        SSIDModel * model = self.ssidArray[0];
        _ssid =model.SSID;
        [_ssidMenu setMenuTitles:dropdownItems rowHeight:40*kWidthCoefficient];
        
      
        
    });
    
    
   
 
}
-(void)initNav{
    [self setTitle:@"action_add_ap_sta".localizedString];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 28, 28);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(0, 0, 80, 28);
    refreshButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    [refreshButton addTarget:self action:@selector(searchWiFi) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTitle:@"action_refresh".localizedString forState:UIControlStateNormal];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextButtonClicked{
    if ([_ssidPwd length] == 0) {
        [self presentViewController:self.confirmAlertController animated:YES completion:nil];
    }
    else{
        [self Handle_APSTA_OnNext];
    }
}

-(void)backToAddController:(BOOL)wait{
    if(wait){
        __block NSInteger count = 45;
        [self showHudInView:self.view hint:[NSString stringWithFormat:@"%ld%@",count,@"action_reboot_seconds".localizedString]];
        _coolTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            --count;
            if (count>0) {
                [self showHudInView:self.view hint:[NSString stringWithFormat:@"%ld%@",count,@"action_reboot_seconds".localizedString]];
            }
            else{
                [self.coolTimer invalidate];
                self.coolTimer = nil;
                [self backToAddControllerIM];
            }
        }];
    }
    else{
        [self backToAddControllerIM];
    }
    
}
-(void)backToAddControllerIM{
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count-3] animated:YES];
}
/**/

-(void)searchWiFi{
    @weakify(self)
   [self showHudInView:self.view hint:@""];
        
        //http://211.149.199.247:800/app_user_get_devlst.asp?user=1257117229@qq.com&psd=12345678
        NSString * url = [NSString stringWithFormat:@"http://%@:%ld/cfg1.cgi?User=%@&Psd=%@&MsgID=%d",self.model.IPUID,self.model.WebPort,self.model.User,self.model.Pwd,Msg_WiFiSearch];
        [FFHttpTool GET:url parameters:nil success:^(id data){
            @strongify(self)
             [self hideHud];
            if([data isKindOfClass:[NSArray class]]){
                if (!self.ssidArray) {
                    self.ssidArray = [NSMutableArray new];
                }
                [self.ssidArray removeAllObjects];
                for (NSDictionary * dic in data) {
                    SSIDModel * model = [SSIDModel SSIDModelWithDict:dic];
                    [self.ssidArray addObject:model];
                }
                if (self.ssidArray.count > 0) {
                    [self reSetUpSSIDMenu];
                }
            }
        } failure:^(NSError * error){
            @strongify(self)
             [self hideHud];
        }];
}

/*
-(void)searchWiFi{
    [self showHudInView:self.view hint:@""];
    @weakify(self);
    
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            @strongify(self)
            NSString * url = [NSString stringWithFormat:@"%@",[self.model getDevURL:Msg_WiFiSearch]];
            
            id data = [self.model thNetHttpGet:url];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                [self hideHud];
                if([data isKindOfClass:[NSArray class]]){
                    if (!self.ssidArray) {
                        self.ssidArray = [NSMutableArray new];
                    }
                    [self.ssidArray removeAllObjects];
                    for (NSDictionary * dic in data) {
                        SSIDModel * model = [SSIDModel SSIDModelWithDict:dic];
                        [self.ssidArray addObject:model];
                    }
                    if (self.ssidArray.count > 0) {
                        [self reSetUpSSIDMenu];
                    }
                }
            });
           
            
        });
    
}
*/
-(void)Handle_APSTA_OnNext{
    [self showHudInView:self.view hint:@""];
    @weakify(self);
    
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(quene, ^{
        @strongify(self)
        NSString * url = [NSString stringWithFormat:@"%@&wifi_Active=1&wifi_IsAPMode=0&wifi_SSID_STA=%@&wifi_Password_STA=%@",[self.model getDevURL:Msg_GetPushCfg],self.ssid,self.ssidPwd];
        
        id data = [self.model thNetHttpGet:url];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self hideHud];
            if([data isKindOfClass:[NSDictionary class]]){
                RetModel * model = [RetModel RetModelWithDict:data];
                if (model.ret == RESULT_SUCCESS_REBOOT) {
                    [self.model threadDisconnect];
                    [self showHint:@"action_AP_T_STA_Success".localizedString];
                    [self backToAddController:YES];
                }
                else{
                    [self showHint:@"action_AP_T_STA_Failed".localizedString];
                }
            }
        });
        

       
        
    });
}

#pragma mark - IGLDropDownMenuDelegate
#pragma mark - LMJDropdownMenu Delegate

- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    NSLog(@"你选择了：%ld",number);
    SSIDModel * model = _ssidArray[number];
    _ssid =model.SSID;
}

- (void)dropdownMenuWillShow:(LMJDropdownMenu *)menu{
    NSLog(@"--将要显示--");
}
- (void)dropdownMenuDidShow:(LMJDropdownMenu *)menu{
    NSLog(@"--已经显示--");
}

- (void)dropdownMenuWillHidden:(LMJDropdownMenu *)menu{
    NSLog(@"--将要隐藏--");
}
- (void)dropdownMenuDidHidden:(LMJDropdownMenu *)menu{
    NSLog(@"--已经隐藏--");
}

-(UIAlertController*)confirmAlertController{
    if (!_confirmAlertController) {
        @weakify(self)
        _confirmAlertController = [UIAlertController alertControllerWithTitle:@"string_IsSureRouteNotPassword".localizedString message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [self Handle_APSTA_OnNext];
        }];
        
        [_confirmAlertController addAction:cancelAction];
        [_confirmAlertController addAction:okAction];
        
    }
    return _confirmAlertController;
}

@end
