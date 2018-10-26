//
//  AddDeviceSmartLinkNextController.m
//  STCam
//
//  Created by guyunlong on 10/22/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "AddDeviceSmartLinkNextController.h"
#import "PrefixHeader.h"
#include "mtk_SmartConfig.h"
#import "AddDeviceStaController.h"
#import "AddDeviceSmartLinkController.h"
#import <SpinKit/RTSpinKitView.h>
@interface AddDeviceSmartLinkNextController ()
@property(nonatomic,strong)UIView * topBackView;
@property(nonatomic,strong)UIView * middleBackView;
@property(nonatomic,strong)UILabel * tipLb;
@property(nonatomic,strong)UILabel * infoLb;
@property(nonatomic,strong)UILabel * timeLeftLb;
@property(nonatomic,assign)NSInteger  timeLeft;
@property(nonatomic,strong)UIButton * cancelButton;
@property(nonatomic,strong)NSTimer * fireTimer;
@end

@implementation AddDeviceSmartLinkNextController

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    [self startSmartConfig];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopSmartConfig];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    @weakify(self)
    _fireTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        @strongify(self);
        --self.timeLeft;
        if (self.timeLeft <= 0) {
            [self.fireTimer invalidate];
            self.fireTimer = nil;
            [self backToAddStaController];
        }
        [self.timeLeftLb setText:[NSString stringWithFormat:@"string_finish_timeleft_%ld".localizedString,self.timeLeft]];
        
    }];
}
-(void)backToAddStaController{
    
    
    NSMutableArray *controllerArray = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    NSInteger count = [controllerArray count];
    for (NSInteger index = count-1;index>=0;index--) {
        UIViewController * tmpCtl  = [controllerArray objectAtIndex:index];
        if([tmpCtl isKindOfClass:[AddDeviceSmartLinkNextController class]] || [tmpCtl isKindOfClass:[AddDeviceSmartLinkController class]]){
            [controllerArray removeObject:tmpCtl];
            
        }
    }
    AddDeviceStaController *addDeviceStaController  = [AddDeviceStaController new];
    
    [controllerArray addObject:addDeviceStaController];
    [self.navigationController setViewControllers:controllerArray animated:YES];
    
}

-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNav];
}
-(void)initNav{
    [self setTitle:@"SmartConfig_connect".localizedString];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 28, 28);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    
    
    CGFloat y = 2*kPadding;
    /***********************top*************************/
    _topBackView = [[UIView alloc] initWithFrame:CGRectMake(kPadding*2, y, kScreenWidth-4*kPadding, 0)];
    [self.topBackView setBackgroundColor:[UIColor whiteColor]];
    [self.topBackView.layer setCornerRadius:5.0];
    [self.topBackView.layer setBorderWidth:1.0];
    [self.topBackView.layer setBorderColor:[UIColor colorWithHexString:@"0xcfcfcf"].CGColor];
    [self.view addSubview:_topBackView];
    
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
    NSString * info = @"action_one_key_setting_desc1".localizedString;
    _infoLb = [[UILabel alloc] initWithFrame:CGRectMake(2*kPadding, topY, kScreenWidth-4*kPadding-4*kPadding, 0)];
    [_topBackView addSubview:_infoLb];
    [_infoLb setNumberOfLines:0];
    [_infoLb setTextColor:[UIColor colorWithHexString:@"0x969696"]];
    [_infoLb setText:info];
    [_infoLb sizeToFit];
    topY = CGRectGetMaxY(_infoLb.frame);
    topY+=2*kPadding;
    
    _timeLeft = 45;
    _timeLeftLb = [[UILabel alloc] initWithFrame:CGRectMake(0, topY, kScreenWidth-4*kPadding, 21*kWidthCoefficient)];
    [_timeLeftLb setTextAlignment:NSTextAlignmentCenter];
    [_timeLeftLb setTextColor:kMainColor];
    [_timeLeftLb setText:[NSString stringWithFormat:@"string_finish_timeleft_%ld".localizedString,_timeLeft]];
    [_topBackView addSubview:_timeLeftLb];
    topY += 21*kWidthCoefficient+kPadding;
    
    
    [_topBackView setHeight:topY];
    
    y += topY + 4*kPadding;
    
    RTSpinKitView *spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleCircle color:kMainColor];
    [self.view addSubview:spinner];
    spinner.spinnerSize = 50.0*kWidthCoefficient;
    [spinner sizeToFit];
    [spinner setCenter:CGPointMake(kScreenWidth/2, y+25.0*kWidthCoefficient)];
    
    y += 5*kPadding + 50.0*kWidthCoefficient;
    _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, kButtonHeight)];
    [_cancelButton setTitle:@"cancel".localizedString forState:UIControlStateNormal];
    [_cancelButton setAppThemeType:ButtonStyleStyleAppTheme];
    [self.view addSubview:_cancelButton];
    
    [_cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)cancelButtonClicked{
    [self back];
}
-(void)back{
    [self.fireTimer invalidate];
    self.fireTimer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startSmartConfig{
    const char* SSID = [self.ssid cStringUsingEncoding:NSASCIIStringEncoding];
    const char* Password = [self.ssidPwd cStringUsingEncoding:NSASCIIStringEncoding];
    
    InitSmartConnection();
    StartSmartConnection(SSID, Password, (unsigned char*)"", 0, "", 0);
    
    
}
-(void)stopSmartConfig{
    StopSmartConnection();
}

@end
