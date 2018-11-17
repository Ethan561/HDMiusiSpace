//
//  HDAnnotationView.h
//  HDMapKit
//
//  Created by Liuzhuan on 13-4-8.
//  Copyright (c) 2013年 hengdawb. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HDBigAnnView,HDCallOutView,HDAnnotation,HDMapView;

@interface HDAnnotationView : UIButton

@property (nonatomic, assign) BOOL         isAnimating;
@property (nonatomic, assign) BOOL         isBig; // 图片是否放大显示
@property (nonatomic, strong) HDAnnotation *annotation;
@property (nonatomic, strong) HDBigAnnView *bigAnn;
@property (nonatomic, strong) HDCallOutView *callOutView;

- (instancetype)initWithAnnotation:(HDAnnotation *)annotation
                            onView:(HDMapView *)mapView
                          animated:(BOOL)animate;

- (CGRect)frameForPoint:(CGPoint)point;


@end







