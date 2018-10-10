//
//  DevMediaCell.m
//  STCam
//
//  Created by guyunlong on 10/10/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "DevMediaCell.h"

#import "PrefixHeader.h"
#import <Masonry/Masonry.h>
#import "MASConstraint.h"
#import "STFileManager.h"
#define kShadowRadius 20
@interface DevMediaCell()
@property(nonatomic,weak)IBOutlet UIImageView * snapImageView;
@property(nonatomic,weak)IBOutlet UILabel * titleLb;
@end
@implementation DevMediaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Initialization code
    [_snapImageView setImage:[UIImage imageNamed:@"imagethumb"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_model) {
        [_titleLb setText:_model.DevName];
        
        
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
+ (instancetype)DevMediaCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"DevMediaCellIdentify";//对应xib中设置的identifier
    DevMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DevMediaCell" owner:self options:nil] objectAtIndex:0];
    }
    return cell;
    
}
+(CGFloat)cellHeight{
    return 100.0;
}   // Configure the view for the selected state

@end
