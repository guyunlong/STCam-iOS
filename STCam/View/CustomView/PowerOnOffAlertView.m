//
//  PowerOnOffAlertView.m
//  GRAVE
//
//  Created by guyunlong on 2018/12/25.
//  Copyright © 2018年 South. All rights reserved.
//

#import "PowerOnOffAlertView.h"
#import "PrefixHeader.h"
#import "BEMCheckBox.h"
#define titleFont [UIFont boldSystemFontOfSize:20]
#define contentFont [UIFont boldSystemFontOfSize:14]
#define titleHeight 22
#define checkBoxHeight 20
#define txColor [UIColor colorWithHexString:@"0x222222"]
@interface PowerOnOffAlertView()<BEMCheckBoxDelegate>{
    float viewWidth;
}
@property(strong, nonatomic) UILabel *titleLb;
@property(nonatomic,strong)UIButton* okBtn;
@property(nonatomic,strong)UIButton* cancelBtn;
@property(nonatomic,strong)UILabel * powerOnLb;//开机时间
@property(nonatomic,strong)UIButton* chooseTimeBtn;
@property(nonatomic,strong)BEMCheckBox  * checkOnBox;
@property(nonatomic,strong)UILabel  * checkLb;
@property(nonatomic,strong)UILabel * powerOffLb;//关机时间
@property(nonatomic,strong)BEMCheckBox  * power0Box;//不关机
@property(nonatomic,strong)BEMCheckBox  * power1Box;//30分钟
@property(nonatomic,strong)BEMCheckBox  * power2Box;//60分钟
@property(nonatomic,strong)BEMCheckBox  * power3Box;//90分钟
@property(nonatomic,strong)BEMCheckBox  * power4Box;//120分钟
@property(nonatomic,strong) BEMCheckBoxGroup *  checkGroup;

@property(nonatomic,strong)UILabel  * power0Lb;//不关机
@property(nonatomic,strong)UILabel  * power1Lb;//30分钟
@property(nonatomic,strong)UILabel  * power2Lb;//60分钟
@property(nonatomic,strong)UILabel  * power3Lb;//90分钟
@property(nonatomic,strong)UILabel  * power4Lb;//120分钟
@end
@implementation PowerOnOffAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
       
        [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = true;
        
        [self initView];
    }
    return self;
}
-(void)initView{
    float y = 3.5*kPadding;
    float viewWidth;
    viewWidth = (kScreenWidth - 4*kPadding);
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-25-kPadding, kPadding, 25, 25)];
    [_cancelBtn setImage:[UIImage imageNamed:@"close01"] forState:UIControlStateNormal];
    [self addSubview:_cancelBtn];
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, y, viewWidth, titleHeight)];
        [_titleLb setText:@"string_DevAdvancedSettings_PowerTimerCfg".localizedString];
        [_titleLb setFont:titleFont];
        [_titleLb setTextColor:txColor];
        [_titleLb setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLb];
    }
    
    [_titleLb setHeight:titleHeight];
    [self addSubview:_titleLb];
    y += titleHeight+kPadding*2;
    
    _powerOnLb = [[UILabel alloc] initWithFrame:CGRectMake(kPadding*2, y, 80, 30)];
    [_powerOnLb setText:@"txtTimePowerOn".localizedString];
    [_powerOnLb setTextColor:[UIColor colorWithHexString:@"0x969696"]];
    [_powerOnLb setFont:contentFont];
    [self addSubview:_powerOnLb];
    
    _chooseTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_powerOnLb.frame)+kPadding, y-0.5*kPadding, 80, 30+kPadding)];
    [_chooseTimeBtn setTitle:@"23:00" forState:UIControlStateNormal];
    [_chooseTimeBtn setAppThemeType:ButtonStyleDefault];
    [self addSubview:_chooseTimeBtn];
    
    
    _checkOnBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_chooseTimeBtn.frame)+kPadding, y+(30-checkBoxHeight)/2, 30, 30)];
    [_checkOnBox setDelegate:self];
    [self addSubview:_checkOnBox];
    
    _checkLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_checkOnBox.frame)+kPadding, y, 60, 30)];
    [_checkLb setFont:contentFont];
    [_checkLb setText:@"txtActive".localizedString];
    [self addSubview:_checkLb];
    
    y += 30+2*kPadding;
    
    _powerOffLb = [[UILabel alloc] initWithFrame:CGRectMake(kPadding*2, y, 80, 20)];
    [_powerOffLb setFont:contentFont];
    [_powerOffLb setTextColor:[UIColor colorWithHexString:@"0x969696"]];
    [_powerOffLb setText:@"txtTimePowerOff".localizedString];
    [self addSubview:_powerOffLb];
    
    y+= 20+kPadding;
    
    _power0Box =[[BEMCheckBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_powerOffLb.frame), y+(30-checkBoxHeight)/2, 30, 30)];
    [self addSubview:_power0Box];
    
    _power0Lb =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_power0Box.frame)+kPadding, y, 90, 30)];
    [_power0Lb setText:@"txtchk00".localizedString];
    [self addSubview:_power0Lb];
    y+= kPadding+30;
    
    _power1Box =[[BEMCheckBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_powerOffLb.frame), y+(30-checkBoxHeight)/2, 30, 30)];
    [self addSubview:_power1Box];
    
    _power1Lb =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_power1Box.frame)+kPadding, y, 90, 30)];
    [_power1Lb setText:@"txtchk30".localizedString];
    [self addSubview:_power1Lb];
    y+= kPadding+30;
    
    _power2Box =[[BEMCheckBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_powerOffLb.frame), y+(30-checkBoxHeight)/2, 30, 30)];
    [self addSubview:_power2Box];
    
    _power2Lb =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_power2Box.frame)+kPadding, y, 90, 30)];
    [_power2Lb setText:@"txtchk60".localizedString];
    [self addSubview:_power2Lb];
    y+= kPadding+30;
    
    _power3Box =[[BEMCheckBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_powerOffLb.frame), y+(30-checkBoxHeight)/2, 30, 30)];
    [self addSubview:_power3Box];
    
    _power3Lb =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_power3Box.frame)+kPadding, y, 90, 30)];
    [_power3Lb setText:@"txtchk90".localizedString];
    [self addSubview:_power3Lb];
    y+=kPadding+30;
    
    _power4Box =[[BEMCheckBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_powerOffLb.frame), y+(30-checkBoxHeight)/2, 30, 30)];
    [self addSubview:_power4Box];
    _power4Lb =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_power4Box.frame)+kPadding, y, 90, 30)];
    [_power4Lb setText:@"txtchk120".localizedString];
    [self addSubview:_power4Lb];
    y+= kPadding+30;
    
    _okBtn = [[UIButton alloc] initWithFrame:CGRectMake(kPadding*2, y, viewWidth-4*kPadding, kButtonHeight)];
    [_okBtn setAppThemeType:ButtonStyleStyleAppTheme];
    [_okBtn setTitle:NSLocalizedString(@"Ok",nil) forState:UIControlStateNormal];
    [self addSubview:_okBtn];
    
    self.checkGroup = [BEMCheckBoxGroup groupWithCheckBoxes:@[self.power0Box,self.power1Box,self.power2Box,self.power3Box,self.power4Box]];
  //  self.group.selectedCheckBox = self.checkBox2; // Optionally set which checkbox is pre-selected
    self.checkGroup.mustHaveSelection = YES; // Define if the group must always have a selection
    
    
    
    
}

#pragma checkbox
- (void)didTapCheckBox:(BEMCheckBox*)checkBox{
    BOOL value = checkBox.on;
    if (checkBox == _checkOnBox) {
        
    }
    else if(checkBox == _power0Box){
        
    }
    else if(checkBox == _power1Box){
        
    }
    else if(checkBox == _power2Box){
        
    }
    else if(checkBox == _power3Box){
        
    }
    else if(checkBox == _power4Box){
        
    }
    
}

+ (CGSize)viewSize{
    float viewWidth = (kScreenWidth - 4*kPadding);
    
    
    float width = viewWidth;
    float y = 3.5*kPadding;
    y += titleHeight+kPadding*2;
    y += 30+2*kPadding;
    y+= 20+kPadding;
    y+= kPadding+30;
    y+= kPadding+30;
    y+= kPadding+30;
    y+= kPadding+30;
    y+= kPadding+30;
    y+= kButtonHeight;
    y+=2*kPadding;
    return CGSizeMake(width, y);
}



@end
