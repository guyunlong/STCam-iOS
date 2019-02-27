//
//  AddDeviceController.m
//  STCam
//
//  Created by cc on 10/16/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "AddDeviceController.h"
#import "PrefixHeader.h"
#import <AVFoundation/AVFoundation.h>
#import "DevShareModel.h"
#import "WCQRCodeVC.h"
#import "AccountManager.h"
#import "FFHttpTool.h"
#import "RetModel.h"
#import "DevListViewModel.h"
#import "AddDeviceSmartLinkController.h"
#import "WifiManager.h"
#import "AddDeviceAPToStaController.h"
#import "AddDeviceStaController.h"
#import "CoreDataManager.h"
#define buttonHeight 1.25*kButtonHeight
@interface AddDeviceController ()<QRCodeDelegate>
@property (nonatomic, strong) UIButton *scanSNAddButton;
@property (nonatomic, strong) UIButton *inputSNAddButton;
@property (nonatomic, strong) UIButton *smartAddButton;
@property (nonatomic, strong) UIButton *apTStaAddButton;
@property (nonatomic, strong) UIButton *wifiAddButton;
@property (nonatomic, strong) UIButton *qrCodeAddButton;
@end

@implementation AddDeviceController

-(void)initNav{
    [self setTitle:@"action_add_device".localizedString];
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
     DDLogDebug(@"view did load AddDeviceController");
}
-(void)loadView{
    [super loadView];
    [self initNav];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGFloat y = 3*kPadding;
    
    _scanSNAddButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, buttonHeight)];
    [_scanSNAddButton setTitle:@"action_add_qrcode_device".localizedString forState:UIControlStateNormal];
    [_scanSNAddButton setAppThemeType:ButtonStyleHollowAppTheme];
    [self.view addSubview:_scanSNAddButton];
    
    y+=buttonHeight+3*kPadding;
    
    _inputSNAddButton = [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, buttonHeight)];
    [_inputSNAddButton setTitle:@"action_add_inputSN".localizedString forState:UIControlStateNormal];
    [_inputSNAddButton setAppThemeType:ButtonStyleHollowAppTheme];
    [self.view addSubview:_inputSNAddButton];
    
    y+=buttonHeight+3*kPadding;
    
    _smartAddButton= [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, buttonHeight)];
    [_smartAddButton setTitle:@"action_add_one_key_setting".localizedString forState:UIControlStateNormal];
    [_smartAddButton setAppThemeType:ButtonStyleHollowAppTheme];
    [self.view addSubview:_smartAddButton];
    
    y+=buttonHeight+3*kPadding;
    _apTStaAddButton= [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, buttonHeight)];
    [_apTStaAddButton setTitle:@"action_add_ap_sta".localizedString forState:UIControlStateNormal];
    [_apTStaAddButton setAppThemeType:ButtonStyleHollowAppTheme];
    [self.view addSubview:_apTStaAddButton];
    
    y+=buttonHeight+3*kPadding;
    _wifiAddButton= [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, buttonHeight)];
    [_wifiAddButton setTitle:@"action_add_device_search".localizedString forState:UIControlStateNormal];
    [_wifiAddButton setAppThemeType:ButtonStyleHollowAppTheme];
    [self.view addSubview:_wifiAddButton];
    
    y+=buttonHeight+3*kPadding;
    _qrCodeAddButton= [[UIButton alloc] initWithFrame:CGRectMake(2*kPadding, y, kScreenWidth-4*kPadding, buttonHeight)];
    [_qrCodeAddButton setTitle:@"action_add_share_device".localizedString forState:UIControlStateNormal];
    [_qrCodeAddButton setAppThemeType:ButtonStyleHollowAppTheme];
    [self.view addSubview:_qrCodeAddButton];
    
    [_scanSNAddButton addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_inputSNAddButton addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_smartAddButton addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_apTStaAddButton addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_wifiAddButton addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_qrCodeAddButton addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)addBtnClicked:(id)sender{
    if(sender == _scanSNAddButton){
        WCQRCodeVC * vc = [WCQRCodeVC new];
        vc.delegate = self;
        [self QRCodeScanVC:vc];
    }
    else if(sender == _inputSNAddButton){
        [self createInputSNAlertController];
    }
    if(sender == _smartAddButton){
        if([[WifiManager ssid] length] == 0){
            [self showHint:@"string_OperationMustWifi".localizedString];
            return;
        }
        AddDeviceSmartLinkController *ctl  = [AddDeviceSmartLinkController new];
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if(sender == _apTStaAddButton){
         DDLogDebug(@"btn click apTSta");
        AddDeviceAPToStaController * ctl = [AddDeviceAPToStaController new];
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if(sender == _wifiAddButton){
        if([[WifiManager ssid] length] == 0){
            [self showHint:@"string_OperationMustWifi".localizedString];
            return;
        }
        AddDeviceStaController *ctl  = [AddDeviceStaController new];
        [self.navigationController pushViewController:ctl animated:YES];
       //
    }
    else if(sender == _qrCodeAddButton){
        WCQRCodeVC * vc = [WCQRCodeVC new];
        vc.delegate = self;
        [self QRCodeScanVC:vc];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)QRCodeScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
                case AVAuthorizationStatusNotDetermined: {
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        if (granted) {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [self.navigationController pushViewController:scanVC animated:YES];
                            });
                            DDLogDebug(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                        } else {
                            DDLogDebug(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                        }
                    }];
                    break;
                }
                case AVAuthorizationStatusAuthorized: {
                    [self.navigationController pushViewController:scanVC animated:YES];
                    break;
                }
                case AVAuthorizationStatusDenied: {
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    [alertC addAction:alertA];
                    [self presentViewController:alertC animated:YES completion:nil];
                    break;
                }
                case AVAuthorizationStatusRestricted: {
                    DDLogDebug(@"因为系统原因, 无法访问相册");
                    break;
                }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma QRCodeDelegate
- (void)SCanQRCodeResult:(NSString*)result{
    if(result){
        if ([result length] == 8) {
            [self createInputSNAlertControllerWithSn:result];
            return;
        }
        NSData *utf8Data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        id dictionary = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableLeaves error:&error];
        if([dictionary isKindOfClass:[NSDictionary class]]){
            DevShareModel * model = [DevShareModel DevShareModelWithDict:dictionary];
            if(model){
                [self showHudInView:self.view hint:@""];
                @weakify(self)
                [[self racAppShareAddDev:model] subscribeNext:^(id x) {
                    @strongify(self)
                    [self hideHud];
                    if ([x integerValue] == 1) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                }];
            }
        }
        
    }
}

-(RACSignal *)racAppShareAddDev:(DevShareModel*)model{
    //http://xxx.xxx.xxx.xxx:800/app_share_add_dev.asp?user=bbbb@abcdcba.com&psd=admin555&f rom=4719373@qq.com&tokenid=100d85590943116f4c7&mbtype=1&apptype=0&pushtype=0& sn=80007604&video=1&history=0&push=0&setup=1&control=1
    
   
    
    
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        //http://211.149.199.247:800/app_user_get_devlst.asp?user=1257117229@qq.com&psd=12345678
        NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_share_add_dev.asp?user=%@&psd=%@&from=%@&sn=%@&video=%d&history=%d&push=%d&setup=0&control=%d",serverIP,ServerPort,[AccountManager getUser],[AccountManager getPassword],model.From,model.SN,model.IsVideo,model.IsHistory,model.IsPush,model.IsControl];
        [FFHttpTool GET:url parameters:nil success:^(id data){
            @strongify(self)
            RetModel * model = [RetModel RetModelWithDict:data];
            if (model.ret == 1) {
                [subscriber sendNext:@1];
            }
            else{
                [subscriber sendNext:@(model.ret)];
            }
        } failure:^(NSError * error){
            [subscriber sendNext:@100000];//未知网络错误
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    
}

- (void)createInputSNAlertController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"action_add_inputSN".localizedString message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"device_SN".localizedString ;
        
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"device_pwd".localizedString;
        
    }];
    
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"action_ok".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *snField = alert.textFields.firstObject;
        UITextField *pwdField = alert.textFields.lastObject;
        //判断密码是否正确
        //密码正确后，添加设备
        
        [self addDevice:snField.text pwd:pwdField.text];
        
        
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"action_cancel".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
}
- (void)createInputSNAlertControllerWithSn:(NSString*)sn
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"action_add_qrcode_device".localizedString message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"device_SN".localizedString ;
        textField.text = sn;
        
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"device_pwd".localizedString;
        
    }];
    
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"action_ok".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *snField = alert.textFields.firstObject;
        UITextField *pwdField = alert.textFields.lastObject;
        //判断密码是否正确
        //密码正确后，添加设备
        
        [self addDevice:snField.text pwd:pwdField.text];
        
        
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"action_cancel".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
}


-(void)addDevice:(NSString*)sn pwd:(NSString*)pwd{
    [self.view endEditing:YES];
    DevListViewModel * viewModel = [DevListViewModel sharedDevListViewModel];
    for (DeviceModel * model in viewModel.deviceArray) {
        if ([model.SN isEqualToString:sn]) {
            [self showHint:@"error_device_added".localizedString];
            return;
        }
    }
    if ([sn length] != 8) {
        [self showHint:@"error_invalid_SN".localizedString];
        return;
    }
    else if([pwd length] < 4){
        [self showHint:@"error_invalid_password".localizedString];
        return;
    }
    DeviceModel * model = [[DeviceModel alloc] init];
    [model setPwd:pwd];
    [model setSN:sn];
    [[CoreDataManager sharedManager] saveDevice:model];
    [self showHudInView:self.view hint:nil];
    [[self racAddDevice:model] subscribeNext:^(id x) {
        [self hideHud];
        if ([x integerValue] == RESULT_SUCCESS) {
            [self showHint:@"string_devAddSuccess".localizedString];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if([x integerValue] == RESULT_USER_ISBIND){
            [self showHint:@"string_user_IsBind".localizedString];
        }
        else{
            [self showHint:@"string_devAddFail".localizedString];
        }
    }];
    
    
}
-(RACSignal *)racExcuteDeviceHttpCmd:(DeviceModel*)model{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        //http://211.149.199.247:800/app_user_get_devlst.asp?user=1257117229@qq.com&psd=12345678
        NSString * url = [NSString stringWithFormat:@"http://%@:%ld/cfg1.cgi?User=%@&Psd=%@&MsgID=%d",model.IPUID,model.WebPort,model.User,model.Pwd,Msg_GetTime];
        [FFHttpTool GET:url parameters:nil success:^(id data){
            @strongify(self)
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSInteger time = [[data objectForKey:@"time"] integerValue];
                if (time > 0) {
                    [subscriber sendNext:@1];//
                }
                else{
                    [subscriber sendNext:@0];//
                }
                
            }
            else{
                [subscriber sendNext:@0];//
            }
            [subscriber sendCompleted];
        } failure:^(NSError * error){
            [subscriber sendNext:@0];////未知网络错误
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}
-(RACSignal *)racAddDevice:(DeviceModel*)model{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        //http://211.149.199.247:800/app_user_get_devlst.asp?user=1257117229@qq.com&psd=12345678
        NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_user_add_dev.asp?user=%@&psd=%@&tokenid=%@&sn=%@",serverIP,ServerPort,[AccountManager getUser],[AccountManager getPassword],[AccountManager sharedManager].deviceToken,model.SN];
        [FFHttpTool GET:url parameters:nil success:^(id data){
            @strongify(self)
            if ([data isKindOfClass:[NSDictionary class]]) {
                RetModel * model =[RetModel RetModelWithDict:data];
                if (model.ret == RESULT_SUCCESS) {
                    [subscriber sendNext:@1];//
                }
                else{
                    [subscriber sendNext:@(model.ret)];//
                }
            }
            else{
                [subscriber sendNext:@0];//
            }
            [subscriber sendCompleted];
        } failure:^(NSError * error){
            [subscriber sendNext:@0];////未知网络错误
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}



@end
