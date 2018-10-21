//
//  CommonSwitchCell.m
//  STCam
//
//  Created by guyunlong on 10/21/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "CommonSwitchCell.h"
#import "PrefixHeader.h"
@interface CommonSwitchCell()
@property(nonatomic,weak)IBOutlet UILabel * titleLb;
@property(nonatomic,weak)IBOutlet UISwitch * swichW;
@end
@implementation CommonSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_swichW addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_model) {
        [_titleLb setText:_model.title];
        [_swichW setOn:_open];
    }
    
}
-(void)switchAction:(id)sender{
    BOOL isButtonOn = [_swichW isOn];
    if (_switchValueChangeBlock) {
        _switchValueChangeBlock(isButtonOn);
    }
  
}
+ (instancetype)CommonSwitchCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"CommonInfoCellIdentify";//对应xib中设置的identifier
    CommonSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonSwitchCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}
+(CGFloat)cellHeight{
    return 54*kWidthCoefficient;
}
@end
