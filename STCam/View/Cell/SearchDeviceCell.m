//
//  SearchDeviceCell.m
//  STCam
//
//  Created by coverme on 2018/10/23.
//  Copyright © 2018 South. All rights reserved.
//

#import "SearchDeviceCell.h"
#import "PrefixHeader.h"
#define kShadowRadius 20
@interface SearchDeviceCell()
@property(nonatomic,weak)IBOutlet UIView * backView;
@property(nonatomic,weak)IBOutlet UILabel * titleLb;
@property(nonatomic,weak)IBOutlet UILabel * ipaddressLb;
@end
@implementation SearchDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIColor *clr = [UIColor colorWithHexString:@"0xaaaaaa"];
    _backView.layer.shadowColor = clr.CGColor;
    _backView.layer.cornerRadius = 5;
    _backView.layer.shadowOffset = CGSizeMake(0,0);
    _backView.layer.shadowOpacity = 1.0;
    _backView.layer.shadowRadius = kShadowRadius;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_model) {
        [_titleLb setText:_model.DevName];
        [_titleLb setText:_model.IPUID];
    }
}

+ (instancetype)SearchDeviceCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"SearchDeviceCellIdentify";//对应xib中设置的identifier
    SearchDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchDeviceCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
    
}
+(CGFloat)cellHeight{
    return 150.0*kWidthCoefficient;
}

@end
