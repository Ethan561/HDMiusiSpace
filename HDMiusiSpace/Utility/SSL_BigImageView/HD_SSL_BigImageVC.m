//
//  HD_SSL_BigImageVC.m
//  HDHuNanMuseum
//
//  Created by SSLong on 2017/9/21.
//  Copyright © 2017年 liuyi. All rights reserved.
//

#import "HD_SSL_BigImageVC.h"
#import "UIImageCollectionViewCell.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define Device_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO) //判断是不是iPhoneX

@interface HD_SSL_BigImageVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ImageCellClickDelegate>
{
    UIButton *_closeBtn;
    UILabel  *_indexLabel;//显示位置
}
@property (nonatomic, strong) UICollectionView *collectionContentView;

@end

@implementation HD_SSL_BigImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    [self loadMyViews];
}
- (void)loadMyViews{
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationFade)];
    
    [self buildCollectionView];
    
    _closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _closeBtn.frame = CGRectMake(0, 0, 44, 44);
    _closeBtn.center = CGPointMake(ScreenWidth/2.0, ScreenHeight*0.85);
    [_closeBtn setImage:[UIImage imageNamed:@"bigImg_nav_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeViewAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_closeBtn];
    
    //
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.frame = CGRectMake((SCREEN_WIDTH-90)/2.0, kStatusBarHeight, 90, 44);
    if (Device_Is_iPhoneX) {
        _indexLabel.frame = CGRectMake((SCREEN_WIDTH-90)/2.0, 44, 90, 44);
    }
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",_atIndex+1,_imageArray.count];
    [self.view addSubview:_indexLabel];
    
}
- (void)closeViewAction
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)buildCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionContentView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    self.collectionContentView.delegate = self;
    self.collectionContentView.dataSource = self;
    [self.collectionContentView registerClass:[UIImageCollectionViewCell class] forCellWithReuseIdentifier:@"imagecell"];
    self.collectionContentView.pagingEnabled = YES;
    [self.view addSubview:self.collectionContentView];
    _collectionContentView.contentOffset = CGPointMake(ScreenWidth*_atIndex, 0);
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = _imageArray[indexPath.row];
    
    UIImageCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"imagecell" forIndexPath:indexPath];
    cell.delegate = self;
    if ([obj isKindOfClass:[UIImage class]]) {
        [cell setImageWithImage:(UIImage*)obj];
    }else{
        [cell setImage:_imageArray[indexPath.row]];
    }
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.imageArray.count;
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld",page+1,_imageArray.count];
}
- (void)ImageCellDidClick
{
//    _closeBtn.hidden = !_closeBtn.hidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
