//
//  LiveVidController.m
//  STCam
//
//  Created by guyunlong on 10/6/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "LiveVidController.h"
#import "PrefixHeader.h"
#import "AAPLEAGLLayer.h"
#import "SoundButton.h"
#import "DeviceSettingController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "LedControlController.h"

@interface LiveVidController ()<VidViewModelDelegate>{
    BOOL isLandscape;
}
@property (strong, nonatomic)  AAPLEAGLLayer *glLayer;//视频播放控件
@property (strong, nonatomic)  UIButton * ledBtn;
@property (strong, nonatomic)  UIButton * settingBtn;
@property (strong, nonatomic)  UIButton * playAudioBtn;
@property (strong, nonatomic)  UIButton * speechBtn;
@property (strong, nonatomic)  UIButton * hdBtn;
@property (strong, nonatomic)  UIButton * recordBtn;
@property (strong, nonatomic)  UIButton * snapShotBtn;
@property (strong, nonatomic)  UIButton * fullScreenBtn;
@property (strong, nonatomic)  UIView * portButtonView;

@property (strong, nonatomic)  UIButton * exitFullScreenButton;


@property (strong, nonatomic)  UIButton * ledBtn_land;
@property (strong, nonatomic)  UIButton * settingBtn_land;
@property (strong, nonatomic)  UIButton * playAudioBtn_land;
@property (strong, nonatomic)  UIButton * speechBtn_land;
@property (strong, nonatomic)  UIButton * hdBtn_land;
@property (strong, nonatomic)  UIButton * recordBtn_land;
@property (strong, nonatomic)  UIButton * snapShotBtn_land;

@property (strong, nonatomic) UILabel * recordTimeLabel;

@property (strong, nonatomic) NSTimer * recordTime;
@property (strong, nonatomic)  UIView *gestureControlView;//手势控制

@property(nonatomic,assign) BOOL showHud;//是否已经获得第一帧视频
@end

@implementation LiveVidController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_viewModel openVid:1];
    
    _showHud = YES;
    if(isLandscape){
        [self.navigationController setNavigationBarHidden:YES];
        [self showHudInView:self.view hint:nil];
    }
    else{
        [self showHudInViewOffset:self.view hint:nil offset:-kScreenHeight/6];
    }
    @weakify(self)
    [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        if (self.showHud)
        {
            [self showHint:@"Network_error".localizedString];
            [self back];
        }
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_viewModel closeVid];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewModel.delegate = self;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterbackground) name:AppDidEnterbackground object:nil];
    
    
}
-(void)appDidEnterbackground{
    [_viewModel closeVid];
    [self back];
}
-(void)loadView{
    [super loadView];
    self.edgesForExtendedLayout=UIRectEdgeBottom;//IOS 有导航栏的时候，坐标从(0,64)变成从(0,0)开始
    [self initNav];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _glLayer = [[AAPLEAGLLayer alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kSafeAreaBottomHeight-kSafeAreaHeaderHeight-64-250*kWidthCoefficient)];
    [_glLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [self.view.layer addSublayer:_glLayer];
   
    _gestureControlView = [[UIView alloc] initWithFrame:self.view.bounds];
    [_gestureControlView setBackgroundColor:[UIColor clearColor]];
    [_gestureControlView setUserInteractionEnabled:YES];
    
    [self.view addSubview:_gestureControlView];
    
     [self initGesture];
    
    
    [self layoutButtons];
    
    /***********录像时间***********/
    _recordTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30*kWidthCoefficient, kScreenWidth, 40*kWidthCoefficient)];
    [_recordTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [_recordTimeLabel setFont:[UIFont systemFontOfSize:22]];
    [_recordTimeLabel setTextColor:[UIColor redColor]];
    [_recordTimeLabel setText:@"REC\040\04000:00"];
    [_recordTimeLabel setHidden:YES];
    [self.view addSubview:_recordTimeLabel];
}
-(void)startRecordTime{
    __block NSInteger timeCount = 0;
    [_recordTimeLabel setHidden:NO];
    @weakify(self)
    _recordTime = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        ++timeCount;
        @strongify(self)
         [self.recordTimeLabel setText:[NSString stringWithFormat:@"REC\040\040%02ld:%02ld",timeCount/60,timeCount%60]];
        
    }];
}
-(void)stopRecordTime{
    [_recordTime invalidate];
    _recordTime = nil;
    [_recordTimeLabel setHidden:YES];
    [_recordTimeLabel setText:@"REC\040\04000:00"];
    
    
}
-(void)initNav{
    [self setTitle:_viewModel.model.DevName];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 28, 28);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    
}
-(void)layoutButtons{
    /**********portrait buttons*************/
    CGFloat y = kScreenHeight-kSafeAreaBottomHeight-kSafeAreaHeaderHeight-64-250*kWidthCoefficient;
    _portButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, 250*kWidthCoefficient)];
    [self.view addSubview:_portButtonView];
    CGFloat firstLineWidth = 50*kWidthCoefficient;
    CGFloat secondLineWidth = 60*kWidthCoefficient;
    CGFloat speechWidth = 80*kWidthCoefficient;
    CGFloat firstLineSpan =(kScreenWidth- firstLineWidth*5)/6;
     CGFloat secondLineSpan =(kScreenWidth- 2*secondLineWidth-speechWidth)/4;
    
    y = 5*kPadding;
    _ledBtn = [[UIButton alloc] initWithFrame:CGRectMake(firstLineSpan, y, firstLineWidth, firstLineWidth)];
    _playAudioBtn = [[UIButton alloc] initWithFrame:CGRectMake(firstLineSpan*2+firstLineWidth, y, firstLineWidth, firstLineWidth)];
    _hdBtn = [[UIButton alloc] initWithFrame:CGRectMake(firstLineSpan*3+firstLineWidth*2, y, firstLineWidth, firstLineWidth)];
    _settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(firstLineSpan*4+firstLineWidth*3, y, firstLineWidth, firstLineWidth)];
    _fullScreenBtn = [[UIButton alloc] initWithFrame:CGRectMake(firstLineSpan*5+firstLineWidth*4, y, firstLineWidth, firstLineWidth)];
    [_ledBtn setImage:[UIImage imageNamed:@"liveled_nor"] forState:UIControlStateNormal];
    [_ledBtn setImage:[UIImage imageNamed:@"liveled_sel"] forState:UIControlStateHighlighted];
    
    [_playAudioBtn setImage:[UIImage imageNamed:@"livetalkoff_nor"] forState:UIControlStateNormal];
    [_playAudioBtn setImage:[UIImage imageNamed:@"livetalkoff_sel"] forState:UIControlStateHighlighted];
    [_playAudioBtn setImage:[UIImage imageNamed:@"livetalkon_sel"] forState:UIControlStateSelected];
    
    [_hdBtn setImage:[UIImage imageNamed:@"livehd_nor"] forState:UIControlStateNormal];
    [_hdBtn setImage:[UIImage imageNamed:@"livehd_sel"] forState:UIControlStateSelected];
    
    [_settingBtn setImage:[UIImage imageNamed:@"livesetting_nor"] forState:UIControlStateNormal];
    [_settingBtn setImage:[UIImage imageNamed:@"livesetting_sel"] forState:UIControlStateHighlighted];
    
    [_fullScreenBtn setImage:[UIImage imageNamed:@"livefullscreen_nor"] forState:UIControlStateNormal];
    [_fullScreenBtn setImage:[UIImage imageNamed:@"livefullscreen_sel"] forState:UIControlStateHighlighted];
    
    [_portButtonView addSubview:_ledBtn];
    [_portButtonView addSubview:_playAudioBtn];
    [_portButtonView addSubview:_hdBtn];
    [_portButtonView addSubview:_settingBtn];
    [_portButtonView addSubview:_fullScreenBtn];
    
    y += kPadding*2 +firstLineWidth;
    _recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(secondLineSpan, y+kPadding, secondLineWidth, secondLineWidth)];
    _speechBtn = [[UIButton alloc] initWithFrame:CGRectMake(secondLineSpan*2+secondLineWidth, y+kPadding, speechWidth, speechWidth)];
    _snapShotBtn = [[UIButton alloc] initWithFrame:CGRectMake(secondLineSpan*3+secondLineWidth+speechWidth, y+kPadding, secondLineWidth, secondLineWidth)];
   
    [_recordBtn setImage:[UIImage imageNamed:@"liverecord_nor"] forState:UIControlStateNormal];
    [_recordBtn setImage:[UIImage imageNamed:@"liverecord_sel"] forState:UIControlStateSelected];
    [_speechBtn setBackgroundImage:[UIImage imageNamed:@"livespeech_nor"] forState:UIControlStateNormal];
    [_speechBtn setBackgroundImage:[UIImage imageNamed:@"livespeech_sel"] forState:UIControlStateHighlighted];
    @weakify(self)
    [[_speechBtn rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel talkBegin];
    }];
    [[_speechBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel talkEnd];
    }];
    [[_speechBtn rac_signalForControlEvents:UIControlEventTouchUpOutside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel talkEnd];
    }];
    
    
    [_snapShotBtn setImage:[UIImage imageNamed:@"livesnapshot_nor"] forState:UIControlStateNormal];
    [_snapShotBtn setImage:[UIImage imageNamed:@"livesnapshot_sel"] forState:UIControlStateHighlighted];
    [_portButtonView addSubview:_recordBtn];
    [_portButtonView addSubview:_speechBtn];
    [_portButtonView addSubview:_snapShotBtn];
    
    [_fullScreenBtn addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_hdBtn addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_playAudioBtn addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_snapShotBtn addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     [_recordBtn addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     [_settingBtn addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
     [_ledBtn addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    /**********landscape buttons*************/
    _exitFullScreenButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadding, kPadding, firstLineWidth, firstLineWidth)];
    [_exitFullScreenButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [_exitFullScreenButton addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_exitFullScreenButton setHidden:YES];
    [self.view addSubview:_exitFullScreenButton];
}

-(void)initGesture{
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [_gestureControlView addGestureRecognizer:recognizerRight];
    
    
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [_gestureControlView addGestureRecognizer:recognizerLeft];
    
    
    UISwipeGestureRecognizer *recognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [_gestureControlView addGestureRecognizer:recognizerUp];
    
    
    UISwipeGestureRecognizer *recognizerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [_gestureControlView addGestureRecognizer:recognizerDown];
    
   
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    
    [_gestureControlView addGestureRecognizer:pinchGestureRecognizer];
    

    
    
}

- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer {
    
    if (recognizer.state== UIGestureRecognizerStateEnded) {
        CGFloat zoomSize = recognizer.scale;
        if ( zoomSize > 1 ) { // 放大
            [_viewModel ptzControl:PtzControlType_Zoom0];
        } else { // 缩小
            [_viewModel ptzControl:PtzControlType_Zoom1];
        }
    }
    
}



-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"DirectionDown");
        [_viewModel ptzControl:PtzControlType_Down];
        
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
         [_viewModel ptzControl:PtzControlType_Up];
        NSLog(@"DirectionUp");
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"DirectionLeft");
         [_viewModel ptzControl:PtzControlType_Left];
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"DirectionRight");
         [_viewModel ptzControl:PtzControlType_Right];
    }
}

#pragma click event
-(void)back{
    [_viewModel destroyVidSelfPoint];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)controlButtonClicked:(id)sender{
    UIButton * btn  = sender;
    [btn setUserInteractionEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [btn setUserInteractionEnabled:YES];
    });
    if ([sender isEqual:_fullScreenBtn]) {
        [self rotateToLandscape];
    }
    else if([sender isEqual:_exitFullScreenButton]){
         [self rotateToPortrait];
    }
    else if([sender isEqual:_hdBtn] || [sender isEqual:_hdBtn_land]){
        if (thNet_IsRec(_viewModel.model.NetHandle)) {
            //停止录像
            BOOL ret = [_viewModel changeRecordStatus];
            [_recordBtn setSelected:ret];
            [_recordBtn_land setSelected:ret];
            [self stopRecordTime];
        }
        [_viewModel setSub:1-_viewModel.sub];
        [_viewModel openVid:_viewModel.sub];
        [_hdBtn setSelected:1-_viewModel.sub];
        [_hdBtn_land setSelected:1-_viewModel.sub];
        
    }
    else if([sender isEqual:_playAudioBtn] || [sender isEqual:_playAudioBtn_land]){
       
        _viewModel.openaud = 1- _viewModel.openaud;
        [_viewModel openAud:_viewModel.openaud];
        [_playAudioBtn setSelected:_viewModel.openaud];
        [_playAudioBtn_land setSelected:_viewModel.openaud];
        
        
    }
    else if([sender isEqual:_snapShotBtn] || [sender isEqual:_snapShotBtn_land]){
        _viewModel.snapShot = YES;
        AudioServicesPlaySystemSound(1108);
    }
    else if([sender isEqual:_recordBtn] || [sender isEqual:_recordBtn_land]){
        _viewModel.isRcord = !_viewModel.isRcord;
        if (_viewModel.isRcord) {
            AudioServicesPlaySystemSound(1117);
            BOOL ret = [_viewModel changeRecordStatus];
           [_recordBtn setSelected:ret];
           [_recordBtn_land setSelected:ret];
            [self startRecordTime];
            
        }
        else{
            AudioServicesPlaySystemSound(1118);
            BOOL ret = [_viewModel changeRecordStatus];
             [_recordBtn setSelected:ret];
             [_recordBtn_land setSelected:ret];
             [self stopRecordTime];
        }
        
        
    }
    else if([sender isEqual:_settingBtn] || [sender isEqual:_settingBtn_land]){
        DeviceSettingController * ctl = [DeviceSettingController new];
        DeviceSettingViewModel * viewModel = [DeviceSettingViewModel new];
        [viewModel setModel:self.viewModel.model];
        [ctl setViewModel:viewModel];
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else if(sender == _ledBtn || sender == _ledBtn_land){
        LedControlViewModel *viewModel = [LedControlViewModel new];
        [viewModel setModel:_viewModel.model];
        LedControlController * ctl = [LedControlController new];
        [ctl setViewModel:viewModel];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}
#pragma methods
-(void)rotateToLandscape{
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    [_exitFullScreenButton setHidden:NO];
    [_portButtonView setHidden:YES];
    
    self.view.bounds = CGRectMake(0, 0,kScreenHeight , kScreenWidth);
    self.view.transform = CGAffineTransformMakeRotation(M_PI*1.5);
    [UIView beginAnimations:nil context:nil];
    [UIView commitAnimations];
    [_glLayer setFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
    
    [_recordTimeLabel setFrame:CGRectMake(0, 30*kWidthCoefficient, kScreenHeight, 40*kWidthCoefficient)];
    
    
    
//    @property (strong, nonatomic)  UIButton * ledBtn_land;
//    @property (strong, nonatomic)  UIButton * settingBtn_land;
//    @property (strong, nonatomic)  UIButton * playAudioBtn_land;
//    @property (strong, nonatomic)  UIButton * speechBtn_land;
//    @property (strong, nonatomic)  UIButton * hdBtn_land;
//    @property (strong, nonatomic)  UIButton * recordBtn_land;
//    @property (strong, nonatomic)  UIButton * snapShotBtn_land;
    
    if (!_ledBtn_land) {
        CGFloat firstLineWidth = 50*kWidthCoefficient;
        CGFloat secondLineWidth = 60*kWidthCoefficient;
        CGFloat speechWidth = 80*kWidthCoefficient;
        CGFloat firstLineSpan =(kScreenWidth- firstLineWidth*5)/6;
       
        CGFloat y = kScreenWidth - kPadding - firstLineWidth;
        _ledBtn_land = [[UIButton alloc] initWithFrame:CGRectMake(firstLineSpan, y, firstLineWidth, firstLineWidth)];
        _playAudioBtn_land = [[UIButton alloc] initWithFrame:CGRectMake(firstLineSpan*2+firstLineWidth, y, firstLineWidth, firstLineWidth)];
        _hdBtn_land = [[UIButton alloc] initWithFrame:CGRectMake(firstLineSpan*3+firstLineWidth*2, y, firstLineWidth, firstLineWidth)];
        _settingBtn_land = [[UIButton alloc] initWithFrame:CGRectMake(firstLineSpan*4+firstLineWidth*3, y, firstLineWidth, firstLineWidth)];
        
        [_ledBtn_land setImage:[UIImage imageNamed:@"liveled_nor"] forState:UIControlStateNormal];
        [_ledBtn_land setImage:[UIImage imageNamed:@"liveled_sel"] forState:UIControlStateHighlighted];
        
        [_playAudioBtn_land setImage:[UIImage imageNamed:@"livetalkoff_nor"] forState:UIControlStateNormal];
        [_playAudioBtn_land setImage:[UIImage imageNamed:@"livetalkoff_sel"] forState:UIControlStateHighlighted];
        [_playAudioBtn_land setImage:[UIImage imageNamed:@"livetalkon_sel"] forState:UIControlStateSelected];
        
        
        [_hdBtn_land setImage:[UIImage imageNamed:@"livehd_nor"] forState:UIControlStateNormal];
        [_hdBtn_land setImage:[UIImage imageNamed:@"livehd_sel"] forState:UIControlStateSelected];
        
        [_settingBtn_land setImage:[UIImage imageNamed:@"livesetting_nor"] forState:UIControlStateNormal];
        [_settingBtn_land setImage:[UIImage imageNamed:@"livesetting_sel"] forState:UIControlStateHighlighted];
        
        
        [self.view addSubview:_ledBtn_land];
        [self.view addSubview:_playAudioBtn_land];
        [self.view addSubview:_hdBtn_land];
        [self.view addSubview:_settingBtn_land];
       
        
        _recordBtn_land = [[UIButton alloc] initWithFrame:CGRectMake(kScreenHeight - 2*kPadding - secondLineWidth, 2*kPadding, secondLineWidth, secondLineWidth)];
        _speechBtn_land = [[UIButton alloc] initWithFrame:CGRectMake(kScreenHeight - 2*kPadding - secondLineWidth-(speechWidth-secondLineWidth)/2, kScreenWidth/2-speechWidth/2, speechWidth, speechWidth)];
        _snapShotBtn_land = [[UIButton alloc] initWithFrame:CGRectMake(kScreenHeight - 2*kPadding - secondLineWidth, kScreenWidth-2*kPadding-secondLineWidth, secondLineWidth, secondLineWidth)];
        
      
        
        [self.view addSubview:_recordBtn_land];
        [self.view addSubview:_speechBtn_land];
        [self.view addSubview:_snapShotBtn_land];
        
        [_recordBtn_land setImage:[UIImage imageNamed:@"liverecord_nor"] forState:UIControlStateNormal];
        [_recordBtn_land setImage:[UIImage imageNamed:@"liverecord_sel"] forState:UIControlStateSelected];
        [_speechBtn_land setBackgroundImage:[UIImage imageNamed:@"livespeech_nor"] forState:UIControlStateNormal];
        [_speechBtn_land setBackgroundImage:[UIImage imageNamed:@"livespeech_sel"] forState:UIControlStateHighlighted];
        [_snapShotBtn_land setImage:[UIImage imageNamed:@"livesnapshot_nor"] forState:UIControlStateNormal];
        [_snapShotBtn_land setImage:[UIImage imageNamed:@"livesnapshot_sel"] forState:UIControlStateHighlighted];
        
        [_ledBtn_land addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_playAudioBtn_land addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_settingBtn_land addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_hdBtn_land addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtn_land addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_speechBtn_land addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_snapShotBtn_land addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        @weakify(self)
        [[_speechBtn_land rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel talkBegin];
        }];
        [[_speechBtn_land rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel talkEnd];
        }];
        [[_speechBtn_land rac_signalForControlEvents:UIControlEventTouchUpOutside] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel talkEnd];
        }];
    }
    
    [_ledBtn_land setHidden:NO];
    [_playAudioBtn_land setHidden:NO];
    [_hdBtn_land setHidden:NO];
    [_settingBtn_land setHidden:NO];
    [_recordBtn_land setHidden:NO];
    [_speechBtn_land setHidden:NO];
    [_snapShotBtn_land setHidden:NO];
    
    
  //  UserMode_Visitor
    DevListViewModel * viewModel = [DevListViewModel sharedDevListViewModel];
    if(viewModel.userMode == TUserMode_Login && !_viewModel.model.IsVideo){
        [_recordBtn_land setHidden:YES];
        [_speechBtn_land setHidden:YES];
    }
    if(viewModel.userMode == TUserMode_Login && !_viewModel.model.IsControl){
        [_ledBtn_land setHidden:YES];
    }
   [_playAudioBtn_land setSelected:_viewModel.openaud];
    [_hdBtn_land setSelected:1-_viewModel.sub];
    
    BOOL ret = thNet_IsRec(_viewModel.model.NetHandle);
    
    [_recordBtn setSelected:ret];
    [_recordBtn_land setSelected:ret];
    
    isLandscape = YES;
    
    [_gestureControlView setFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
   
}
-(void)rotateToPortrait{
     [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_exitFullScreenButton setHidden:YES];
    [_portButtonView setHidden:NO];
    
    self.view.bounds = CGRectMake(0, 0,kScreenWidth , kScreenHeight);
    self.view.transform = CGAffineTransformMakeRotation(0);
    [UIView beginAnimations:nil context:nil];
    [UIView commitAnimations];
    [_glLayer setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kSafeAreaBottomHeight-kSafeAreaHeaderHeight-64-250*kWidthCoefficient)];
    
    [_recordTimeLabel setFrame:CGRectMake(0, 30*kWidthCoefficient, kScreenWidth, 40*kWidthCoefficient)];
    
    
    [_ledBtn_land setHidden:YES];
    [_playAudioBtn_land setHidden:YES];
    [_hdBtn_land setHidden:YES];
    [_settingBtn_land setHidden:YES];
    [_recordBtn_land setHidden:YES];
    [_speechBtn_land setHidden:YES];
    [_snapShotBtn_land setHidden:YES];
    
    [_hdBtn setSelected:1-_viewModel.sub];
    
    
    isLandscape = NO;
    
    
    DevListViewModel * viewModel = [DevListViewModel sharedDevListViewModel];
    if(viewModel.userMode == TUserMode_Login && !_viewModel.model.IsVideo){
        [_recordBtn setHidden:YES];
        [_speechBtn setHidden:YES];
    }
    if(viewModel.userMode == TUserMode_Login && !_viewModel.model.IsControl){
        [_ledBtn setHidden:YES];
    }
    
    
    [_gestureControlView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
}

# pragma  delegate
- (void)updateVidView:(CVPixelBufferRef)pixelBuffer{
    _glLayer.pixelBuffer = pixelBuffer;
    if (_showHud) {
        _showHud = NO;
        [self hideHud];
    }
    
}

@end
