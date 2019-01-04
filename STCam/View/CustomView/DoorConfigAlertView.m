//
//  DoorConfigAlertView.m
//  STCam
//
//  Created by guyunlong on 2019/1/3.
//  Copyright © 2019年 South. All rights reserved.
//

#import "DoorConfigAlertView.h"
#import "PrefixHeader.h"
#import "DoorConfigCell.h"
#import "TPKeyboardAvoidingTableView.h"
#define titleFont [UIFont boldSystemFontOfSize:20]
#define contentFont [UIFont boldSystemFontOfSize:14]
#define titleHeight 22
#define txColor [UIColor colorWithHexString:@"0x222222"]
@interface DoorConfigAlertView()<UITableViewDataSource, UITableViewDelegate>{
    float viewWidth;
}
@property(strong, nonatomic) UILabel *titleLb;
@property(nonatomic,strong)UIButton* okBtn;
@property(nonatomic,strong)UIButton* cancelBtn;
@property(nonatomic,strong)UITableView * mTableView;
@end
@implementation DoorConfigAlertView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = true;
        
        [self initView];
    }
    return self;
}
-(void)initView{
    float y = 2*kPadding;
    float viewWidth;
    
    viewWidth = (kScreenWidth - 4*kPadding);
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-25-kPadding, kPadding, 25, 25)];
    [_cancelBtn setImage:[UIImage imageNamed:@"close01"] forState:UIControlStateNormal];
    [self addSubview:_cancelBtn];
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, y, viewWidth, titleHeight)];
        
        [_titleLb setText:@"action_setting".localizedString];
        [_titleLb setFont:titleFont];
        [_titleLb setTextColor:txColor];
        [_titleLb setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLb];
    }
    
    [_titleLb setHeight:titleHeight];
    [self addSubview:_titleLb];
    y += titleHeight+kPadding;
    if (!_mTableView) {
        _mTableView = ({
            TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView setUserInteractionEnabled:true];
            [tableView registerClass:[DoorConfigCell class] forCellReuseIdentifier:DoorConfigCellIdentify];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView;
        });
    }
    [self addSubview:_mTableView];
    [_mTableView setFrame:CGRectMake(0, y, viewWidth, DoorConfigCellHeight*9)];

     y+= DoorConfigCellHeight*9+kPadding;
    
    _okBtn = [[UIButton alloc] initWithFrame:CGRectMake(kPadding*2, y, viewWidth-4*kPadding, kButtonHeight)];
    [_okBtn setAppThemeType:ButtonStyleStyleAppTheme];
    [_okBtn setTitle:NSLocalizedString(@"Ok",nil) forState:UIControlStateNormal];
    [self addSubview:_okBtn];
    [_cancelBtn addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_okBtn addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClickEvent:(id)sender{
    if (sender == _okBtn) {
        if (_btnClickBlock) {
            _btnClickBlock(0);
        }
    }
    else if(sender == _cancelBtn){
        if (_btnClickBlock) {
            _btnClickBlock(1);
        }
    }
}
#pragma mark - tableView



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoorConfigCell * cell = [tableView dequeueReusableCellWithIdentifier:DoorConfigCellIdentify forIndexPath:indexPath];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DoorConfigCell cellHeight];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
+ (CGSize)viewSize{
    float viewWidth = (kScreenWidth - 4*kPadding);
    float width = viewWidth;
    float y = 2*kPadding;
    y += titleHeight+kPadding;
    y += [DoorConfigCell cellHeight]*9;
    y += kPadding;
    y += kButtonHeight;
    y += kPadding;
    return CGSizeMake(width, y);
}



@end

