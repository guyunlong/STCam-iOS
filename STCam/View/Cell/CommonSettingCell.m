//
//  CommonSettingCell.m
//  STCam
//
//  Created by guyunlong on 10/14/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "CommonSettingCell.h"
#import "PrefixHeader.h"
@interface CommonSettingCell()

@property(nonatomic,weak)IBOutlet UILabel * titleLb;
@property(nonatomic,weak)IBOutlet UILabel * infoLb;
@end
@implementation CommonSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_model) {
        [_titleLb setText:_model.title];
        [_infoLb setText:_model.info];
    }
    
}
+ (instancetype)CommonSettingCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"CommonSettingCellIdentify";//对应xib中设置的identifier
    CommonSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonSettingCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}
+(CGFloat)cellHeight{
    return 54*kWidthCoefficient;
}
@end
