//
//  GenerateShareQRCodeController.m
//  STCam
//
//  Created by cc on 10/16/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "GenerateShareQRCodeController.h"
#import <BEMCheckBox/BEMCheckBox.h>
#import <Masonry/Masonry.h>
#import "MASConstraint.h"
#import "PrefixHeader.h"
#import "UIImage+Common.h"
#import "DevShareModel.h"
#import "AccountManager.h"
#define checkboxwidth 16*kWidthCoefficient
#define qrimagewidth 200*kWidthCoefficient
#define TextColor [UIColor colorWithHexString:@"0x535353"]
#define TextFont [UIFont systemFontOfSize:14]
@interface GenerateShareQRCodeController ()<BEMCheckBoxDelegate>

@property (nonatomic, strong) DevShareModel *shareModel;

//音频 回放 推送 控制
@property (nonatomic, strong) BEMCheckBox *audCheckBox;
@property (nonatomic, strong) UILabel *audCheckLabel;

@property (nonatomic, strong) BEMCheckBox *playbackCheckBox;
@property (nonatomic, strong) UILabel *playbackCheckLabel;

@property (nonatomic, strong) BEMCheckBox *pushCheckBox;
@property (nonatomic, strong) UILabel *pushCheckLabel;

@property (nonatomic, strong) BEMCheckBox *controlCheckBox;
@property (nonatomic, strong) UILabel *controlCheckLabel;

@property (nonatomic, strong) UIButton *generateButton;
@property (nonatomic, strong) UIImageView *qrImageView;
@end

@implementation GenerateShareQRCodeController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self creatCIQRCodeImage];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)setModel:(DeviceModel *)model{
    if (model) {
        _shareModel = [DevShareModel new];
        [_shareModel setSN:model.SN];
        [_shareModel setPwd:model.Pwd];
        [_shareModel setFrom:[AccountManager getUser]];
    }
}
-(void)initNav{
    [self setTitle:@"action_device_share".localizedString];
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
    CGFloat y = 2*kPadding;
    
    /*****************音频 *******************/
    _audCheckBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(3*kPadding,y, checkboxwidth, checkboxwidth)];
    _audCheckBox.delegate = self;
    [_audCheckBox setOnTintColor:kMainColor];
    [_audCheckBox setOnCheckColor:kMainColor];
    _audCheckBox.onAnimationType = BEMAnimationTypeBounce;
    _audCheckBox.offAnimationType = BEMAnimationTypeBounce;
    _audCheckBox.boxType = BEMBoxTypeSquare;
    
    [self.view addSubview:_audCheckBox];
   
    _audCheckLabel = [UILabel new];
    [_audCheckLabel setFont:TextFont];
    [_audCheckLabel setTextColor:TextColor];
    [_audCheckLabel setNumberOfLines:0];
    [_audCheckLabel setText:@"action_share_aud".localizedString];
    [self.view addSubview:_audCheckLabel];
    
    [_audCheckLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100*kWidthCoefficient));
        make.height.equalTo(@24);
        make.centerY.mas_equalTo(self.audCheckBox.mas_centerY);
        make.left.mas_equalTo(self.audCheckBox.mas_right).with.offset(kPadding/2);
    }];
    /*****************回放 *******************/
    _playbackCheckBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(3*kPadding+kScreenWidth/2,y, checkboxwidth, checkboxwidth)];
    [_playbackCheckBox setOnTintColor:kMainColor];
    [_playbackCheckBox setOnCheckColor:kMainColor];
    _playbackCheckBox.onAnimationType = BEMAnimationTypeBounce;
    _playbackCheckBox.offAnimationType = BEMAnimationTypeBounce;
    _playbackCheckBox.boxType = BEMBoxTypeSquare;
    _playbackCheckBox.delegate = self;
    [self.view addSubview:_playbackCheckBox];
    
    _playbackCheckLabel = [UILabel new];
    [_playbackCheckLabel setFont:TextFont];
    [_playbackCheckLabel setTextColor:TextColor];
    [_playbackCheckLabel setNumberOfLines:0];
    [_playbackCheckLabel setText:@"action_share_playback".localizedString];
    [self.view addSubview:_playbackCheckLabel];
    
    [_playbackCheckLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100*kWidthCoefficient));
        make.height.equalTo(@24);
        make.centerY.mas_equalTo(self.playbackCheckBox.mas_centerY);
        make.left.mas_equalTo(self.playbackCheckBox.mas_right).with.offset(kPadding/2);
    }];
    /*****************推送 *******************/
    y += checkboxwidth+ 2*kPadding;
    _pushCheckBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(3*kPadding,y, checkboxwidth, checkboxwidth)];
    [self.view addSubview:_pushCheckBox];
    [_pushCheckBox setOnTintColor:kMainColor];
    [_pushCheckBox setOnCheckColor:kMainColor];
    _pushCheckBox.onAnimationType = BEMAnimationTypeBounce;
    _pushCheckBox.offAnimationType = BEMAnimationTypeBounce;
    _pushCheckBox.boxType = BEMBoxTypeSquare;
    _pushCheckBox.delegate = self;
    
    _pushCheckLabel = [UILabel new];
    [_pushCheckLabel setFont:TextFont];
    [_pushCheckLabel setTextColor:TextColor];
    [_pushCheckLabel setNumberOfLines:0];
    [_pushCheckLabel setText:@"action_share_push".localizedString];
    [self.view addSubview:_pushCheckLabel];
    
    [_pushCheckLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100*kWidthCoefficient));
        make.height.equalTo(@24);
        make.centerY.mas_equalTo(self.pushCheckBox.mas_centerY);
        make.left.mas_equalTo(self.pushCheckBox.mas_right).with.offset(kPadding/2);
    }];
    /*****************控制 *******************/
    _controlCheckBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(3*kPadding+kScreenWidth/2,y, checkboxwidth, checkboxwidth)];
    [self.view addSubview:_controlCheckBox];
    [_controlCheckBox setOnTintColor:kMainColor];
    [_controlCheckBox setOnCheckColor:kMainColor];
    _controlCheckBox.onAnimationType = BEMAnimationTypeBounce;
    _controlCheckBox.offAnimationType = BEMAnimationTypeBounce;
    _controlCheckBox.boxType = BEMBoxTypeSquare;
    _controlCheckBox.delegate = self;
    
    _controlCheckLabel = [UILabel new];
    [_controlCheckLabel setFont:TextFont];
    [_controlCheckLabel setTextColor:TextColor];
    [_controlCheckLabel setNumberOfLines:0];
      [_controlCheckLabel setText:@"action_share_control".localizedString];
    [self.view addSubview:_controlCheckLabel];
    
    [_controlCheckLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(100*kWidthCoefficient));
        make.height.equalTo(@24);
        make.centerY.mas_equalTo(self.controlCheckBox.mas_centerY);
        make.left.mas_equalTo(self.controlCheckBox.mas_right).with.offset(kPadding/2);
    }];

    y += checkboxwidth+ 3*kPadding;
    /****************生成二维码*************************/
    _generateButton= [[UIButton alloc] initWithFrame:CGRectMake(3*kPadding, y, kScreenWidth-6*kPadding, kButtonHeight)];
    [_generateButton setTitle:@"action_device_share".localizedString forState:UIControlStateNormal];
    [_generateButton setAppThemeType:ButtonStyleStyleAppTheme];
    [_generateButton addTarget:self action:@selector(creatCIQRCodeImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_generateButton];
    /****************二维码*************************/
    y += kButtonHeight+ 3*kPadding;
    _qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-qrimagewidth/2, y, qrimagewidth, qrimagewidth)];
    
    [self.view addSubview:_qrImageView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  生成二维码
 */
- (void)creatCIQRCodeImage
{
    if (!_shareModel) {
        return;
    }
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认设置
    [filter setDefaults];
    
    // 3. 给过滤器添加数据
    NSString *dataString = _shareModel.localDescription;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5. 显示二维码
    self.qrImageView.image = [UIImage creatNonInterpolatedUIImageFormCIImage:outputImage withSize:300];
}

#pragma checkbox
- (void)didTapCheckBox:(BEMCheckBox*)checkBox{
    BOOL value = checkBox.on;
    if (checkBox == _audCheckBox) {
        [_audCheckLabel setTextColor:value?kMainColor:TextColor];
        _shareModel.IsVideo =value;
    }
    else if(checkBox == _controlCheckBox){
        [_controlCheckLabel setTextColor:value?kMainColor:TextColor];
        _shareModel.IsControl =value;
    }
    else if(checkBox == _playbackCheckBox){
        [_playbackCheckLabel setTextColor:value?kMainColor:TextColor];
        _shareModel.IsHistory =value;
    }
    else if(checkBox == _pushCheckBox){
        [_pushCheckLabel setTextColor:value?kMainColor:TextColor];
        _shareModel.IsPush =value;
    }
    
}


@end
