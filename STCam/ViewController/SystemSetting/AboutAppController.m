//
//  AboutAppController.m
//  STCam
//
//  Created by coverme on 2018/10/30.
//  Copyright © 2018 South. All rights reserved.
//

#import "AboutAppController.h"
#import "PrefixHeader.h"
#import "UpdateModel.h"
#import "FFHttpTool.h"
@interface AboutAppController ()
@property(nonatomic,strong)UIImageView* iconImageView;
@property(nonatomic,strong)UILabel* appVersionLb;
@property(nonatomic,strong)UIButton* checkUpdateButton;
@property(nonatomic,strong)UIAlertController  *updateConfirmAlertController;//提示升级
@end

@implementation AboutAppController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf0f0f0"]];
    
    CGFloat y = 2*kPadding;
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-100*kWidthCoefficient/2, y, 100*kWidthCoefficient, 100*kWidthCoefficient)];
    [_iconImageView setImage:[UIImage imageNamed:@"appicon100"]];
    _iconImageView.layer.cornerRadius = 8;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.borderColor = kMainColor.CGColor;
    _iconImageView.layer.borderWidth=0.5;
    [self.view addSubview:_iconImageView];
    
    y+=100*kWidthCoefficient+kPadding;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _appVersionLb = [[UILabel alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, 22*kWidthCoefficient)];
    [_appVersionLb setTextColor:[UIColor colorWithHexString:@"0x969696"]];
    [_appVersionLb setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_appVersionLb];
    [_appVersionLb setText:[NSString stringWithFormat:@"CAMLS:v%@",app_Version]];
    
     y+=22*kWidthCoefficient+5*kPadding;
    
    _checkUpdateButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadding, y, kScreenWidth-2*kPadding, kButtonHeight)];
    [_checkUpdateButton setAppThemeType:ButtonStyleHollow];
    [_checkUpdateButton setTitle:@"action_check_update".localizedString forState:UIControlStateNormal];
    [_checkUpdateButton addTarget:self action:@selector(checkUpdateClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)initNav{
    [self setTitle:@"action_about".localizedString];
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
-(void)checkUpdateClicked{
    [self showHudInView:self.view hint:nil];
    NSString * url = [NSString stringWithFormat:@"http://%@:%d/app_upgrade_app_check.asp?apptype=1&ostype=ios",serverIP,ServerPort];
    @weakify(self);
    [FFHttpTool GET:url parameters:nil success:^(id data){
        @strongify(self)
        [self hideHud];
        if ([data isKindOfClass:[NSDictionary class]]) {
            UpdateModel * model = [UpdateModel UpdateModelWithDict:data];
            if (model) {
                if(![model checkIsLocalAlreadyNewerVersion]){
                    [self presentViewController:self.updateConfirmAlertController animated:YES completion:nil];
                }
                else{
                    [self showHint:@"string_current_newer".localizedString];
                }
            }
        }
        
    } failure:^(NSError * error){
        [self hideHud];
    }];
}
-(UIAlertController*)updateConfirmAlertController{
    if (!_updateConfirmAlertController) {
        @weakify(self)
        _updateConfirmAlertController = [UIAlertController alertControllerWithTitle:@"string_current_older".localizedString message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel".localizedString style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK".localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
          
        }];
        
        [_updateConfirmAlertController addAction:cancelAction];
        [_updateConfirmAlertController addAction:okAction];
        
    }
    return _updateConfirmAlertController;
}
@end
