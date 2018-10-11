//
//  MediaDetailCCell.m
//  STCam
//
//  Created by guyunlong on 10/10/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "MediaDetailCCell.h"
#import "PrefixHeader.h"
#import "BEMCheckBox.h"
#define checkboxwidth 16
#define ccellWidth (kScreenWidth-4*3)/3
@interface MediaDetailCCell()<BEMCheckBoxDelegate>

@property (nonatomic, strong) BEMCheckBox* checkBox;
@end

@implementation MediaDetailCCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        if (!_imageView) {
            _imageView = [UIImageView new];
            [self.contentView addSubview:_imageView];
        }
        
        if (_imageView) {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }
        
        if (!_checkBox) {
            _checkBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(ccellWidth-kPadding-checkboxwidth,kPadding, checkboxwidth, checkboxwidth)];
            [_checkBox setDelegate:self];
            [_checkBox setOnTintColor:kMainColor];
            [_checkBox setOnCheckColor:kMainColor];
            _checkBox.onAnimationType = BEMAnimationTypeBounce;
            _checkBox.offAnimationType = BEMAnimationTypeBounce;
            _checkBox.boxType = BEMBoxTypeSquare;
            [self.contentView addSubview:_checkBox];
        }
    }
    return self;
}
- (void)setModel:(STMediaModel *)model{
    if (model != nil && model != _model) {
        _model  = model;
    }
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (_model) {
        
        UIImage * image  =[UIImage imageWithContentsOfFile:_model.fileName];
        if (image) {
            [_imageView setImage:image];
            _imageView.contentMode = UIViewContentModeScaleToFill;
        }
        else{
            [_imageView setImage:[UIImage imageNamed:@"imagethumb"]];
        }
        [_checkBox setOn:_model.check];
    }
}
#pragma checkbox
- (void)didTapCheckBox:(BEMCheckBox*)checkBox{
    BOOL value = checkBox.on;
    _model.check = value;
    if (_checkBlock) {
        _checkBlock();
    }
    
}
+(CGSize)ccellSize{
    CGSize  size =CGSizeMake(ccellWidth, ccellWidth*3/5);
    return size;
}


@end
