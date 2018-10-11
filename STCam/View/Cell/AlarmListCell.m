//
//  AlarmListCell.m
//  STCam
//
//  Created by guyunlong on 10/11/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "AlarmListCell.h"
#import "PrefixHeader.h"
#import <Masonry/Masonry.h>
#import "MASConstraint.h"
@interface AlarmListCell()
@property(nonatomic,weak)IBOutlet UIImageView * alarmImageView;
@property(nonatomic,weak)IBOutlet UILabel * deviceTitleLb;
@property(nonatomic,weak)IBOutlet UILabel * alarmTimeLb;
@end
@implementation AlarmListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_deviceTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@300);
        make.height.equalTo(@24);
        
       
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}
+ (instancetype)AlarmListCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"AlarmListCellIdentify";//对应xib中设置的identifier
    AlarmListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AlarmListCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
    
}
@end
