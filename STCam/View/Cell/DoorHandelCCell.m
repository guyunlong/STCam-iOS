//
//  DoorHandelCCell.m
//  STCam
//
//  Created by guyunlong on 2019/1/3.
//  Copyright © 2019年 South. All rights reserved.
//

#import "DoorHandelCCell.h"
#import "PrefixHeader.h"
@interface DoorHandelCCell()
@property (nonatomic, strong) UIButton* doorConrolBtn;
@end
@implementation DoorHandelCCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _doorConrolBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,doorHandleBtnWidth,doorHandleBtnHeight)];
        [_doorConrolBtn setAppThemeType:ButtonStyleDoorTheme];
        [_doorConrolBtn addTarget:self action:@selector(doorConrolBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_doorConrolBtn];
    }
    return self;
}
- (void)setTitle:(NSString *)title{
    if (title != nil && title != _title) {
        _title  = title;
    }
    [self setNeedsLayout];
}
-(void)doorConrolBtnClick{
    if (_btnClickBlock) {
        _btnClickBlock(_channel);
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (_title) {
        [_doorConrolBtn setTitle:_title forState:UIControlStateNormal];
        
    }
    if ([_title length] == 0) {
        [_doorConrolBtn setHidden:YES];
    }
    else{
        [_doorConrolBtn setHidden:NO];
    }
}
+(CGSize)ccellSize{
    CGSize  size =CGSizeMake(doorHandleBtnWidth, doorHandleBtnHeight);
    return size;
}
@end
