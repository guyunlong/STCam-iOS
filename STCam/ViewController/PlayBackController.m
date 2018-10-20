//
//  PlayBackController.m
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "PlayBackController.h"
#import "AAPLEAGLLayer.h"
#import "PrefixHeader.h"
#define poswidth 80*kWidthCoefficient
#define playButtonWidth 50*kWidthCoefficient

 static  int REMOTEFILE_INDEX_FILESIZE = 1;
 static  int REMOTEFILE_INDEX_TIMESTAMP = 2;


@interface PlayBackController ()<PlayBackVidViewModelDelegate>{
    NSTimeInterval iTimeDragPos;
}
@property (strong, nonatomic)  AAPLEAGLLayer *glLayer;//视频播放控件
@property (strong, nonatomic)  UIButton *exitBtn;//退出
@property (strong, nonatomic)  UIButton *playBtn;//播放按钮
@property (strong, nonatomic)  UILabel *posLabel;//播放时刻
@property (strong, nonatomic)  UILabel *durLabel;//录像时常
@property (strong, nonatomic)  UISlider *slider;//进度条
@property (strong, nonatomic)  NSTimer *loopTimer;
@end

@implementation PlayBackController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    _viewModel.isPlay = YES;
    [_viewModel playRemoteFile];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [_viewModel stopPlayRemoteFile];
    [_loopTimer invalidate];
    _loopTimer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViewModel];
    //开启定时器
    _loopTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(refreshView) userInfo:nil repeats:YES];
    
}
-(void)setupViewModel{
    _viewModel.delegate = self;
}
-(void)loadView{
    [super loadView];
    _glLayer = [[AAPLEAGLLayer alloc] initWithFrame:self.view.bounds];
    [_glLayer setBackgroundColor:[[UIColor colorWithHexString:@"0x000000"] CGColor]];
    [self.view.layer addSublayer:_glLayer];
    
    _exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(kPadding*2, kPadding*1.5, 40*kWidthCoefficient, 40*kWidthCoefficient)];
    [_exitBtn setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [self.view addSubview:_exitBtn];
    [_exitBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self rotateToLandscape];
    
}

-(void)refreshView{
    int IndexType = thNet_RemoteFileGetIndexType((HANDLE) self.viewModel.deviceModel.NetHandle);
    if (IndexType != REMOTEFILE_INDEX_TIMESTAMP)
    {
        [_slider setHidden:YES];
        [_playBtn setHidden:YES];
        [_posLabel setHidden:YES];
        [_durLabel setHidden:YES];
        return;
    }
    BOOL IsClose = thNet_RemoteFileIsClose(self.viewModel.deviceModel.NetHandle);
    int iPosition = thNet_RemoteFileGetPosition(self.viewModel.deviceModel.NetHandle);
    int iMax = thNet_RemoteFileGetDuration(self.viewModel.deviceModel.NetHandle);
    
    if (IsClose)
    {
        _viewModel.isPlay = NO;
        [_playBtn setSelected:!_viewModel.isPlay];
        iPosition = 0;
    }
    
    if (iMax > 0 && IndexType > 0)
    {
        [_slider setMaximumValue:iMax];
        if (iTimeDragPos == 0) {
            [_slider setValue:iPosition];
        }
        else if([[NSDate date] timeIntervalSince1970] - iTimeDragPos >2){
            iTimeDragPos = 0;
        }
        
        
        
        if (IndexType == REMOTEFILE_INDEX_TIMESTAMP)//按时间戳
        {
            int iHour, iMinute, iSecond;
            
            iPosition = iPosition / 1000;
            iHour = iPosition / 3600;
            iMinute = (iPosition - iHour * 60) / 60;
            iSecond = iPosition % 60;
            NSString* StrPosition =[NSString stringWithFormat:@"%02d:%02d:%02d",iHour, iMinute, iSecond] ;//String.format("%02d:%02d:%02d", iHour, iMinute, iSecond);
            [_posLabel setText:StrPosition];
            
            iMax = iMax / 1000;
            iHour = iMax / 3600;
            iMinute = (iMax - iHour * 60) / 60;
            iSecond = iMax % 60;
            NSString* StrDuration =[NSString stringWithFormat:@"%02d:%02d:%02d",iHour, iMinute, iSecond] ;//String.format("%02d:%02d:%02d",
            [_durLabel setText:StrDuration];
        }
    }
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma methods
-(void)rotateToLandscape{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.view.bounds = CGRectMake(0, 0,kScreenHeight , kScreenWidth);
    self.view.transform = CGAffineTransformMakeRotation(M_PI*1.5);
    [UIView beginAnimations:nil context:nil];
    [UIView commitAnimations];
    [_glLayer setFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
    
    _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenHeight/2-playButtonWidth/2, kScreenWidth-120*kWidthCoefficient, playButtonWidth, playButtonWidth)];
    [_playBtn setImage:[UIImage imageNamed:@"pause0"] forState:UIControlStateNormal];
    [_playBtn setImage:[UIImage imageNamed:@"play0"] forState:UIControlStateSelected];
    [self.view addSubview:_playBtn];
    [_playBtn addTarget:self action:@selector(playControl) forControlEvents:UIControlEventTouchUpInside];
    
    _posLabel = [[UILabel alloc]initWithFrame:CGRectMake(kPadding,kScreenWidth-(120*kWidthCoefficient-playButtonWidth-kPadding), poswidth, 25*kWidthCoefficient)];
    [_posLabel setTextColor:[UIColor whiteColor]];
    [_posLabel setTextAlignment:NSTextAlignmentRight];
    [_posLabel setText:@"00:00"];
    [self.view addSubview:_posLabel];
    
    
    _durLabel =[[UILabel alloc]initWithFrame:CGRectMake(kScreenHeight-kPadding-poswidth,kScreenWidth-(120*kWidthCoefficient-playButtonWidth-kPadding), poswidth, 25*kWidthCoefficient)];
    [_durLabel setTextColor:[UIColor whiteColor]];
    [_durLabel setText:@"00:00"];
    [self.view addSubview:_durLabel];
    
    _slider = [UISlider new];
    [_slider addTarget:self action:@selector(sliderChange) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];
    
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.equalTo(@50);
        make.centerY.mas_equalTo(self.durLabel.mas_centerY);
        make.left.mas_equalTo(self.posLabel.mas_right).with.offset(kPadding);
        make.right.mas_equalTo(self.durLabel.mas_left).with.offset(-kPadding);
    }];
    
    
}


-(void)sliderChange{
    int iPos = [_slider value];
    thNet_RemoteFileSetPosition(_viewModel.deviceModel.NetHandle,iPos);
    //iTimeDragPos = lib.GetTime();
    iTimeDragPos = [[NSDate date] timeIntervalSince1970];
}

-(void)playControl{
    _viewModel.isPlay = !_viewModel.isPlay;
    [_playBtn setSelected:!_viewModel.isPlay];
    [_viewModel playControlRemoteFile:_viewModel.isPlay];
}

# pragma  delegate
- (void)updateVidView:(CVPixelBufferRef)pixelBuffer{
    _glLayer.pixelBuffer = pixelBuffer;
}

@end
