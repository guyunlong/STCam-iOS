//
//  LiveVidController.m
//  STCam
//
//  Created by guyunlong on 10/6/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "LiveVidController.h"
#import "AAPLEAGLLayer.h"
@interface LiveVidController ()<VidViewModelDelegate>
@property (strong, nonatomic)  AAPLEAGLLayer *glLayer;//视频播放控件
@end

@implementation LiveVidController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewModel.delegate = self;
}
-(void)loadView{
    [super loadView];
    [self initNav];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _glLayer = [[AAPLEAGLLayer alloc] initWithFrame:self.view.bounds];
    [_glLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [self.view.layer addSublayer:_glLayer];
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
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma  delegate
- (void)updateVidView:(CVPixelBufferRef)pixelBuffer{
    _glLayer.pixelBuffer = pixelBuffer;
}

@end
