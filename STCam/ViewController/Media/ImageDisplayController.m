//
//  ImageDisplayController.m
//  STCam
//
//  Created by guyunlong on 10/10/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "ImageDisplayController.h"
#import "PrefixHeader.h"
@interface ImageDisplayController ()
@property (nonatomic,strong)UIImageView * imageView;
@end

@implementation ImageDisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
   
    UIImage * image  =[UIImage imageWithContentsOfFile:_model.fileName];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,(kScreenHeight-kSafeAreaHeaderHeight-64)/2-kScreenWidth*height/width/2 , kScreenWidth, kScreenWidth*height/width)];
    
    [_imageView setImage:image];
    [self.view addSubview:_imageView];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    
   
    
    
}

-(void)initNav{
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


@end
