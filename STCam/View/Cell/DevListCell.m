//
//  DevListCell.m
//  STCam
//
//  Created by guyunlong on 10/5/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "DevListCell.h"
#import "PrefixHeader.h"
#import <Masonry/Masonry.h>
#import "MASConstraint.h"
#import "STFileManager.h"
#define kShadowRadius 20
@interface DevListCell()
@property(nonatomic,weak)IBOutlet UIView * backView;
@property(nonatomic,weak)IBOutlet UIImageView * snapImageView;
@property(nonatomic,weak)IBOutlet UILabel * titleLb;
@property(nonatomic,weak)IBOutlet UIButton * shareBtn;
@property(nonatomic,weak)IBOutlet UIButton * playBackBtn;
@property(nonatomic,weak)IBOutlet UIButton * settingBtn;
@property(nonatomic,strong) UIView * onlineStatusImageView;
@property(nonatomic,strong) UILabel * onlineStatusLb;
@end
@implementation DevListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Initialization code
    [_snapImageView setImage:[UIImage imageNamed:@"imagethumb"]];
    
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@24);
        make.height.equalTo(@24);
        make.bottom.mas_equalTo(self.backView.mas_bottom).with.offset(-5);
        make.right.mas_equalTo(self.backView.mas_right).with.offset(-5);
    }];
    
    [_playBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@24);
        make.height.equalTo(@24);
        make.bottom.mas_equalTo(self.backView.mas_bottom).with.offset(-5);
        make.right.mas_equalTo(self.settingBtn.mas_left).with.offset(-20);
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@24);
        make.height.equalTo(@24);
        make.bottom.mas_equalTo(self.backView.mas_bottom).with.offset(-5);
        make.right.mas_equalTo(self.playBackBtn.mas_left).with.offset(-20);
    }];
    
    [_backView setBackgroundColor:[UIColor whiteColor]];
    UIColor *clr = [UIColor colorWithHexString:@"0xaaaaaa"];
  
    _backView.layer.shadowColor = clr.CGColor;
    _backView.layer.cornerRadius = 5;
    _backView.layer.shadowOffset = CGSizeMake(0,0);
    _backView.layer.shadowOpacity = 1.0;
    _backView.layer.shadowRadius = kShadowRadius;
    
    
    _onlineStatusImageView =[[UIView alloc] init];
    _onlineStatusLb =[[UILabel alloc] init];
    [_snapImageView addSubview:_onlineStatusImageView];
    [_snapImageView addSubview:_onlineStatusLb];
    [_onlineStatusLb setFont:[UIFont systemFontOfSize:13]];
    [_onlineStatusLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@55);
        make.height.equalTo(@16);
        make.top.mas_equalTo(self.snapImageView.mas_top).with.offset(20);
        make.right.mas_equalTo(self.snapImageView.mas_right).with.offset(-5);
    }];
    
    [_onlineStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@16);
        make.height.equalTo(@16);
        make.top.mas_equalTo(self.snapImageView.mas_top).with.offset(20);
        make.right.mas_equalTo(self.onlineStatusLb.mas_left).with.offset(-10);
    }];
    _onlineStatusImageView.layer.cornerRadius = 8;
    _onlineStatusImageView.layer.masksToBounds = YES;
    
    [_settingBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_shareBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_playBackBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)btnClicked:(id)sender{
    if (_btnClickBlock) {
        if (sender == _settingBtn) {
            _btnClickBlock(DeviceListBtnType_Setting);
        }
        else if (sender == _shareBtn) {
            _btnClickBlock(DeviceListBtnType_Share);
        }
        else if (sender == _playBackBtn) {
            _btnClickBlock(DeviceListBtnType_Playback);
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_model) {
        [_titleLb setText:_model.DevName];
        [_onlineStatusImageView setBackgroundColor:[_model getConnectColor]];
        [_onlineStatusLb setTextColor:[_model getConnectColor]];
        [_onlineStatusLb setText:[_model getOnLineDesc]];
        
        STFileManager * manager = [STFileManager sharedManager];
        if (![manager fileExistsForUrl:@"Thumbnail"]) {
            [manager createDirectoryNamed:@"Thumbnail"];
        }
        NSString * fileName = [manager localPathForFile:[NSString stringWithFormat:@"%@.png",self.model.SN] inDirectory:@"Thumbnail"];
        UIImage * image  =[UIImage imageWithContentsOfFile:fileName];
        if (image) {
            [_snapImageView setImage:image];
            _snapImageView.contentMode = UIViewContentModeScaleToFill;
        }
        else{
            [_snapImageView setImage:[UIImage imageNamed:@"imagethumb"]];
        }
        
        
    }
    
  //  _backView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(kShadowRadius, _backView.bounds.size.height/2, _backView.bounds.size.width-(2*kShadowRadius), _backView.bounds.size.height/2)].CGPath;
    
 
}
+ (instancetype)DevListCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"DevListCellIdentify";//对应xib中设置的identifier
    DevListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DevListCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
    
}
+(CGFloat)cellHeight{
    return 200.0;
}
@end
