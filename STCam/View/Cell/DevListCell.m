//
//  DevListCell.m
//  STCam
//
//  Created by guyunlong on 10/5/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "DevListCell.h"
@interface DevListCell()
@property(nonatomic,weak)IBOutlet UIView * backView;
@property(nonatomic,weak)IBOutlet UIImageView * snapImageView;
@property(nonatomic,weak)IBOutlet UILabel * titleLb;
@property(nonatomic,weak)IBOutlet UIButton * shareBtn;
@property(nonatomic,weak)IBOutlet UIButton * playBackBtn;
@property(nonatomic,weak)IBOutlet UIButton * settingBtn;
@end
@implementation DevListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)DevListCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"DevListCellIdentify";//对应xib中设置的identifier
    DevListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DevListCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
    
}

@end
