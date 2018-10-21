//
//  RecordListCell.m
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "RecordListCell.h"
#import "PrefixHeader.h"
#import "CoreDataManager.h"
@interface RecordListCell()

@property(nonatomic,weak)IBOutlet UILabel * titleLb;
@property(nonatomic,weak)IBOutlet UILabel * infoLb;
@end
@implementation RecordListCell
-(void)setModel:(SDVideoModel *)model{
    if (_model != model && model) {
        _model = model;
        [self setNeedsLayout];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_model) {
        [_titleLb setText:_model.getSdVideoName];
        [_titleLb sizeToFit];
        [_infoLb setText:_model.getFileSizeDes];
        
        if ([[CoreDataManager sharedManager] isVideoExist:_model]) {
            [_titleLb setTextColor:[UIColor blueColor]];
            [_infoLb setTextColor:[UIColor blueColor]];
        }
        else{
            [_titleLb setTextColor:[UIColor blackColor]];
            [_infoLb setTextColor:[UIColor blackColor]];
        }
    }
}
+ (instancetype)RecordListCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"RecordListCellIdentify";//对应xib中设置的identifier
    RecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordListCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
}


+(CGFloat)cellHeight{
    return 50*kWidthCoefficient;
}
@end
