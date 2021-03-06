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
#import "UIImageView+WebCache.h"
@interface AlarmListCell()

@property(nonatomic,weak)IBOutlet UILabel * deviceTitleLb;
@property(nonatomic,weak)IBOutlet UILabel * alarmTimeLb;
@end
@implementation AlarmListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _alarmImageView.contentMode = UIViewContentModeScaleToFill;
 
    
}

-(void)setModel:(AlarmImageModel *)model{
    if (model && model != _model) {
        _model = model;
        [self setNeedsLayout];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_model) {
//        NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
//        NSString *languageName = [appLanguages objectAtIndex:0];
//       // zh-Hans-CN
//        if ([languageName isEqualToString:@"zh-Hans-CN"]) {
//            <#statements#>
//        }
//        else{
//            
//        }
        
        [_alarmImageView sd_setImageWithURL:[NSURL URLWithString:_model.Img] placeholderImage:[UIImage imageNamed:@"imagethumb"]];
        [_deviceTitleLb setText:_model.DevName];
        [_alarmTimeLb setText:_model.AlmTime];
        
    }
}
+ (instancetype)AlarmListCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"AlarmListCellIdentify";//对应xib中设置的identifier
    AlarmListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AlarmListCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}
+(CGFloat)cellHeight{
    return 100.0;
}   // Configure the view for the selected state

@end
