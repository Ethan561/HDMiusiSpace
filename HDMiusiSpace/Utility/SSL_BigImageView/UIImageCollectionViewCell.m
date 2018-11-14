//
//  UIImageCollectionViewCell.m
//  ImageReview
//
//  Created by SSLong on 2017/9/21.
//  Copyright ssl. All rights reserved.
//

#import "UIImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"

#define MAXZOOMSCALE 3
#define MINZOOMSCALE 1
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
@interface UIImageCollectionViewCell()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@end
@implementation UIImageCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.scrollView.minimumZoomScale = MINZOOMSCALE;
        self.scrollView.maximumZoomScale = MAXZOOMSCALE;
        self.scrollView.delegate = self;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self.scrollView addGestureRecognizer:tap];
        [self.contentView addSubview:self.scrollView];
        self.imageView = [[UIImageView alloc]initWithFrame:frame];
        self.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClickAction:)];
        doubleTap.numberOfTouchesRequired = 1;
        doubleTap.numberOfTapsRequired = 2;
        [self.imageView addGestureRecognizer:doubleTap];
        //优先触发双击手势
        [tap requireGestureRecognizerToFail:doubleTap];
        [self.scrollView addSubview:self.imageView];
    }
    return self;
}
- (void)tapAction
{
    [self.delegate ImageCellDidClick];
}
- (void)doubleClickAction:(UIGestureRecognizer *)gesture
{
    CGFloat k = MAXZOOMSCALE;
    UIScrollView *scrollView = (UIScrollView *)gesture.view.superview;
    CGFloat width = gesture.view.frame.size.width;
    CGFloat height = gesture.view.frame.size.height;
    CGPoint point = [gesture locationInView:gesture.view];
    //获取双击坐标，分4种情况计算scrollview的contentoffset
    if (point.x<=width/2 && point.y<=height/2) {
        point = CGPointMake(point.x*k, point.y*k);
        point = CGPointMake(point.x-SCREEN_WIDTH/2>0?point.x-SCREEN_WIDTH/2:0,point.y-SCREEN_HEIGHT/2>0?point.y-SCREEN_HEIGHT/2:0);
    }else if (point.x<=width/2 && point.y>height/2)
    {
        point = CGPointMake(point.x*k, (height-point.y)*k);
        point = CGPointMake(point.x-SCREEN_WIDTH/2>0?point.x-SCREEN_WIDTH/2:0,point.y>SCREEN_HEIGHT/2?height*k-point.y-SCREEN_HEIGHT/2:height*k>SCREEN_HEIGHT?height*k-SCREEN_HEIGHT:0);
    }else if (point.x>width/2 && point.y<=height/2)
    {
        point = CGPointMake((width-point.x)*k, point.y*k);
        point = CGPointMake(point.x>SCREEN_WIDTH/2?width*k-point.x-SCREEN_WIDTH/2:width*k>SCREEN_WIDTH?width*k-SCREEN_WIDTH:0, point.y-SCREEN_HEIGHT/2>0?point.y-SCREEN_HEIGHT/2:0);
    }else
    {
        point = CGPointMake((width-point.x)*k, (height-point.y)*k);
        point = CGPointMake(point.x>SCREEN_WIDTH/2?width*k-point.x-SCREEN_WIDTH/2:width*k>SCREEN_WIDTH?width*k-SCREEN_WIDTH:0, point.y>SCREEN_HEIGHT/2?height*k-point.y-SCREEN_HEIGHT/2:height*k>SCREEN_HEIGHT?height*k-SCREEN_HEIGHT:0);
    }
    
    
    if (scrollView.zoomScale == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            scrollView.zoomScale = k;
            scrollView.contentOffset = point;
        } completion:^(BOOL finished) {
            
        }];
    }else
    {
        [UIView animateWithDuration:0.3 animations:^{
            scrollView.zoomScale = 1;
        }];
    }
}
- (void)setImage:(NSString *)imageName
{
    //重置zoomscale为1
    self.scrollView.zoomScale = 1;

//    NSString *url = [NSString stringWithFormat:@"%@%@",[[[HDDeclare IP_Request_Header] componentsSeparatedByString:@"/api"] firstObject],imageName];
//    NSString *url = [HDDeclare realSizeImagePathWithRequestPath:imageName];
////    if ([imageName hasPrefix:@"http"]) {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"展品列表默认"]];
//    }else{
//        self.imageView.image = [UIImage imageWithContentsOfFile:imageName];
//    }
    
    CGFloat x = SCREEN_HEIGHT/SCREEN_WIDTH;
    CGFloat y = self.imageView.image.size.height/self.imageView.image.size.width;
    if (isnan(y)) {
        y = x;
    }
    //x为屏幕尺寸，y为图片尺寸，通过两个尺寸的比较，重置imageview的frame
    if (y>x) {
        self.imageView.frame = CGRectMake(0, 0, SCREEN_HEIGHT/y, SCREEN_HEIGHT);
    }else
    {
        self.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*y);
    }
    self.imageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    scrollView.subviews[0].center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                                scrollView.contentSize.height * 0.5 + offsetY);
}
@end
