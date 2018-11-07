//
//  HDMapView+AnnView.h
//  HDGansuKJG
//
//  Created by liuyi on 2018/10/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

#import "HDMapView.h"

@interface HDMapView (AnnView)

- (void)addAnnotation:(HDAnnotation *)annotation animated:(BOOL)animate; // 地图上添加单个POI
- (void)addAnnotations:(NSArray *)annotations animated:(BOOL)animate;    // 地图上添加一组POI
- (void)removeAllAnnatations:(BOOL)animate;


- (void)jumpAnimationAnnotationView:(NSString *)identifier;
- (void)stopPinAnimate;


// 地图中心移动到当前播放点的，或者当前位置
- (void)moveToCenter:(NSString *)identifier;

- (void)changePOIImg:(NSString *)identifier
            withPath:(NSString *)imagePath;        // 更换POI图片，收号变红，或者已读未读的状态改变
- (void)changeBigPOIImg:(NSString *)identifier
               withPath:(NSString *)imagePath WithTitle:(NSString *)title;         // 更换标题


- (void)bigAnnotationView:(NSString *)identifier;
// 通过蓝牙号放大图片,针对一对多导致的多个点位放大情况
- (void)bigAnnByBeaconNum:(NSNumber *)beaconMinor;
- (void)smallAllAnnView;

#pragma mark ---- 连续定位 -----
- (void)updateKeepLocationPinPositionWith:(CGPoint)point timeInterval:(CGFloat)interval;
- (void)addSuccsiveAnnotation:(HDAnnotation *)annotation animated:(BOOL)animate timeInterval:(CGFloat)interval;
- (void)centeredSuccessiveLocation:(CGPoint)centerPoint;
- (void)removeSuccessive:(HDAnnotation *)ann;

@end
