//
//  LedControlController.m
//  STCam
//
//  Created by cc on 2018/10/26.
//  Copyright © 2018 South. All rights reserved.
//

#import "LedControlController.h"
#import "PrefixHeader.h"
#import "STSlider.h"
#import "WSDatePickerView.h"
#define Segment1Width 60*kWidthCoefficient
#define Segment2Width 50*kWidthCoefficient
#define  StatusLedWidth 60*kWidthCoefficient
#define  SegmengHeight 40*kWidthCoefficient
#define labelHeight 21*kWidthCoefficient
#define sliderHeight 25*kWidthCoefficient
#define timeButtonHeigth 40*kWidthCoefficient
#define timeButtonWidth 80*kWidthCoefficient
@interface LedControlController ()
@property(nonatomic,strong)UIImageView * ledStatusImageView;
@property(nonatomic,strong)UIView* backView; //背景
@property(nonatomic,strong)UISegmentedControl* modeSegment; //模式选择
/**********亮灯时间 单位s 进度条**************/
@property(nonatomic,strong)UILabel* ledTurnOnTimeLb;//亮灯时间（s）
@property(nonatomic,strong)UISlider* ledTurnOnTimeSlider;
@property(nonatomic,strong)UILabel* ledTurnOnTimeValueLb;

/**********亮度调节 进度条**************/
@property(nonatomic,strong)UILabel* ledBrightnessLb;//亮度调节
@property(nonatomic,strong)UISlider* ledBrightnessSlider;
@property(nonatomic,strong)UILabel* ledBrightnessValueLb;
/**********光感灵敏度 SegmentedControl**************/
@property(nonatomic,strong)UILabel* ledSensitiveLb;//光感灵敏度
@property(nonatomic,strong)UISegmentedControl* ledSensitiveSegmented;

/**********亮灯时间 时间间隔**************/
@property(nonatomic,strong)UILabel* ledTurnOnStartEndLb;//亮灯时间
@property(nonatomic,strong)UIButton* timeStartBtn;
@property(nonatomic,strong)UIView* spiltStartEndView;//中间间隔
@property(nonatomic,strong)UIButton* timeEndBtn;

@property(nonatomic,strong)WSDatePickerView* datePickerViewStart;
@property(nonatomic,strong)WSDatePickerView* datePickerViewEnd;

@property(nonatomic,strong)NSDate* dateStart;
@property(nonatomic,strong)NSDate* dateEnd;
@end

@implementation LedControlController


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_modeSegment setSelectedSegmentIndex:0];
    [self reloadViewForAuto];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dateStart  = [NSDate date];
    _dateEnd  = [NSDate date];
    // Do any additional setup after loading the view.
}
-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"0xf0f0f0"]];
    [self initNav];
    
    CGFloat y = 2*kPadding;
    _ledStatusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-StatusLedWidth/2, y, StatusLedWidth, StatusLedWidth)];
    [_ledStatusImageView setImage:[UIImage imageNamed:@"light_close"]];
    [self.view addSubview:_ledStatusImageView];
    
    y += StatusLedWidth+kPadding;
    CGFloat contentWidth = kScreenWidth-kPadding;
    _backView = [[UIView alloc] initWithFrame:CGRectMake(kPadding/2, y,contentWidth , 0)];
    [_backView setBackgroundColor:[UIColor whiteColor]];
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    _backView.layer.borderColor = [UIColor colorWithHexString:@"0xaaaaaa"].CGColor;
    _backView.layer.borderWidth = 1;
    [self.view addSubview:_backView];
    
    
    NSArray * modeSegmentArray =  [[NSArray alloc]initWithObjects:@"action_led_model_1".localizedString,@"action_led_model_2".localizedString,@"action_led_model_3".localizedString,@"action_led_model_4".localizedString, nil];
    _modeSegment = [[UISegmentedControl alloc] initWithItems:modeSegmentArray];
    [_modeSegment setFrame:CGRectMake(kPadding, kPadding, Segment1Width*4, SegmengHeight)];
    [_backView addSubview:_modeSegment];
    [_modeSegment addTarget:self action:@selector(selectChanged:) forControlEvents:UIControlEventValueChanged];
    
    /**********亮灯时间 单位s 进度条**************/
     UIImage *thumbImage = [UIImage imageNamed:@"sliderthumb"];
    _ledTurnOnTimeLb = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, 0, contentWidth,labelHeight)];
    [_ledTurnOnTimeLb setText:@"action_led_open_time".localizedString];
    [_backView addSubview:_ledTurnOnTimeLb];
    
    
    _ledTurnOnTimeSlider = [[UISlider alloc] initWithFrame:CGRectMake(kPadding, 0, contentWidth-kPadding-60*kWidthCoefficient, sliderHeight)];
    [_backView addSubview:_ledTurnOnTimeSlider];
    [_ledTurnOnTimeSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    _ledTurnOnTimeValueLb = [[UILabel alloc] initWithFrame:CGRectMake(contentWidth-70*kWidthCoefficient, 0, 60*kWidthCoefficient, sliderHeight)];
    [_ledTurnOnTimeValueLb setText:@"0"];
    [_ledTurnOnTimeValueLb setTextAlignment:NSTextAlignmentRight];
    [_backView addSubview:_ledTurnOnTimeValueLb];
    
    
    /**********亮度调节 进度条**************/
    _ledBrightnessLb = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, 0, contentWidth,labelHeight)];
    [_ledBrightnessLb setText:@"action_led_brightness".localizedString];
    [_backView addSubview:_ledBrightnessLb];
    
    
    _ledBrightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(kPadding, 0, contentWidth-kPadding-60*kWidthCoefficient, sliderHeight)];
    [_backView addSubview:_ledBrightnessSlider];
    
    
    [_ledBrightnessSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    
    
    _ledBrightnessValueLb = [[UILabel alloc] initWithFrame:CGRectMake(contentWidth-70*kWidthCoefficient, 0, 60*kWidthCoefficient, sliderHeight)];
    [_ledBrightnessValueLb setText:@"0"];
    [_ledBrightnessValueLb setTextAlignment:NSTextAlignmentRight];
    [_backView addSubview:_ledBrightnessValueLb];
    
    /**********光感灵敏度 SegmentedControl**************/
    _ledSensitiveLb = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, 0, contentWidth,SegmengHeight)];
    [_ledSensitiveLb setText:@"action_led_sensitive".localizedString];
    [_backView addSubview:_ledSensitiveLb];
    CGFloat ledSensitiveLbWidth =[@"action_led_sensitive".localizedString getWidthWithFont:_ledSensitiveLb.font constrainedToSize:CGSizeMake(contentWidth, SegmengHeight)];
    [_ledSensitiveLb setWidth:ledSensitiveLbWidth];
    
    //ledSensitiveSegmented
    NSArray * sensitiveSegmentedArray =  [[NSArray alloc]initWithObjects:@"action_level_high".localizedString,@"action_level_middle".localizedString,@"action_level_low".localizedString, nil];
    _ledSensitiveSegmented = [[UISegmentedControl alloc] initWithItems:sensitiveSegmentedArray];
    [_ledSensitiveSegmented setFrame:CGRectMake(kPadding+ledSensitiveLbWidth+kPadding, 0, Segment2Width*3, SegmengHeight)];
    [_backView addSubview:_ledSensitiveSegmented];
    
    
    /**********亮灯时间 时间间隔**************/
    _ledTurnOnStartEndLb = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, 0, contentWidth,timeButtonHeigth)];
    [_ledTurnOnStartEndLb setText:@"action_time".localizedString];
    [_backView addSubview:_ledTurnOnStartEndLb];
    CGFloat ledTurnOnStartEndWidth =[@"action_time".localizedString getWidthWithFont:_ledTurnOnStartEndLb.font constrainedToSize:CGSizeMake(contentWidth, timeButtonHeigth)];
    [_ledTurnOnStartEndLb setWidth:ledTurnOnStartEndWidth];
    
    
    CGFloat x = kPadding+ledTurnOnStartEndWidth+kPadding;
    _timeStartBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, timeButtonWidth, timeButtonHeigth)];
    [_timeStartBtn setTitle:@"00:00" forState:UIControlStateNormal];
    [_timeStartBtn setAppThemeType:ButtonStyleText_Time_button];
    [_backView addSubview:_timeStartBtn];
    x +=timeButtonWidth+kPadding/2;
    _spiltStartEndView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, kPadding, 1)];
    [_spiltStartEndView setBackgroundColor:[UIColor colorWithHexString:@"0x969696"]];
     [_backView addSubview:_timeStartBtn];
    x += kPadding+kPadding/2;
    _timeEndBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, timeButtonWidth, timeButtonHeigth)];
    [_timeEndBtn setTitle:@"00:00" forState:UIControlStateNormal];
    [_timeEndBtn setAppThemeType:ButtonStyleText_Time_button];
    [_backView addSubview:_timeEndBtn];
    [_timeStartBtn addTarget:self action:@selector(timeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_timeEndBtn addTarget:self action:@selector(timeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)initNav{
    [self setTitle:@"action_led_control".localizedString];
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

-(void)reloadViewForAuto{
    /**********亮灯时间 单位s 进度条**************/
    [_ledTurnOnTimeLb setHidden:NO];
    [_ledTurnOnTimeSlider setHidden:NO];
    [_ledTurnOnTimeValueLb setHidden:NO];
    /**********亮度调节 进度条**************/
    [_ledBrightnessLb setHidden:NO];
    [_ledBrightnessSlider setHidden:NO];
    [_ledBrightnessValueLb setHidden:NO];
    /**********光感灵敏度 SegmentedControl**************/
    [_ledSensitiveLb setHidden:NO];
    [_ledSensitiveSegmented setHidden:NO];
    
    /**********亮灯时间 时间间隔**************/
    [_ledTurnOnStartEndLb setHidden:YES];
    [_timeStartBtn setHidden:YES];
    [_spiltStartEndView setHidden:YES];
    [_timeEndBtn setHidden:YES];
    
    CGFloat y = 2*kPadding+SegmengHeight+kPadding;
    [_ledTurnOnTimeLb setY:y];
    y += labelHeight+kPadding/2;
    [_ledTurnOnTimeSlider setY:y];
    [_ledTurnOnTimeValueLb setY:y];
    
    y += sliderHeight+kPadding;
    [_ledBrightnessLb setY:y];
     y += labelHeight+kPadding/2;
    [_ledBrightnessSlider setY:y];
    [_ledBrightnessValueLb setY:y];
    
     y += sliderHeight+kPadding;
    [_ledSensitiveLb setY:y];
    [_ledSensitiveSegmented setY:y];
    y+= SegmengHeight +kPadding;
    [_backView setHeight:y];
    
    
}
-(void)reloadViewForByHand{
    /**********亮灯时间 单位s 进度条**************/
    [_ledTurnOnTimeLb setHidden:YES];
    [_ledTurnOnTimeSlider setHidden:YES];
    [_ledTurnOnTimeValueLb setHidden:YES];
    /**********亮度调节 进度条**************/
    [_ledBrightnessLb setHidden:NO];
    [_ledBrightnessSlider setHidden:NO];
    [_ledBrightnessValueLb setHidden:NO];
    /**********光感灵敏度 SegmentedControl**************/
    [_ledSensitiveLb setHidden:YES];
    [_ledSensitiveSegmented setHidden:YES];
    
    /**********亮灯时间 时间间隔**************/
    [_ledTurnOnStartEndLb setHidden:YES];
    [_timeStartBtn setHidden:YES];
    [_spiltStartEndView setHidden:YES];
    [_timeEndBtn setHidden:YES];
    
    CGFloat y = 2*kPadding+SegmengHeight+kPadding;
    [_ledBrightnessLb setY:y];
    y += labelHeight+kPadding/2;
    [_ledBrightnessSlider setY:y];
    [_ledBrightnessValueLb setY:y];
    y+= sliderHeight +kPadding;
    [_backView setHeight:y];
    
    
}
-(void)reloadViewForTimer{
    /**********亮灯时间 单位s 进度条**************/
    [_ledTurnOnTimeLb setHidden:YES];
    [_ledTurnOnTimeSlider setHidden:YES];
    [_ledTurnOnTimeValueLb setHidden:YES];
    /**********亮度调节 进度条**************/
    [_ledBrightnessLb setHidden:NO];
    [_ledBrightnessSlider setHidden:NO];
    [_ledBrightnessValueLb setHidden:NO];
    /**********光感灵敏度 SegmentedControl**************/
    [_ledSensitiveLb setHidden:YES];
    [_ledSensitiveSegmented setHidden:YES];
    
    /**********亮灯时间 时间间隔**************/
    [_ledTurnOnStartEndLb setHidden:NO];
    [_timeStartBtn setHidden:NO];
    [_spiltStartEndView setHidden:NO];
    [_timeEndBtn setHidden:NO];
    
    CGFloat y = 2*kPadding+SegmengHeight+kPadding;
    [_ledTurnOnStartEndLb setY:y];
    [_timeStartBtn setY:y];
    [_spiltStartEndView setY:y+timeButtonHeigth/2];
    [_timeEndBtn setY:y];
    
    y += timeButtonHeigth+kPadding/2;
    [_ledBrightnessLb setY:y];
    y += labelHeight+kPadding/2;
    [_ledBrightnessSlider setY:y];
    [_ledBrightnessValueLb setY:y];
    y+= sliderHeight +kPadding;
    [_backView setHeight:y];
    
}
-(void)reloadViewForD2D{
    /**********亮灯时间 单位s 进度条**************/
    [_ledTurnOnTimeLb setHidden:YES];
    [_ledTurnOnTimeSlider setHidden:YES];
    [_ledTurnOnTimeValueLb setHidden:YES];
    /**********亮度调节 进度条**************/
    [_ledBrightnessLb setHidden:NO];
    [_ledBrightnessSlider setHidden:NO];
    [_ledBrightnessValueLb setHidden:NO];
    /**********光感灵敏度 SegmentedControl**************/
    [_ledSensitiveLb setHidden:NO];
    [_ledSensitiveSegmented setHidden:NO];
    
    /**********亮灯时间 时间间隔**************/
    [_ledTurnOnStartEndLb setHidden:YES];
    [_timeStartBtn setHidden:YES];
    [_spiltStartEndView setHidden:YES];
    [_timeEndBtn setHidden:YES];
    
    CGFloat y = 2*kPadding+SegmengHeight+kPadding;
    [_ledBrightnessLb setY:y];
    y += labelHeight+kPadding/2;
    [_ledBrightnessSlider setY:y];
    [_ledBrightnessValueLb setY:y];
    y+= sliderHeight +kPadding;
    
    [_ledSensitiveLb setY:y];
    [_ledSensitiveSegmented setY:y];
    y+= SegmengHeight +kPadding;
    [_backView setHeight:y];
    
    
}

-(void)selectChanged:(id)sender{
    UISegmentedControl* control = (UISegmentedControl*)sender;
    if (sender == _modeSegment) {
        switch (control.selectedSegmentIndex) {
            case 0://自动
                NSLog(@"0");
                [self reloadViewForAuto];
                break;
            case 1://手动
                [self reloadViewForByHand];
                NSLog(@"1");
                break;
            case 2://定时
                [self reloadViewForTimer];
                NSLog(@"2");
                break;
            case 3://d2d
                [self reloadViewForD2D];
                NSLog(@"2");
                break;
            default:
                NSLog(@"3");
                break;
        }
    }
}
-(void)timeButtonClicked:(id)sender{
    UIButton * btn  =sender;
    if (btn == _timeStartBtn) {
        @weakify(self)
        if (!_datePickerViewStart) {
            _datePickerViewStart =  [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowHourMinute scrollToDate:_dateStart CompleteBlock:^(NSDate *startDate) {
                @strongify(self)
                self.dateStart = startDate;
                NSString *date = [startDate stringWithFormat:@"HH:mm"];
                NSLog(@"时间： %@",date);
                [btn setTitle:date forState:UIControlStateNormal];
                
            }];
            _datePickerViewStart.doneButtonColor = kMainColor;//确定按钮的颜色
            
        }
    }
    else if(sender == _timeEndBtn){
        if (!_datePickerViewStart) {
             @weakify(self)
            _datePickerViewStart =  [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowHourMinute scrollToDate:_dateEnd CompleteBlock:^(NSDate *startDate) {
                @strongify(self)
                self.dateEnd = startDate;
                NSString *date = [startDate stringWithFormat:@"HH:mm"];
                NSLog(@"时间： %@",date);
                [btn setTitle:date forState:UIControlStateNormal];
                
            }];
            _datePickerViewStart.doneButtonColor = kMainColor;//确定按钮的颜色
            
        }
    }
}


@end
