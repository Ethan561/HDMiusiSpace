//
//  HDMapView.m
//  HDGansuKJG
//
//  Created by liuyi on 2018/10/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

#import "HDMapView.h"
#import "HDTiledView.h"
#import "HDAnnotationView.h"
#import "HDMapView+Download.h"
#import "HDMapView+AnnView.h"
#import "UIImageView+WebCache.h"
#import "HDRouteDrawingView.h"
#import "HDAnnotation.h"

#define kStandardUIScrollViewAnimationTime (int64_t)0.10
@interface HDMapView ()<HDTiledViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *twoFingerTapGestureRecognizer;
@property (nonatomic, assign) BOOL muteAnnotationUpdates; // 延迟执行，双击和单点手势作区分

@property (nonatomic, strong) HDTiledView      *tiledView;
//瓦片加载之前，先加载一个背景小图，防止瓦片在线加载时候的频繁闪屏问题
@property (nonatomic, strong) UIImageView      *bgImgView;
// 透明的路线层
@property (nonatomic, strong) UIView         *routeView;
// 推荐路线ImgView
//@property (nonatomic, strong) UIImageView    *routeImageView;

@end


@implementation HDMapView

#pragma mark --------- Init Methods --------

+ (Class)tiledLayerClass
{
    return [HDTiledView class];
}

- (instancetype)initWithFrame:(CGRect)frame contentSize:(CGSize)contentSize
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.autoresizingMask  = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.delegate          = self;
        self.backgroundColor   = [UIColor clearColor];
        self.contentSize       = contentSize;
        self.bouncesZoom       = YES;
        self.bounces           = NO;
        
        self.minimumZoomScale  = 1.0;
        self.levelsOfZoom      = 3;
        _zoomsInOnDoubleTap     = YES;
        _zoomsOutOnTwoFingerTap = YES;
        _centerSingleTap        = YES;
        _successiveAnn         = nil;
        
        [self subViewInit];
        [self gestureInit];
        
        _mapItemSet = [NSMutableSet new]; // 用于存放未下载的瓦片路径
    }
    return self;
}

- (void)subViewInit
{
    _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.contentSize.width, self.contentSize.height)];
    [self addSubview:_bgImgView];
    
    _tiledView = [[[[self class] tiledLayerClass] alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.contentSize.width, self.contentSize.height)];
    
    _tiledView.delegate = self;
    [self addSubview:_tiledView];
    
    _annBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
    [self addSubview:_annBgView];
    
    CGFloat xcenter = self.center.x , ycenter = self.center.y;
    UIScrollView *scrollView = self;
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    [_bgImgView setCenter:CGPointMake(xcenter, ycenter)];
    [_tiledView setCenter:CGPointMake(xcenter, ycenter)];
    [_annBgView setCenter:CGPointMake(xcenter, ycenter)];
    CGFloat offsetX = self.contentSize.width - scrollView.frame.size.width;
    self.contentOffset = CGPointMake(offsetX/2.0, 0);
    
}

- (void)gestureInit
{
    _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(singleTapReceived:)];
    _singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [_annBgView addGestureRecognizer:_singleTapGestureRecognizer];
    
    _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(doubleTapReceived:)];
    _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [_annBgView addGestureRecognizer:_doubleTapGestureRecognizer];
    
    [_singleTapGestureRecognizer requireGestureRecognizerToFail:_doubleTapGestureRecognizer];
    
    _twoFingerTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(twoFingerTapReceived:)];
    _twoFingerTapGestureRecognizer.numberOfTouchesRequired = 2;
    _twoFingerTapGestureRecognizer.numberOfTapsRequired = 1;
    [_annBgView addGestureRecognizer:_twoFingerTapGestureRecognizer];
}

- (void)initMinMapImageWithUrlPrefix:(NSString *)urlPrefix mapItemCachePath:(NSString *)mapItemCachePath {
    _urlPrefix = urlPrefix;
    _mapItemCachePath = mapItemCachePath;
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",_urlPrefix,@"img.png"];
    if ([imgUrl containsString:@"map"] || imgUrl.length > 10) {
        [_bgImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    }
    //
    [self downloadFirstLevel];
}

- (void)setLevelsOfZoom:(size_t)levelsOfZoom {
    _levelsOfZoom = levelsOfZoom;
    //powf 最大放大倍数为 2 的 levelsOfZoom 次幂
    self.maximumZoomScale = (CGFloat)powf(2.0f, MAX(0.0f, levelsOfZoom));
}

- (void)setLevelsOfDetail:(size_t)levelsOfDetail
{
    if (levelsOfDetail == 1) NSLog(@"Note: Setting levelsOfDetail to 1 causes strange behaviour");
    
    _levelsOfDetail = levelsOfDetail;
    [self.tiledView setNumberOfZoomLevels:levelsOfDetail];
}

#pragma mark --------- Route View --------

- (void)initRouteImage:(NSString *)imagePath
{
    if(self.routeView != nil) {
        [self routeImgClean];
        return;
    }
    UIImageView *routeImageView = [UIImageView new];
    routeImageView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    self.routeView = routeImageView;
    [self insertSubview:_routeView belowSubview:_annBgView];
    
    if ([imagePath containsString:@"http://"]) {
        [routeImageView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
    }else {
        UIImage *img = [UIImage imageNamed:imagePath];
        if (img == nil) {
            img = [UIImage imageWithContentsOfFile:imagePath];
        }
        routeImageView.image = img;
    }
    routeImageView.userInteractionEnabled = YES;
    
    //
    UIScrollView *scrollView = self;
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    [_routeView setCenter:CGPointMake(xcenter, ycenter)];
    
}

// 显示绘制的路线图
- (void)drawRouteImage:(NSArray *)routePointArr {
    if(self.routeView != nil) {
        [self routeImgClean];
        return;
    }
    HDRouteDrawingView *footprintView = [[HDRouteDrawingView alloc] initWithFrame:self.bounds];
    footprintView.pointArray = routePointArr;
    footprintView.mapZoomScale = self.zoomScale;
    [footprintView setNeedsDisplay];
    
    _routeView = footprintView;
    _routeView.backgroundColor = [UIColor clearColor];
    _routeView.userInteractionEnabled = YES;
    [self insertSubview:_routeView belowSubview:_annBgView];
    
    //
    UIScrollView *scrollView = self;
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    [_routeView setCenter:CGPointMake(xcenter, ycenter)];
    
}

- (void)isHideRouteView:(BOOL)isHide
{
    _routeView.hidden = isHide;
}

- (void)routeImgClean {
    [_routeView removeFromSuperview];
    self.routeView = nil;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *viewReturn = [super hitTest:point withEvent:event];
    //不在popView区域内，触碰穿透，并收回popView
    if ([viewReturn isKindOfClass:[self.routeView class]]) {
        return _tiledView;
    }
    //在popView区域内，执行popView的正常操作
    return viewReturn;
}

#pragma mark -------- UIScrolViewDelegate --------

- (UIView *)viewForZoomingInScrollView:(__unused UIScrollView *)scrollView
{
    return self.tiledView;
}

- (void)scrollViewDidZoom:(__unused UIScrollView *)scrollView
{
    //目前contentsize的width是否大于原scrollview的contentsize，如果大于，设置imageview中心x点为contentsize的一半，以固定imageview在该contentsize中心。如果不大于说明图像的宽还没有超出屏幕范围，可继续让中心x点为屏幕中点，此种情况确保图像在屏幕中心。
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    if ([self.mapViewdelegate respondsToSelector:@selector(mapViewDidZoom:)]) {
        [self.mapViewdelegate mapViewDidZoom:self];
    }
    
    _bgImgView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    _annBgView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    
    [_bgImgView setCenter:CGPointMake(xcenter, ycenter)];
    [_tiledView setCenter:CGPointMake(xcenter, ycenter)];
    [_annBgView setCenter:CGPointMake(xcenter, ycenter)];
    if (_routeView) {
        _routeView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        [_routeView setCenter:CGPointMake(xcenter, ycenter)];
    }
}

- (void)scrollViewDidScroll:(__unused UIScrollView *)scrollView
{
    if ([self.mapViewdelegate respondsToSelector:@selector(mapViewDidScroll:)]) {
        [self.mapViewdelegate mapViewDidScroll:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startDownloadItem];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self startDownloadItem];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self startDownloadItem];
}

#pragma mark -------- Gesture Suport --------

- (void)singleTapReceived:(UITapGestureRecognizer *)gestureRecognizer
{
    if (_centerSingleTap) {
        [self setContentCenter:[gestureRecognizer locationInView:_tiledView]
                      animated:YES];
    }
    
    if ([self.mapViewdelegate respondsToSelector:@selector(mapView:didReceiveSingleTap:)]) {
        [self.mapViewdelegate mapView:self
                  didReceiveSingleTap:gestureRecognizer];
    }
}

- (void)doubleTapReceived:(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.zoomScale >= self.maximumZoomScale) {
        [self setZoomScale:1.0f animated:YES];
        return;
    }
    
    if (_zoomsInOnDoubleTap) {
        CGFloat newZoom = MIN(powf(2, (log2f(self.zoomScale) + 1.0f)), self.maximumZoomScale); //zoom in one level of detail
        
        self.muteAnnotationUpdates = YES;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kStandardUIScrollViewAnimationTime * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self setMuteAnnotationUpdates:NO];
        });
        
        [self setZoomScale:newZoom animated:YES];
    }
    
    if ([self.mapViewdelegate respondsToSelector:@selector(mapView:didReceiveDoubleTap:)]) {
        [self.mapViewdelegate mapView:self
                  didReceiveDoubleTap:gestureRecognizer];
    }
}

- (void)twoFingerTapReceived:(UITapGestureRecognizer *)gestureRecognizer
{
    if (_zoomsOutOnTwoFingerTap) {
        CGFloat newZoom = MAX(powf(2, (log2f(self.zoomScale) - 1.0f)), self.minimumZoomScale); //zoom out one level of detail
        
        self.muteAnnotationUpdates = YES;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kStandardUIScrollViewAnimationTime * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self setMuteAnnotationUpdates:NO];
        });
        
        [self setZoomScale:newZoom animated:YES];
    }
    
    if ([self.mapViewdelegate respondsToSelector:@selector(mapView:didReceiveTwoFingerTap:)]) {
        [self.mapViewdelegate mapView:self
               didReceiveTwoFingerTap:gestureRecognizer];
    }
}


#pragma mark -------- Actions --------

- (void)showCallOut:(HDAnnotationView *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        HDAnnotationView *pin = sender;
        CGPoint pointToMove = CGPointMake(pin.annotation.point.x/self.minimumZoomScale, pin.annotation.point.y/self.minimumZoomScale);
        [self setContentCenter:pointToMove animated:YES];//显示到界面中心
        [self.annBgView bringSubviewToFront:pin];
        
        if ([self.mapViewdelegate respondsToSelector:@selector(mapView:tapAnnView:)]) {
            [self.mapViewdelegate mapView:self tapAnnView:pin];
        }
        
    });
}

// 刷新时机，需要在当前批次瓦片全部下载结束后刷新当前页面
- (void)reloadViewAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tiledView setNeedsDisplay];
        [self.tiledView setNeedsLayout];
    });
}

//移到中心位置
- (void)setContentCenter:(CGPoint)center animated:(BOOL)animated
{
    CGPoint new_contentOffset = self.contentOffset;
    if (self.contentSize.width > self.bounds.size.width) {
        new_contentOffset.x = MAX(0.0f, (center.x * self.zoomScale) - (self.bounds.size.width / 2.0f));
        new_contentOffset.x = MIN(new_contentOffset.x, (self.contentSize.width - self.bounds.size.width));
    }
    if (self.contentSize.height > self.bounds.size.height) {
        new_contentOffset.y = MAX(0.0f, (center.y * self.zoomScale) - (self.bounds.size.height / 2.0f));
        new_contentOffset.y = MIN(new_contentOffset.y, (self.contentSize.height - self.bounds.size.height));
    }
    [self setContentOffset:new_contentOffset animated:animated];
}

//放大
- (void)enlargeZoom{
    if (self.zoomScale >= self.maximumZoomScale) {
        //[self setZoomScale:self.minimumZoomScale animated:YES];//暂时取消放到最大缩小
        return;
    }
    CGFloat newZoom = MIN(powf(2, (log2f(self.zoomScale) + 1.0f)), self.maximumZoomScale); //zoom in one level of detail
    self.muteAnnotationUpdates = YES;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kStandardUIScrollViewAnimationTime * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setMuteAnnotationUpdates:NO];
    });
    [self setZoomScale:newZoom animated:YES];
}

//缩小
- (void)narrowZoom{
    CGFloat newZoom = MAX(powf(2, (log2f(self.zoomScale) - 1.0f)), self.minimumZoomScale); //zoom out one level of detail
    self.muteAnnotationUpdates = YES;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kStandardUIScrollViewAnimationTime * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setMuteAnnotationUpdates:NO];
    });
    [self setZoomScale:newZoom animated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging) {
        //        [self hideCallOut];
    }
    [super touchesEnded:touches withEvent:event];
}

#pragma mark ----- HDTiledViewDelegate -----

- (UIImage *)tiledView:(__unused HDTiledView *)tiledView
           imageForRow:(NSInteger)row
                column:(NSInteger)column
                 scale:(NSInteger)scale
{
    return [self.dataSource  mapView:self
                         imageForRow:row
                              column:column
                               scale:scale];
}



-(void)dealloc
{
    _tiledView.delegate = nil;
    
    if (_pinAnnotations) {
        for (HDAnnotationView *annotation in _pinAnnotations) {
            [self removeObserver:annotation forKeyPath:@"contentSize"];
        }
    }
    
    // 固定的推荐路线
    if (_routeView != nil) {
        [_routeView removeFromSuperview];
        self.routeView = nil;
    }
    
    // 防止瓦片闪动时候的小地图
    if (_bgImgView != nil) {
        [_bgImgView removeFromSuperview];
        self.bgImgView = nil;
    }
}

@end

