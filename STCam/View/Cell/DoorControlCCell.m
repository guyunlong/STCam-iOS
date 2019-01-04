//
//  DoorControlCCell.m
//  STCam
//
//  Created by guyunlong on 2019/1/3.
//  Copyright © 2019年 South. All rights reserved.
//

#import "DoorControlCCell.h"
#import "PrefixHeader.h"
@interface DoorControlCCell()
@property (nonatomic, strong) UIButton* doorConrolBtn;
@end
@implementation DoorControlCCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _doorConrolBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,doorBtnWidth,doorBtnHeight)];
        [_doorConrolBtn setAppThemeType:ButtonStyleDoorTheme];
        [_doorConrolBtn addTarget:self action:@selector(doorConrolBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_doorConrolBtn];
    }
    return self;
}
- (void)setTitle:(NSString *)title{
    if (title && title != _title) {
        _title  = title;
    }
    [self setNeedsLayout];
}
-(void)doorConrolBtnClick{
   // @property(copy,nonatomic)void (^btnClickBlock)(NSInteger channel);
    if (_btnClickBlock) {
        _btnClickBlock(0);
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (_title) {
        [_doorConrolBtn setTitle:_title forState:UIControlStateNormal];
    }
}
+(CGSize)ccellSize{
    CGSize  size =CGSizeMake(doorBtnWidth, doorBtnHeight);
    return size;
}
@end
