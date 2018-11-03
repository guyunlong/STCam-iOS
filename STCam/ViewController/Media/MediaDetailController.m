//
//  MediaDetailController.m
//  STCam
//
//  Created by guyunlong on 10/10/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "MediaDetailController.h"
#import "MediaDetailCCell.h"
#import "STFileManager.h"
#import "STMediaModel.h"
#import "PrefixHeader.h"
#import "ImageDisplayController.h"
#import "YBImageBrowser.h"

@interface MediaDetailController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,YBImageBrowserDataSource>
@property (strong, nonatomic) UICollectionView *mCollectView;//
@property (strong, nonatomic) NSMutableArray *mediaArray;//
@property (strong, nonatomic) UIButton *deleteBtn;//
@property (strong, nonatomic) UIButton *checkBtn;//
@end

@implementation MediaDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initValues];
    [_mCollectView reloadData];
    
}
-(void)loadView{
    [super loadView];
    if (!_mCollectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _mCollectView= [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        
        [_mCollectView setUserInteractionEnabled:true];
        [_mCollectView setBackgroundColor:[UIColor whiteColor]];
        [_mCollectView registerClass:[MediaDetailCCell class] forCellWithReuseIdentifier:MediaDetailCCellIdentify];
        _mCollectView.dataSource = self;
        _mCollectView.delegate = self;
       
        
        [self.view addSubview:_mCollectView];
       
    }
    if (_mCollectView) {
        [_mCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.top.mas_equalTo(self.view.mas_top);
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
    }
}

-(void)initNav{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 28, 28);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 38)];
    [_deleteBtn setTitle:@"action_clear".localizedString forState:UIControlStateNormal];
    
    [_deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightNavDeleteBtnBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_deleteBtn];
    
    _checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 38)];
    [_checkBtn setTitle:@"action_select_all".localizedString forState:UIControlStateNormal];
    [_checkBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightNavCheckBtnBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_checkBtn];
    self.navigationItem.rightBarButtonItems = @[rightNavCheckBtnBtnItem,rightNavDeleteBtnBtnItem];
    
    [_checkBtn addTarget:self action:@selector(navBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn addTarget:self action:@selector(navBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL)isAnyMediaChecked{
    for (STMediaModel  * model in _mediaArray) {
        if (model.check) {
            return YES;
        }
    }
    return NO;
}


-(void)initValues{
    STFileManager * manager = [STFileManager sharedManager];
    _mediaArray = [[NSMutableArray alloc] init];
    NSString * snSnapshot = [NSString stringWithFormat:@"snapshot/%@",_model.SN];
    NSArray * fileArray =[manager getFilesInDirectory:snSnapshot];
    for (NSString * file in fileArray) {
        STMediaModel * model  = [STMediaModel new];
        [model setFileName:file];
        [_mediaArray addObject:model];
    }
    
    NSString * snRecord = [NSString stringWithFormat:@"record/%@",_model.SN];
    NSArray * recordfileArray =[manager getFilesInDirectory:snRecord];
    for (NSString * file in recordfileArray) {
        STMediaModel * model  = [STMediaModel new];
        [model setFileName:file];
        [_mediaArray addObject:model];
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateCheckBtnTitle{
        if ([self isAnyMediaChecked]) {
            [_checkBtn setTitle:@"action_undelete_all".localizedString forState:UIControlStateNormal];
        }
        else{
            [_checkBtn setTitle:@"action_select_all".localizedString forState:UIControlStateNormal];
        }
   
}

#pragma clickevent
-(void)navBtnClicked:(id)sender{
    STFileManager * manager = [STFileManager sharedManager];
    if ([sender isEqual:_deleteBtn]) {
        NSInteger count =[_mediaArray count];
        for (NSInteger i = count-1; i >= 0; --i) {
            STMediaModel * model =_mediaArray[i];
            if (model.check) {
                //删除文件
                if ([manager deleteFileWithName:model.fileName]) {
                    [_mediaArray removeObject:model];
                }
                
            }
        }
        
        [self updateCheckBtnTitle];
        [self.mCollectView reloadData];
    }
    else if([sender isEqual:_checkBtn]){
        if ([self isAnyMediaChecked]) {
            //取消全选
            for (STMediaModel * model in _mediaArray) {
                model.check = NO;
            }
        }
        else{
            //全选
            for (STMediaModel * model in _mediaArray) {
                model.check = YES;
            }
        }
        [self.mCollectView reloadData];
    }
}

#pragma ccell

- (id)sourceObjAtIdx:(NSInteger)idx {
    MediaDetailCCell *cell = (MediaDetailCCell *)[self.mCollectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    return cell ? cell.imageView : nil;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_mediaArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    MediaDetailCCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:MediaDetailCCellIdentify forIndexPath:indexPath];
    [ccell setModel:_mediaArray[row]];
    @weakify(self)
    ccell.checkBlock = ^(){
        @strongify(self)
        [self updateCheckBtnTitle];
    };
    return ccell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [MediaDetailCCell ccellSize];
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insetForSection ;
    insetForSection = UIEdgeInsetsMake(0, 0, 0, 0);
    return insetForSection;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
//    ImageDisplayController * ctl = [[ImageDisplayController alloc] init];
//    [ctl setModel:_mediaArray[row]];
//    [self.navigationController pushViewController:ctl animated:YES];
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSource = self;
    browser.currentIndex = row;
    [browser show];
    
}
// 实现 <YBImageBrowserDataSource> 协议方法配置数据源
- (NSUInteger)yb_numberOfCellForImageBrowserView:(YBImageBrowserView *)imageBrowserView {
    return [_mediaArray count];
}
- (id<YBImageBrowserCellDataProtocol>)yb_imageBrowserView:(YBImageBrowserView *)imageBrowserView dataForCellAtIndex:(NSUInteger)index {
    STMediaModel * model = _mediaArray[index];
    if ([model getMediaType] == MediaType_IMG) {
        YBImageBrowseCellData *data = [YBImageBrowseCellData new];
        data.url = [NSURL fileURLWithPath:model.fileName];
        data.sourceObject = [self sourceObjAtIdx:index];
        return data;
    }
    else if([model getMediaType] == MediaType_VID){
        YBVideoBrowseCellData *data = [YBVideoBrowseCellData new];
        data.url = [NSURL fileURLWithPath:model.fileName];
        data.sourceObject = [self sourceObjAtIdx:index];
        return data;
    }
    return nil;
    
}

@end
