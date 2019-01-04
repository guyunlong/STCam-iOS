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
-(void)setTitle:(NSString *)title{
    if (title && _title != title) {
        _title = title;
    }
    [self setNeedsLayout];
}
- (void)setModel:(DoorCfgModel *)model{
    if (model && model != _model) {
        _model  = model;
    }
    [self setNeedsLayout];
}
-(void)doorConrolBtnClick{
   // @property(copy,nonatomic)void (^btnClickBlock)(NSInteger channel);
    if (_channel != 9 && _model) {
        _selectedChannel = _channel;
        [self.doorConrolBtn setSelected:YES];
    }
    
    if (_btnClickBlock) {
        _btnClickBlock(_channel);
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [_doorConrolBtn setEnabled:YES];
    
    if (_model) {
        [_doorConrolBtn setTitle:_model.Name forState:UIControlStateNormal];
        [_doorConrolBtn setEnabled:_model.Active];
        [_doorConrolBtn setSelected:_model.Status];
        if (_selectedChannel == _channel) {
             [self.doorConrolBtn setSelected:YES];
        }
        else{
             [self.doorConrolBtn setSelected:NO];
        }
    }
//    else if(_title){
//        [_doorConrolBtn setEnabled:YES];
//        [_doorConrolBtn setTitle:_title forState:UIControlStateNormal];
//    }
}
+(CGSize)ccellSize{
    CGSize  size =CGSizeMake(doorBtnWidth, doorBtnHeight);
    return size;
}
@end
