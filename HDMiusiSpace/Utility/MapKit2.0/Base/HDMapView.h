//
//  HDMapView.h
//  HDGansuKJG
//
//  Created by liuyi on 2018/10/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]// 获取沙盒Cache路径
#define kSuccessive_Ann_ID    @"99999" // 连续定位点的ID

@class HDTiledView,HDMapView,HDAnnotationView,HDAnnotation;

@protocol HDMapViewDataSource <NSObject>

@required
// 绘制瓦片的代理方法
- (UIImage *)mapView:(HDMapView *)mapView
         imageForRow:(NSInteger)row
              column:(NSInteger)column
               scale:(NSInteger)scale;
@end

@protocol HDMapViewDelegate <NSObject>

- (void)mapView:(HDMapView *)mapView tapAnnView:(HDAnnotationView *)annView;

@optional
- (void)mapViewDidZoom:(HDMapView *)mapView;
- (void)mapViewDidScroll:(HDMapView *)mapView;
- (void)mapView:(HDMapView *)mapView didReceiveSingleTap:(UIGestureRecognizer *)gestureRecognizer;
- (void)mapView:(HDMapView *)mapView didReceiveDoubleTap:(UIGestureRecognizer *)gestureRecognizer;
- (void)mapView:(HDMapView *)mapView didReceiveTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer;


@end


@interface HDMapView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, weak) id<HDMapViewDataSource> dataSource;
@property (nonatomic, weak) id<HDMapViewDelegate> mapViewdelegate;

//单击位置移到屏幕中央，默认YES
@property (nonatomic, assign) BOOL           centerSingleTap;
//双击地图自动放大，默认YES
@property (nonatomic, assign) BOOL           zoomsInOnDoubleTap;
//双指捏合放大，默认YES
@property (nonatomic, assign) BOOL           zoomsOutOnTwoFingerTap;
//是否显示连续定位点，默认false
@property (nonatomic, assign) BOOL           isSuccessiveLocation;
//点击POI后是否显示callout，默认不显示 false
@property (nonatomic, assign) BOOL           isShowCallOutView;

//设置maximumZoomScale：为 2 的 levelsOfZoom 次幂
@property (nonatomic, assign) size_t         levelsOfZoom;
//设置tiledView levelsOfDetailBias
@property (nonatomic, assign) size_t         levelsOfDetail;

@property (nonatomic, strong) NSMutableArray *pinAnnotations;

// 在线加载，需要下载的瓦片地图名称（1_250_0_0.png）容器
@property (nonatomic, strong) NSMutableSet     *mapItemSet;

// 在线加载，下载URL前缀
@property (nonatomic, strong) NSString         *urlPrefix;

// 在线加载，瓦片的存储路径，不包括瓦片的名称
@property (nonatomic, strong) NSString         *mapItemCachePath;

//点位内容视图
@property (nonatomic, strong) UIView         *annBgView;

// 连续定位图标
@property (nonatomic, strong) HDAnnotationView *successiveAnn;


- (instancetype)initWithFrame:(CGRect)frame contentSize:(CGSize)contentSize;

//初始化下载路径和显示尺寸最小的整个瓦片的图作为背景
- (void)initMinMapImageWithUrlPrefix:(NSString *)urlPrefix mapItemCachePath:(NSString *)mapItemCachePath;

// 下载地图完成以后，强制刷新
- (void)reloadViewAction;

//放大地图
- (void)enlargeZoom;

//缩小地图
- (void)narrowZoom;

// 显示在线或者本地的路线出来,imagePath（图片名，网址，路径）
- (void)initRouteImage:(NSString *)imagePath;

// 显示绘制的路线图
- (void)drawRouteImage:(NSArray *)routePointArr;

// 显示或隐藏路线
- (void)isHideRouteView:(BOOL)isHide;

//移除路线视图
- (void)routeImgClean;

//移到中心位置
- (void)setContentCenter:(CGPoint)center animated:(BOOL)animated;

//点击POI事件
- (void)showCallOut:(HDAnnotationView *)sender;



@end


