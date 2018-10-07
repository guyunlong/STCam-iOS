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
@interface LiveVidController ()<VidViewModelDelegate>
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
@end

@implementation LiveVidController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_viewModel openVid:1];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_viewModel closeVid];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewModel.delegate = self;
}
-(void)loadView{
    [super loadView];
    self.edgesForExtendedLayout=UIRectEdgeBottom;//IOS 有导航栏的时候，坐标从(0,64)变成从(0,0)开始
    [self initNav];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _glLayer = [[AAPLEAGLLayer alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kSafeAreaBottomHeight-kSafeAreaHeaderHeight-64-250*kWidthCoefficient)];
    [_glLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [self.view.layer addSublayer:_glLayer];
    [self layoutButtons];
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
    
    y = 2*kPadding;
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
    [_speechBtn setBackgroundImage:[UIImage imageNamed:@"livespeech_sel"] forState:UIControlStateSelected];
    [_snapShotBtn setImage:[UIImage imageNamed:@"livesnapshot_nor"] forState:UIControlStateNormal];
    [_snapShotBtn setImage:[UIImage imageNamed:@"livesnapshot_sel"] forState:UIControlStateHighlighted];
    [_portButtonView addSubview:_recordBtn];
    [_portButtonView addSubview:_speechBtn];
    [_portButtonView addSubview:_snapShotBtn];
    
    [_fullScreenBtn addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_hdBtn addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_playAudioBtn addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    /**********landscape buttons*************/
    _exitFullScreenButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadding, kPadding, firstLineWidth, firstLineWidth)];
    [_exitFullScreenButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [_exitFullScreenButton addTarget:self action:@selector(controlButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_exitFullScreenButton setHidden:YES];
    [self.view addSubview:_exitFullScreenButton];
}
#pragma click event
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)controlButtonClicked:(id)sender{
    if ([sender isEqual:_fullScreenBtn]) {
        [self rotateToLandscape];
    }
    else if([sender isEqual:_exitFullScreenButton]){
         [self rotateToPortrait];
    }
    else if([sender isEqual:_hdBtn]){
        [_viewModel setSub:1-_viewModel.sub];
        [_viewModel openVid:_viewModel.sub];
        [_hdBtn setSelected:1-_viewModel.sub];
    }
    else if([sender isEqual:_playAudioBtn]){
        _viewModel.openaud = 1- _viewModel.openaud;
        [_viewModel openAud:_viewModel.openaud];
        [_playAudioBtn setSelected:_viewModel.openaud];
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
}

# pragma  delegate
- (void)updateVidView:(CVPixelBufferRef)pixelBuffer{
    _glLayer.pixelBuffer = pixelBuffer;
}

@end
