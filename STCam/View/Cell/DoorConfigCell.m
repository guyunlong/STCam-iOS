//
//  DoorConfigCell.m
//  STCam
//
//  Created by guyunlong on 2019/1/3.
//  Copyright © 2019年 South. All rights reserved.
//

#import "DoorConfigCell.h"
#import "BEMCheckBox.h"
#import "PrefixHeader.h"
#define checkBoxHeight 20
#define fieldHeight 35
@interface DoorConfigCell()<BEMCheckBoxDelegate>
@property(nonatomic,strong)BEMCheckBox  * checkBox;
@property(nonatomic,strong)UILabel  * checklb;
@property(nonatomic,strong)UITextField  * nameField;
@end
@implementation DoorConfigCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _checkBox =[[BEMCheckBox alloc] initWithFrame:CGRectMake(kPadding*2, DoorConfigCellHeight/2-checkBoxHeight/2, checkBoxHeight, checkBoxHeight)];
        [_checkBox setDelegate:self];
        [self.contentView addSubview:_checkBox];
        
        _checklb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_checkBox.frame)+kPadding,DoorConfigCellHeight/2-checkBoxHeight/2, 60, checkBoxHeight)];
        [_checklb setText:@"txtActive".localizedString];
        [self.contentView addSubview:_checklb];
        
        _nameField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_checklb.frame), DoorConfigCellHeight/2-fieldHeight/2, kScreenWidth-4*kPadding-2*kPadding-CGRectGetMaxX(_checklb.frame), fieldHeight)];
        _nameField.layer.cornerRadius = 3;
        _nameField.layer.masksToBounds = YES;
        _nameField.layer.borderWidth = 0.5;
        _nameField.layer.borderColor =[UIColor colorWithHexString:@"0x333333"].CGColor;
         [self.contentView addSubview:_nameField];
        
    }
    return self;
}
+(CGFloat)cellHeight{
    return DoorConfigCellHeight;
}
@end
